// Create a helper function in a common package or file
package helpers

import (
	"encoding/json"
	"net/http"
	"xlo/src/core/database"

	"github.com/go-playground/validator/v10"
)

type Response struct {
	Status  string      `json:"status"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
	Error   interface{} `json:"error"`
}

var Validator = validator.New()

func GetUserId(request *http.Request) string {
	user_id := request.Context().Value("user_id").(string)
	return user_id
}

func ParseBody(request *http.Request, data interface{}, validate ...bool) error {
	decodeErr := json.NewDecoder(request.Body).Decode(&data)
	if decodeErr == nil && validate != nil && validate[0] {
		return Validator.Struct(data)
	}
	return decodeErr
}

func UnmarshalJSON(data []byte, target interface{}) error {
	if data == nil {
		return nil
	}
	return json.Unmarshal(data, target)
}

func HandleSuccess(response http.ResponseWriter, statusCode int, message string, data interface{}) {
	database.UnsetRLS()
	payload := Response{Status: "success", Message: message, Data: data, Error: nil}
	response.Header().Set("Content-Type", "application/json")
	response.WriteHeader(statusCode)
	json.NewEncoder(response).Encode(payload)
}

func HandleError(response http.ResponseWriter, statusCode int, message string, err error) {
	// database.UnsetRLS()
	payload := Response{Status: "error", Message: message, Data: nil, Error: err.Error()}
	response.Header().Set("Content-Type", "application/json")
	response.WriteHeader(statusCode)
	json.NewEncoder(response).Encode(payload)
}

// func StrJsonArrayToMap(tmpResults []map[string]interface{}) []map[string]interface{} {
// 	items := make([]map[string]interface{}, 0)
// 	for _, strItems := range tmpResults {
// 		var tmpData map[string]interface{}
// 		json.Unmarshal([]byte(strItems["json_build_object"].(string)), &tmpData)
// 		items = append(items, tmpData)
// 	}
// 	return items
// }

// func StrJsonObjectToMap(tmpResults map[string]interface{}) map[string]interface{} {
// 	if len(tmpResults) == 0 {
// 		return nil
// 	}
// 	var tmpData map[string]interface{}
// 	json.Unmarshal([]byte(tmpResults["json_build_object"].(string)), &tmpData)
// 	return tmpData
// }
