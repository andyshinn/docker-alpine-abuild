# Alpine Package Builder

This is a Docker image for building Alpine Linux packages.

## Usage

In your Alpine Linux package source folder (the folder with your APKBUILD) create a `Dockerfile`. You need to specify the `FROM` image and `PACKAGER_PRIVKEY` environment variable. This is the location of your private key file. The `ONBUILD` triggers will copy `*.rsa` to `/package` and `*.rsa.pub` to `/etc/apk/keys`.

Here is an example `Dockerfile`:

```
FROM andyshinn/alpine-abuild
ENV PACKAGER_PRIVKEY /package/andys@andyshinn.as-54f23052.rsa
```

Then build your Docker image for the package with `docker build -t package .` and run it with `docker run --name package package` to build the Alpine Linux package. You can copy the `apk` file out of the container after it is build with `docker cp package:/packages .`.

You will have a `packages` folder locally with your built Alpine Linux packages.

## Environment

There are a number of environment variables you can change at package build time:

* `PACKAGER_PRIVKEY`: defaults to `/package/abuild.rsa`
* `REPODEST`: defaults to `/packages`
* `PACKAGER`: defaults to `Glider Labs <team@gliderlabs.com>`

## Example

Check out https://github.com/andyshinn/alpine-pkg-hub for an example of this process.
