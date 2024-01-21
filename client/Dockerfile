# syntax=docker/dockerfile:1

FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.21
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# Set destination for COPY
WORKDIR /app

COPY go.mod go.sum ./
COPY *.go ./

# Build
RUN GOOS=${TARGETOS:-linux} GOARCH=${TARGETARCH:-amd64} go build -o /postgres-client

# Run
CMD ["/postgres-client"]
