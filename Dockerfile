FROM golang:1.13-alpine as builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build .


FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/mikrotik-exporter /app/mikrotik-exporter
COPY scripts/start.sh /app/

RUN chmod 755 /app/*

EXPOSE 9436


ENTRYPOINT ["/app/start.sh"]
