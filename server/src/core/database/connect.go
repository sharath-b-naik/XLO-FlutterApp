package database

import (
	"fmt"
	"strconv"
	"xlo/src/core/config"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDB() {
	p := config.Config("DB_PORT")
	port, err := strconv.ParseUint(p, 10, 32)

	if err != nil {
		panic("failed to parse database port")
	}

	host := config.Config("DB_HOST")
	user := config.Config("DB_USERNAME")
	password := config.Config("DB_PASSWORD")
	dbname := config.Config("DB_NAME")

	dsn := fmt.Sprintf(`user=%s password=%s host=%s port=%d dbname=%s sslmode=disable`, user, password, host, port, dbname)
	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic("failed to connect database")
	}

	fmt.Println("Database successfully connected")
}
