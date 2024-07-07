package config

import (
	"os"

	"github.com/joho/godotenv"
)

func Config(key string) string {
	return os.Getenv(key)
}

func SetupEnv() {
	err := godotenv.Load(".env")
	if err != nil {
		db_host := Config("DB_HOST")
		if db_host == "" {
			panic("Error loading .env file")
		}
	}
}
