FROM alpine
RUN adduser -D user -s /bin/ash
RUN apk add git
USER user

