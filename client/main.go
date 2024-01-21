package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	_ "github.com/lib/pq"
)

var (
	host     = os.Getenv("DB_HOST")
	port     = 5432
	user     = os.Getenv("DB_USER")
	password = os.Getenv("DB_PASS")
	dbname   = "postgres"
)

func main() {
	// PostgreSQL connection string
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	// Open the connection
	db, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Check the connection
	err = db.Ping()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Successfully connected!")

	for {
		// Query the database version
		var version string
		err = db.QueryRow("SELECT version();").Scan(&version)
		if err != nil {
			log.Fatal(err)
		}

		fmt.Println("Database Version:", version)
		time.Sleep(time.Second * 5)
	}
}
