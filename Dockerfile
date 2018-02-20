# We are using a very small base image for our runtime image
FROM alpine:latest

COPY godocker /usr/local/bin/godocker
COPY static /static

CMD ["godocker"]