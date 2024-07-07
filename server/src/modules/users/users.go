package users

import (
	"fmt"
	"net/http"
	"strings"
	"xlo/src/core/database"
	"xlo/src/core/helpers"
	"xlo/src/models"
	file_upload "xlo/src/upload"
	"xlo/src/utils"
)

func GetUserDetails(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	database.SetRLS(request)
	userId := helpers.GetUserId(request)
	user := &models.User{}

	if err := db.Where("id = ?", userId).First(user).Error; err != nil {
		helpers.HandleError(response, http.StatusInternalServerError, "Couldn't get user details", err)
		return
	}

	helpers.HandleSuccess(response, http.StatusCreated, "User details fetched", user)
}

func UploadPhoto(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	database.SetRLS(request)
	user_id := helpers.GetUserId(request)

	user := &models.User{}
	if err := db.Where("id = ?", user_id).First(user).Error; err != nil {
		helpers.HandleError(response, http.StatusInternalServerError, "Unable to upload photo(1)", err)
		return
	}

	old_storage_path := strings.Split(user.PhotoUrl, "the-bucket")
	fmt.Println(old_storage_path)
	if len(old_storage_path) > 1 {
		path := utils.RemoveFirstSlash(old_storage_path[1])
		if err := file_upload.DeleteFileFromStorage([]string{path}); err != nil {
			helpers.HandleError(response, http.StatusInternalServerError, "Unable to upload photo(2)", err)
			return
		}
	}

	storage_path := fmt.Sprintf("users/photo/%s", user_id)
	uploaded_files, err := file_upload.UploadFiles(response, request, storage_path)

	if err != nil {
		helpers.HandleError(response, http.StatusInternalServerError, err.Error(), err)
		return
	}

	user.PhotoUrl = uploaded_files[0].Url
	if err := db.Where("id = ?", user_id).Updates(user).First(user).Error; err != nil {
		helpers.HandleError(response, http.StatusInternalServerError, "Unable to upload photo(4)", err)
		return
	}

	helpers.HandleSuccess(response, http.StatusOK, "Products images uploaded", user)
}

func UpdateUserDetails(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	database.SetRLS(request)
	user := &models.User{}

	if err := helpers.ParseBody(request, &user); err != nil {
		helpers.HandleError(response, http.StatusInternalServerError, "Provide valid inputs", err)
		return
	}

	if err := db.Model(&models.User{}).Where("id = ?", helpers.GetUserId(request)).Updates(&user).First(&user).Error; err != nil {
		helpers.HandleError(response, http.StatusInternalServerError, "Couldn't update user details", err)
		return
	}

	helpers.HandleSuccess(response, http.StatusCreated, "User details updated", user)
}
