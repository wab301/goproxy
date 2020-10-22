FROM golang:1.14.7-alpine AS build

RUN apk add --no-cache -U make git mercurial subversion bzr fossil

RUN go env -w GOPROXY="https://goproxy.cn,direct"
COPY . /src/goproxy
RUN cd /src/goproxy &&\
    export CGO_ENABLED=0 &&\
    make

FROM golang:1.14.7-alpine

RUN apk add --no-cache -U git mercurial subversion bzr fossil

COPY --from=build /src/goproxy/bin/goproxy /goproxy

VOLUME /go

EXPOSE 8081

ENTRYPOINT ["/goproxy"]
CMD []
