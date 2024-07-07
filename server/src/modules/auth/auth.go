package auth

import (
	"errors"
	"net/http"
	"time"
	"xlo/src/core/config"
	"xlo/src/core/database"
	"xlo/src/core/helpers"
	"xlo/src/models"

	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

func _issueJwtToken(sub string, phone string) (string, error) {
	claims := jwt.MapClaims{}
	claims["sub"] = sub
	claims["phone"] = phone
	claims["iat"] = time.Now().Unix()
	claims["exp"] = time.Now().Add(time.Hour * 24 * 30).Unix() // Token is valid for 30 days  time.Now().Add(time.Hour * 24).Unix(),
	tokenClaimer := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	var jwtSecret string = config.Config("JWT_SECRET")
	token, err := tokenClaimer.SignedString([]byte(jwtSecret))
	return token, err
}

func _generateHashPassword(password string) (string, error) {
	bytePassword := []byte(password)
	hash, err := bcrypt.GenerateFromPassword(bytePassword, bcrypt.DefaultCost)
	if err != nil {
		return "", err
	}
	return string(hash), nil
}

func CreateAccount(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	payload := &models.Auth{}

	if err := helpers.ParseBody(request, payload, true); err != nil {
		helpers.HandleError(response, http.StatusNotFound, "Provide valid inputs", err)
		return
	}

	user_exists := make(map[string]interface{})
	query := `select * from auth where phone = $1 limit 1`
	if err := db.Table("auth").Raw(query, payload.Phone).Scan(&user_exists).Error; err != nil {
		if !errors.Is(gorm.ErrRecordNotFound, err) {
			helpers.HandleError(response, http.StatusNotFound, "Provide valid inputs", err)
			return
		}
	}

	if user_exists["phone"] != nil && user_exists["phone"] == payload.Phone {
		err := errors.New("phone already exists")
		helpers.HandleError(response, http.StatusNotFound, "Phone already registered", err)
		return
	}

	hashedPassword, hashPasswordErr := _generateHashPassword(payload.Password)
	if hashPasswordErr != nil {
		helpers.HandleError(response, http.StatusNotFound, "Provide valid inputs", hashPasswordErr)
		return
	}

	payload.Password = hashedPassword
	if err := db.Table("auth").Create(&payload).First(&payload).Error; err != nil {
		if errors.Is(err, gorm.ErrDuplicatedKey) {
			helpers.HandleError(response, http.StatusConflict, "Account already exist. Please sign in", nil)
			return
		}
		helpers.HandleError(response, http.StatusInternalServerError, "Unable to create account", err)
		return
	}

	user := &models.User{}
	user.Id = payload.Id
	user.Phone = payload.Phone
	db.Create(&user)

	helpers.HandleSuccess(response, http.StatusCreated, "Account created. Now login", nil)
}

func LogIn(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	payload := &models.AuthInput{}

	if err := helpers.ParseBody(request, payload, true); err != nil {
		helpers.HandleError(response, http.StatusNotFound, "Provide valid inputs", err)
		return
	}

	auth := &models.Auth{}
	if err := db.Table("auth").Where("phone = ?", payload.Phone).First(auth).Error; err != nil {
		helpers.HandleError(response, http.StatusNotFound, "User doesn't exists", err)
		return
	}

	password_err := bcrypt.CompareHashAndPassword([]byte(auth.Password), []byte(payload.Password))
	if password_err != nil {
		helpers.HandleError(response, http.StatusBadRequest, "Password incorrect", password_err)
		return
	}

	token, tokenErr := _issueJwtToken(auth.Id, payload.Phone)
	if tokenErr != nil {
		helpers.HandleError(response, http.StatusBadRequest, "Unable to generate token", tokenErr)
		return
	}

	result := make(map[string]interface{})
	result["token"] = token
	helpers.HandleSuccess(response, http.StatusOK, "Sign in successful", result)
}

func ChangePassword(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	body := &models.ResetPasswordInput{}
	user_id := helpers.GetUserId(request)

	if err := helpers.ParseBody(request, body, true); err != nil {
		helpers.HandleError(response, http.StatusBadRequest, "Provider valid inputs", err)
		return
	}

	if body.NewPassword != body.ConfirmNewPassword {
		err := errors.New("password not matched")
		helpers.HandleError(response, http.StatusBadRequest, "Password not matched", err)
		return
	}

	auth := &models.Auth{}
	if err := db.Table("auth").Where("id = ?", user_id).First(auth).Error; err != nil {
		helpers.HandleError(response, http.StatusForbidden, "User not found", err)
		return
	}

	password_err := bcrypt.CompareHashAndPassword([]byte(auth.Password), []byte(body.OldPassword))
	if password_err != nil {
		helpers.HandleError(response, http.StatusBadRequest, "Old password incorrect", password_err)
		return
	}

	hashedPassword, hashPasswordErr := _generateHashPassword(body.NewPassword)
	if hashPasswordErr != nil {
		helpers.HandleError(response, http.StatusForbidden, "Something went wrong", hashPasswordErr)
		return
	}

	if err := db.Table("auth").Where("id = ?", user_id).Update("password", hashedPassword).Error; err != nil {
		helpers.HandleError(response, http.StatusForbidden, "Unable to change password", hashPasswordErr)
		return
	}

	helpers.HandleSuccess(response, http.StatusOK, "Password changed", nil)
}
