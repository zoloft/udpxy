FROM alpine:latest as builder

LABEL maintainer="zoloft@orcod.io"

ENV HOME /tmp
WORKDIR /tmp

RUN apk -U upgrade

RUN apk add wget make gcc build-base
RUN wget http://www.udpxy.com/download/udpxy/udpxy-src.tar.gz
RUN tar -xzvf udpxy-src.tar.gz

WORKDIR udpxy-1.0.23-12

RUN make
RUN chmod 0755 udpxy udpxrec

FROM alpine:latest as udpxy

COPY --from=builder /tmp/udpxy-1.0.23-12/udpxy /usr/local/bin/udpxy
COPY --from=builder /tmp/udpxy-1.0.23-12/udpxrec /usr/local/bin/udpxrec

EXPOSE 4022

CMD ["/usr/local/bin/udpxy", "-S", "-c", "25", "-M", "300", "-T", "-p", "4022"]

