# Image allows subdirectory upload - https://github.com/mayth/go-simple-upload-server/pull/31/files
# Image stored in GCS with the help of gcsfuse
FROM execmd/go-simple-upload-server AS build-env

FROM alpine:3.16 AS runtime-env

COPY --from=build-env /usr/local/bin/app /usr/local/bin/app

RUN apk --update --no-cache add git fuse fuse-dev go build-base

ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

RUN go install github.com/googlecloudplatform/gcsfuse@latest

WORKDIR /usr/local/bin

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

CMD ["./entrypoint.sh"]