FROM gliderlabs/alpine:3.2
RUN apk -U add alpine-sdk \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/sh -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && rm -rf /var/cache/apk/*
ADD /abuilder /bin/
USER builder
ENTRYPOINT ["abuilder", "-r"]
WORKDIR /home/builder/package
ENV PACKAGER_PRIVKEY /home/builder/abuild.rsa
