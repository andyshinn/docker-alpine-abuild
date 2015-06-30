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

## Keys

You can use this image to generate keys if you don't already have them. Generate them in a container using the following command (replacing `Glider Labs <team@gliderlabs.com>` with your own name and email):

```
docker run --name keys --entrypoint abuild-keygen -e PACKAGER="Glider Labs <team@gliderlabs.com>" andyshinn/alpine-abuild -n
```

You'll see some output like the following:

```
Generating RSA private key, 2048 bit long modulus
.............................................+++
.................................+++
e is 65537 (0x10001)
writing RSA key
>>>
>>> You'll need to install /home/builder/.abuild/team@gliderlabs.com-5592f9b1.rsa.pub into
>>> /etc/apk/keys to be able to install packages and repositories signed with
>>> /home/builder/.abuild/team@gliderlabs.com-5592f9b1.rsa
>>>
>>> You might want add following line to /home/builder/.abuild/abuild.conf:
>>>
>>> PACKAGER_PRIVKEY="/home/builder/.abuild/team@gliderlabs.com-5592f9b1.rsa"
>>>
>>>
>>> Please remember to make a safe backup of your private key:
>>> /home/builder/.abuild/team@gliderlabs.com-5592f9b1.rsa
>>>
```

This output contains the path to your public and private keys. Copy the keys out of the container:

```
docker cp keys:/home/builder/.abuild/team@gliderlabs.com-5592f9b1.rsa .
docker cp keys:/home/builder/.abuild/team@gliderlabs.com-5592f9b1.rsa.pub .
```

Put your key files in a same place and destroy this container:

```
docker rm -f keys
```

## Example

Check out https://github.com/andyshinn/alpine-pkg-hub for an example of this process.
