package database

import (
	"fmt"
	"net/http"
)

func SetRLS(request *http.Request) {
	db := DB
	userId := request.Context().Value("user_id").(string)
	query := fmt.Sprintf(`SELECT set_config('request.jwt.claims', '{"sub": "%s"}', false)`, userId)
	db.Exec(query)
}

func UnsetRLS() {
	db := DB
	query := `RESET request.jwt.claims.sub`
	db.Exec(query)
}
