package main

import (
	"database/sql"
	"log"

	"github.com/TemurMannonov/simple_bank/api"
	db "github.com/TemurMannonov/simple_bank/db/sqlc"
	"github.com/TemurMannonov/simple_bank/util"
	_ "github.com/golang/mock/mockgen/model" // for downloading mocken/model folder
	_ "github.com/lib/pq"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("cannot load config:", err)
	}

	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to db: ", err)
	}

	store := db.NewStore(conn)
	server, err := api.NewServer(config, store)
	if err != nil {
		log.Fatal("cannot create server: ")
	}

	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("cannot start server: ", err)
	}
}
