package middleware

import (
	"context"
	"net/http"
	"xlo/src/core/config"
	"xlo/src/core/helpers"

	"github.com/go-chi/jwtauth/v5"
)

func Protected(next http.Handler) http.Handler {
	return http.HandlerFunc(func(response http.ResponseWriter, request *http.Request) {
		token := jwtauth.TokenFromHeader(request)
		tokenAuth := jwtauth.New("HS256", []byte(config.Config("JWT_SECRET")), nil)
		payload, err := jwtauth.VerifyToken(tokenAuth, token)
		if err != nil {
			helpers.HandleError(response, http.StatusUnauthorized, "Unauthorized", err)
			return
		}

		ctx := context.WithValue(request.Context(), "user_id", payload.Subject())
		next.ServeHTTP(response, request.WithContext(ctx))
	})
}
