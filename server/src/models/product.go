package models

import (
	"encoding/json"
	"time"
)

type Product struct {
	Id             string          `json:"id" gorm:"type:uuid; not null; default:uuid_generate_v4()"`
	CreatedAt      time.Time       `json:"created_at"`
	UpdatedAt      time.Time       `json:"updated_at"`
	CreatedBy      string          `json:"created_by" gorm:"type:uuid; not null"`
	Name           string          `json:"name" validate:"required"`
	Description    string          `json:"description" validate:"required"`
	Category       string          `json:"category" validate:"required"`
	Price          int             `json:"price" validate:"required"`
	Used           bool            `json:"used"`
	Specifications json.RawMessage `json:"specifications"`
}

type ProductImage struct {
	Id          string    `gorm:"type:uuid; default:uuid_generate_v4()" json:"id"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
	ProductId   string    `json:"product_id" gorm:"type:uuid;not null"`
	FileName    string    `json:"file_name" validate:"required"`
	Url         string    `json:"url" validate:"required"`
	Size        int64     `json:"size" validate:"required"`
	StoragePath string    `json:"storage_path" validate:"required"`
	ContentType string    `json:"content_type" validate:"required"`
}

type FavouriteProduct struct {
	Id        string    `json:"id" gorm:"type:uuid; not null; default:uuid_generate_v4()"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
	ProductId string    `json:"product_id" gorm:"type:uuid; not null"`
	CreatedBy string    `json:"created_by" gorm:"type:uuid; not null"`
}
