FROM alpine:3.9
RUN apk --no-cache add alpine-sdk coreutils cmake \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/ash -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && mkdir /packages \
  && chown builder:abuild /packages
COPY /abuilder /bin/
USER builder
ENTRYPOINT ["abuilder", "-r"]
WORKDIR /home/builder/package
ENV RSA_PRIVATE_KEY_NAME ssh.rsa
ENV PACKAGER_PRIVKEY /home/builder/${RSA_PRIVATE_KEY_NAME}
ENV REPODEST /packages
VOLUME ["/home/builder/package"]
