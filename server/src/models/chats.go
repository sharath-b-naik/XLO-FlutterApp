package models

import (
	"time"
)

type ChatRoom struct {
	Id           string    `json:"id" gorm:"type:uuid; not null; default:uuid_generate_v4()"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
	Participant1 string    `json:"participant1" gorm:"type:uuid; not null;" validate:"required"`
	Participant2 string    `json:"participant2" gorm:"type:uuid; not null;" validate:"required"`
}

type ChatMessage struct {
	Id         string    `json:"id" gorm:"type:uuid; not null; default:uuid_generate_v4()"`
	CreatedAt  time.Time `json:"created_at"`
	UpdatedAt  time.Time `json:"updated_at"`
	ChatRoomId string    `json:"chat_room_id" validate:"required"`
	SentBy     string    `json:"sent_by" validate:"required"`
	Message    string    `json:"message" validate:"required"`
}
