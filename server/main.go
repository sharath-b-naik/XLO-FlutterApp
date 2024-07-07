package main

import (
	"log"
	"net/http"
	"xlo/src/core/config"
	"xlo/src/core/database"
	"xlo/src/core/router"

	"github.com/go-chi/chi"
	"github.com/go-chi/cors"
)

func main() {
	app := chi.NewRouter()
	app.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "PATCH", "DELETE"},
		AllowedHeaders:   []string{"*"},
		AllowCredentials: false,
	}))

	config.SetupEnv()
	database.ConnectDB()
	router.SetupRoutes(app) // Routes
	log.Fatal(http.ListenAndServe(":3000", app))
}
