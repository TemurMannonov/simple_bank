# Multistage dockerfile (it is for minimizing dockerfile)
# -- Build stage --
FROM golang:1.19.1-alpine3.16 AS builder

# workdir is the current working directory inside docker image 
# all dockerfile instructions will be executed inside workdir
WORKDIR /app   

# first dot means that copy everything from current folder (simple_bank folder)
# second dot is the current working directory inside the image (/app folder)
COPY . .

RUN go build -o main main.go


# -- Run stage --
FROM alpine:3.16
WORKDIR /app

# copying main binary file to workdir
COPY --from=builder /app/main .
COPY app.env .
EXPOSE 8080

# running built image
CMD ["/app/main"]
 

# building image and run image
# docker build -t simplebank:latest .
# docker run --name simplebank -p 8080:8080 simplebank:latest
# production mode
# docker run --name simplebank -p 8080:8080 -e GIN_MODE=release simplebank:latest

# create docker network
# docker network create bank-network
# docker network connect bank-network postgres

# docker run --name simplebank --network bank-network -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE="postgresql://postgres:postgres@postgres_database_1:5432/simple_bank?sslmode=disable" simplebank:latest