package chats

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"xlo/src/core/database"
	"xlo/src/core/helpers"
	"xlo/src/models"

	"github.com/go-chi/chi"
	"gorm.io/gorm"
)

func CreateRoom(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	database.SetRLS(request)
	participant_1 := helpers.GetUserId(request)
	participant_2 := request.URL.Query().Get("receiver_id")

	room := &models.ChatRoom{}
	room.Participant1 = participant_1
	room.Participant2 = participant_2

	if participant_1 == "" || participant_2 == "" {
		err := errors.New("provide valid participant")
		helpers.HandleError(response, http.StatusConflict, "You cannot chat at the moment", err)
		return
	}

	if err := db.Create(&room).Error; err != nil {
		helpers.HandleError(response, http.StatusConflict, "You cannot chat at the moment", err)
		return
	}

	helpers.HandleSuccess(response, http.StatusCreated, "Room created", room)
}

func CreateChat(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	database.SetRLS(request)
	user_id := helpers.GetUserId(request)
	chat_room_id := chi.URLParam(request, "chat_room_id")
	message := &models.ChatMessage{}
	message.SentBy = user_id
	message.ChatRoomId = chat_room_id
	if err := helpers.ParseBody(request, message, true); err != nil {
		helpers.HandleError(response, http.StatusNotFound, "Provide valid inputs", err)
		return
	}

	if err := db.Create(message).Error; err != nil {
		helpers.HandleError(response, http.StatusInternalServerError, "Message not sent", err)
		return
	}

	var savedMessage map[string]interface{}
	query := `select cm.*, to_jsonb(sender.*) as sender from chat_messages cm
				join users sender on sender.id = cm.sent_by
				where cm.id = ? AND cm.chat_room_id = ? LIMIT 1`

	if err := db.Model(models.ChatMessage{}).Raw(query, message.Id, chat_room_id).Scan(&savedMessage).Error; err != nil {
		helpers.HandleError(response, http.StatusNotFound, "Chat room not found", err)
		return
	}

	var sender map[string]interface{}
	json.Unmarshal([]byte(savedMessage["sender"].(string)), &sender)
	savedMessage["sender"] = sender
	delete(savedMessage, "sent_by")

	helpers.HandleSuccess(response, http.StatusCreated, "Message created", savedMessage)
}

func GetChats(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	database.SetRLS(request)
	chat_room_id := chi.URLParam(request, "chat_room_id")
	messages := make([]map[string]interface{}, 0)

	query := `select cm.*, to_jsonb(u.*) as sender from chat_messages cm
				join users u on u.id = cm.sent_by
				where chat_room_id = ?`

	if err := db.Model(models.ChatMessage{}).Raw(query, chat_room_id).Scan(&messages).Error; err != nil {
		helpers.HandleError(response, http.StatusNotFound, "Chat room not found", err)
		return
	}

	for _, message := range messages {
		var sender map[string]interface{}
		json.Unmarshal([]byte(message["sender"].(string)), &sender)
		message["sender"] = sender
		delete(message, "sent_by")
	}

	helpers.HandleSuccess(response, http.StatusOK, "Messages fetched", messages)
}

func GetChatRooms(response http.ResponseWriter, request *http.Request) {
	db := database.DB
	database.SetRLS(request)
	participant1 := helpers.GetUserId(request)
	participant2 := request.URL.Query().Get("receiver_id")
	rooms := make([]map[string]interface{}, 0)

	query := `SELECT cr.*, to_jsonb(u.*) AS recipient FROM chat_rooms cr
			  LEFT JOIN users u ON (u.id = CASE WHEN cr.participant1 = $1 THEN cr.participant2 ELSE cr.participant1 END)`

	if participant2 != "" {
		condition := `WHERE (cr.participant1 = $1 AND cr.participant2 = $2) OR (cr.participant1 = $2 AND cr.participant2 = $1)`
		raw := fmt.Sprintf("%s %s", query, condition)
		if err := db.Raw(raw, participant1, participant2).Scan(&rooms).Error; err != nil {
			if !errors.Is(gorm.ErrRecordNotFound, err) {
				helpers.HandleError(response, http.StatusInternalServerError, "Couldn't get room details", err)
				return
			}
		}
	} else {
		condition := `WHERE cr.participant1 = $1 OR cr.participant2 = $1;`
		raw := fmt.Sprintf("%s %s", query, condition)
		if err := db.Raw(raw, participant1).Scan(&rooms).Error; err != nil {
			helpers.HandleError(response, http.StatusInternalServerError, "Couldn't get romms", err)
			return
		}
	}

	//
	for _, room := range rooms {
		var recipient map[string]interface{}
		json.Unmarshal([]byte(room["recipient"].(string)), &recipient)
		room["recipient"] = recipient
	}

	helpers.HandleSuccess(response, http.StatusOK, "Room fetched", rooms)
}
