package models

import (
	"time"
)

type Auth struct {
	Id        string    `json:"id" gorm:"type:uuid; not null; default:uuid_generate_v4()"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
	Phone     string    `json:"phone" validate:"required"`
	Password  string    `json:"password" validate:"required"`
}

type AuthInput struct {
	Phone    string `json:"phone" validate:"required"`
	Password string `json:"password" validate:"required"`
}

type ResetPasswordInput struct {
	OldPassword        string `json:"old_password" validate:"required"`
	NewPassword        string `json:"new_password" validate:"required"`
	ConfirmNewPassword string `json:"confirm_new_password" validate:"required"`
}

type User struct {
	Id        string    `json:"id" gorm:"type:uuid; not null default:uuid_generate_v4()"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
	Name      string    `json:"name"`
	Phone     string    `json:"phone"`
	Email     string    `json:"email"`
	PhotoUrl  string    `json:"photo_url"`
}
