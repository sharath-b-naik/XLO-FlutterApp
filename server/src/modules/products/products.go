package products

import (
	"encoding/json"
	"fmt"
	"net/http"
	"xlo/src/core/database"
	"xlo/src/core/helpers"
	"xlo/src/models"
	file_upload "xlo/src/upload"
	"xlo/src/utils"

	"github.com/go-chi/chi"
)

func UploadProductImages(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	database.SetRLS(request)
	product_id := chi.URLParam(request, "product_id")

	storage_path := fmt.Sprintf("/products/%s", product_id)
	uploaded_files, err := file_upload.UploadFiles(response, request, storage_path)

	if err != nil {
		helpers.HandleError(response, http.StatusInternalServerError, "Unable to upload product images", err)
		return
	}

	for _, file := range uploaded_files {
		product_image := &models.ProductImage{}
		product_image.ProductId = product_id
		product_image.FileName = file.FileName
		product_image.Url = file.Url
		product_image.ContentType = file.ContentType
		product_image.Size = file.Size
		product_image.StoragePath = file.StoragePath

		if err := db.Create(product_image).Error; err != nil {
			continue
		}
	}

	helpers.HandleSuccess(response, http.StatusOK, "Products images uploaded", uploaded_files)
}

func GetAllProducts(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	database.SetRLS(request)
	user_id := helpers.GetUserId(request)
	mine := request.URL.Query().Get("mine")
	favourite := request.URL.Query().Get("favourite")
	category := request.URL.Query().Get("category")
	products := make([]map[string]interface{}, 0)

	var condition string
	if utils.ConvertToBool(favourite) {
		condition = "join favourite_products fp on fp.product_id = p.id where fp.created_by = $1"
	} else if utils.ConvertToBool(mine) {
		condition = "where p.created_by = $1"
	} else {
		if category != "" {
			condition = fmt.Sprintf("where p.created_by <> $1 AND p.category LIKE '%%%s%%'", category)
			fmt.Println(condition)
		} else {
			condition = "where p.created_by <> $1"
		}
	}

	query := fmt.Sprintf(`SELECT p.*,
	EXISTS (SELECT 1 FROM favourite_products fp WHERE fp.product_id = p.id AND fp.created_by = $1) AS favourite,
    COALESCE((SELECT jsonb_agg(pi) FROM product_images pi WHERE pi.product_id = p.id AND pi IS NOT NULL), '[]'::jsonb) AS images
	FROM products p %s`, condition)

	if err := db.Raw(query, user_id).Scan(&products).Error; err != nil {
		helpers.HandleError(response, http.StatusInternalServerError, "Unable to create a product", err)
		return
	}

	for _, product := range products {
		var images []map[string]interface{}
		var specifications []map[string]interface{}
		json.Unmarshal([]byte(product["images"].(string)), &images)
		json.Unmarshal([]byte(product["specifications"].(string)), &specifications)
		product["images"] = images
		product["specifications"] = specifications
	}

	helpers.HandleSuccess(response, http.StatusOK, "Products fetched", products)
}

func CreateProduct(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	database.SetRLS(request)
	payload := &models.Product{}

	if err := helpers.ParseBody(request, payload, true); err != nil {
		helpers.HandleError(response, http.StatusNotFound, "Provide valid inputs", err)
		return
	}

	payload.CreatedBy = helpers.GetUserId(request)
	if err := db.Create(&payload).Error; err != nil {
		helpers.HandleError(response, http.StatusInternalServerError, "Unable to create a product", err)
		return
	}

	helpers.HandleSuccess(response, http.StatusCreated, "Product created", payload)
}

func DeleteProduct(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	database.SetRLS(request)
	product_id := chi.URLParam(request, "product_id")
	user_id := helpers.GetUserId(request)
	payload := &models.Product{}
	if err := db.Where("id = $1 AND created_by = $2", product_id, user_id).Delete(&payload).Error; err != nil {
		helpers.HandleError(response, http.StatusInternalServerError, "Unable to delete a product", err)
		return
	}

	helpers.HandleSuccess(response, http.StatusCreated, "Product deleted", nil)
}

func CreateFavouriteProduct(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	database.SetRLS(request)

	favouriteProduct := &models.FavouriteProduct{}
	favouriteProduct.CreatedBy = helpers.GetUserId(request)
	favouriteProduct.ProductId = chi.URLParam(request, "product_id")
	if err := db.Create(favouriteProduct).Error; err != nil {
		helpers.HandleError(response, http.StatusInternalServerError, "Unable to add a product to favourite", err)
		return
	}

	helpers.HandleSuccess(response, http.StatusCreated, "Favourite product added", favouriteProduct)
}

func DeleteFavouriteProduct(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	database.SetRLS(request)

	product_id := chi.URLParam(request, "product_id")
	user_id := helpers.GetUserId(request)

	if err := db.Where("product_id = ? AND created_by = ?", product_id, user_id).Delete(&models.FavouriteProduct{}).Error; err != nil {
		helpers.HandleError(response, http.StatusInternalServerError, "Unable to delete a product from favourite", err)
		return
	}

	helpers.HandleSuccess(response, http.StatusOK, "Favourite product removed", nil)
}
