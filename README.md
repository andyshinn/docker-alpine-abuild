# Alpine Package Builder

This is a Docker image for building Alpine Linux packages.

## Usage

There are currently three tags to choose from:

* `andyshinn/alpine-abuild:v1`: based on Alpine 3.3
* `andyshinn/alpine-abuild:v2`: based on Alpine 3.4
* `andyshinn/alpine-abuild:edge`: based on Alpine edge (includes testing repository as well)

The builder is typically run from your Alpine Linux package source directory (changing `~/.abuild/mykey.rsa` and `~/.abuild/mykey.rsa.pub` to your packager private and public key locations):

```
docker run \
	-e RSA_PRIVATE_KEY="$(cat ~/.abuild/mykey.rsa)" \
	-e RSA_PRIVATE_KEY_NAME="mykey.rsa" \
	-v "$PWD:/home/builder/package" \
	-v "$HOME/.abuild/packages:/packages" \
	-v "$HOME/.abuild/mykey.rsa.pub:/etc/apk/keys/mykey.rsa.pub" \
	andyshinn/alpine-abuild:v2
```

This would build the package at your current working directory, and place the resulting packages in `~/.abuild/packages/builder/x86_64`. Subsequent builds of packages will update the `~/.abuild/packages/builder/x86_64/APKINDEX.tar.gz` file.

You can also run the builder anywhere. You just need to mount your package source and build directories to `/home/builder/package` and `/packages`, respectively.

## Environment

There are a number of environment variables you can change at package build time:

* `RSA_PRIVATE_KEY`: This is the contents of your RSA private key. This is optional. You should use `PACKAGER_PRIVKEY` and mount your private key if not using `RSA_PRIVATE_KEY`.
* `RSA_PRIVATE_KEY_NAME`: Defaults to `ssh.rsa`. This is the name we will set the private key file as when using `RSA_PRIVATE_KEY`. The file will be written out to `/home/builder/$RSA_PRIVATE_KEY_NAME`.
* `PACKAGER_PRIVKEY`: Defaults to `/home/builder/.abuild/$RSA_PRIVATE_KEY_NAME`. This is generally used if you are bind mounting your private key instead of passing it in with `RSA_PRIVATE_KEY`.
* `REPODEST`: Defaults to `/packages`. If you want to override the destination of the build packages. You must also be sure the `builder` user has access to write to the destination. The `abuilder` entry point will attempt to `mkdir -p` this location.
* `PACKAGER`: Defaults to `Glider Labs <team@gliderlabs.com>`. This is the name of the package used in package metadata.

## Keys

You can use this image to generate keys if you don't already have them. Generate them in a container using the following command (replacing `Glider Labs <team@gliderlabs.com>` with your own name and email):

```
docker run --name keys --entrypoint abuild-keygen -e PACKAGER="Glider Labs <team@gliderlabs.com>" andyshinn/alpine-abuild:v2 -n
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

```a
mkdir ~/.abuild
docker cp keys:/home/builder/.abuild/team@gliderlabs.com-5592f9b1.rsa ~/.abuild/
docker cp keys:/home/builder/.abuild/team@gliderlabs.com-5592f9b1.rsa.pub ~/.abuild/
```

Put your key files in a same place and destroy this container:

```
docker rm -f keys
```
