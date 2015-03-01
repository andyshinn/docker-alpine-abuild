FROM gliderlabs/alpine:3.1

RUN apk-install alpine-sdk \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/sh -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

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
