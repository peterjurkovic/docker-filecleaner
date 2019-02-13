FROM alpine:latest

COPY clean.sh /
RUN chmod +x /clean.sh