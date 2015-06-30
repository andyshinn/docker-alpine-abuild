FROM alpine:3.2

RUN apk -U add alpine-sdk \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/sh -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && rm -rf /var/cache/apk/*

USER builder

ENTRYPOINT ["abuild", "-r"]

WORKDIR /package

ENV PACKAGER_PRIVKEY /package/abuild.rsa
ENV REPODEST /packages
ENV PACKAGER Glider Labs <team@gliderlabs.com>

ONBUILD RUN abuild-apk update
ONBUILD COPY . /package
ONBUILD RUN sudo mv *.rsa.pub /etc/apk/keys/ \
  && sudo mkdir /packages \
  && sudo chown -R builder /package /packages
