# Alpine Package Builder

This is a Docker image for building Alpine Linux packages for the Asymworks [Package Repository](https://pkgs.asymworks.net). The image is based on Andy Shinn's [andyshinn/alpine-abuild](https://github.com/andyshinn/docker-alpine-abuild) with some updates for multi-arch building to target Raspberry Pi devices and with the public APK signing key baked in.

## Usage

Run the builder from the package source directory containing the `APKBUILD` file and supply the private signing key. The package is automatically set up to use the [packages@asymworks.com](https://pkgs.asymworks.com/packages@asymworks.com-5ff0a833.rsa.pub) signing key. This key must be downloaded and put in the `/etc/apk/keys` directory prior to installing the package.

```
docker run --rm \
	-e RSA_PRIVATE_KEY="$(cat ~/.abuild/packages@asymworks.com-5ff0a833.rsa)" 
	-v "$PWD:/home/builder/package" 
	-v "$HOME/.abuild/packages:/packages" 
	asymworks/alpine-abuild:armv7-v3.12
```

This would build the package at your current working directory, and place the resulting packages in `~/.abuild/packages/builder/armv7`. Subsequent builds of packages will update the `~/.abuild/packages/builder/armv7/APKINDEX.tar.gz` file. The `armv7` architecture tag can be replaced with any of the supported [docker tags](https://hub.docker.com/r/asymworks/alpine-abuild/tags).

## Environment

There are a number of environment variables you can change at package build time:

* `RSA_PRIVATE_KEY`: This is the contents of your RSA private key. This is optional. You should use `PACKAGER_PRIVKEY` and mount your private key if not using `RSA_PRIVATE_KEY`.
* `RSA_PRIVATE_KEY_NAME`: Defaults to `packages@asymworks.com-5ff0a833.rsa`. This is the name we will set the private key file as when using `RSA_PRIVATE_KEY`. The file will be written out to `/home/builder/$RSA_PRIVATE_KEY_NAME`.
* `PACKAGER_PRIVKEY`: Defaults to `/home/builder/.abuild/$RSA_PRIVATE_KEY_NAME`. This is generally used if you are bind mounting your private key instead of passing it in with `RSA_PRIVATE_KEY`.
* `REPODEST`: Defaults to `/packages`. If you want to override the destination of the build packages. You must also be sure the `builder` user has access to write to the destination. The `abuilder` entry point will attempt to `mkdir -p` this location.

## APK Cache

The builder has configured APK to use `/var/cache/apk` as its cache directory. This directory can be mounted as a volume to prevent the repeated download of dependencies when building packages.
