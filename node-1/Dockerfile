FROM alpine:latest 

RUN apk update 

COPY ./gptPing.sh ./
RUN chmod +x ./gptPing.sh
CMD /bin/sh gptPing.sh
