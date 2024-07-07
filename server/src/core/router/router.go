package router

import (
	"fmt"
	"net/http"
	"xlo/src/core/middleware"
	"xlo/src/modules/auth"
	"xlo/src/modules/chats"
	"xlo/src/modules/products"
	"xlo/src/modules/users"

	"github.com/go-chi/chi"
)

func SetupRoutes(app *chi.Mux) {

	app.Get("/ping", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("pong"))
	})

	app.Post("/auth/create-account", auth.CreateAccount)
	app.Post("/auth/login", auth.LogIn)
	app.With(middleware.Protected).Post("/auth/change-password", auth.ChangePassword)

	app.With(middleware.Protected).Route("/users", func(router chi.Router) {
		router.Get("/", users.GetUserDetails)
		router.Put("/", users.UpdateUserDetails)
		router.Post("/photo/upload", users.UploadPhoto)
	})

	app.With(middleware.Protected).Route("/products", func(router chi.Router) {
		router.Post("/{product_id}/upload/files", products.UploadProductImages) // Upload product images

		router.Get("/", products.GetAllProducts)
		router.Post("/", products.CreateProduct)
		router.Delete("/{product_id}", products.DeleteProduct)
		router.Post("/{product_id}/favourites", products.CreateFavouriteProduct)
		router.Delete("/{product_id}/favourites", products.DeleteFavouriteProduct)
	})

	app.With(middleware.Protected).Route("/chat-rooms", func(router chi.Router) {
		router.Get("/", chats.GetChatRooms)
		router.Post("/", chats.CreateRoom)
		router.Get("/{chat_room_id}/messages", chats.GetChats)
		router.Post("/{chat_room_id}/messages", chats.CreateChat)
	})

	chi.Walk(app, func(method, route string, handler http.Handler, middlewares ...func(http.Handler) http.Handler) error {
		fmt.Printf("%s\t%s\n", method, route)
		return nil
	})
}
