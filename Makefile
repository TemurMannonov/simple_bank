DB_URL=postgresql://postgres:postgres@localhost:5432/simple_bank?sslmode=disable

postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

# mock:
# 	mockgen -package mockdb -destination db/mock/store.db github.com/TemurMannonov/simple_bank/db/sqlc Store

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/TemurMannonov/simple_bank/db/sqlc Store

.PHONY:	postgres createdb dropdb migrateup migratedown sqlc test server mock