# Alpine Package Builder

This is a Docker image for building Alpine Linux packages.

## Usage

The builder is typically run from your Alpine Linux package source directory (changing `~/.abuild/abuild.rsa` to your packager private key location):

```
docker run -e RSA_PRIVATE_KEY="$(cat ~/.abuild/abuild.rsa)" -v $(pwd):/home/builder/package -v $(pwd)/packages:/home/builder/packages andyshinn/alpine-abuild
```

This would build the package at your current working directory, and place the resulting packages in `packages` at your current working directory.

You can also run the builder anywhere. You just need to mount your package source and build directories to `/home/builder/package` and `/home/builder/packages`, respectively.

## Environment

There are a number of environment variables you can change at package build time:

* `RSA_PRIVATE_KEY`: This is the contents of your RSA private key. This is optional. You should use `PACKAGER_PRIVKEY` and mount your private key if not using `PACKAGER_PRIVKEY`.
* `RSA_PRIVATE_KEY_NAME`: Defaults to `ssh.rsa`. This is the name we will set the private key file as when using `RSA_PRIVATE_KEY`. The file will be written out to `/home/builder/$RSA_PRIVATE_KEY_NAME`.
* `PACKAGER_PRIVKEY`: Defaults to `/package/abuild.rsa`. This is generally used if you are bind mounting your private key instead of passing it in with `RSA_PRIVATE_KEY`.
* `REPODEST`: defaults to `/packages`. If you want to override the destination of the build packages.
* `PACKAGER`: defaults to `Glider Labs <team@gliderlabs.com>`. This is the name of the package used in package metadata.

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

```a
mkdir ~/.abuild
docker cp keys:/home/builder/.abuild/team@gliderlabs.com-5592f9b1.rsa ~/.abuild/
docker cp keys:/home/builder/.abuild/team@gliderlabs.com-5592f9b1.rsa.pub ~/.abuild/
```

Put your key files in a same place and destroy this container:

```
docker rm -f keys
```

## Example

Check out https://github.com/andyshinn/alpine-pkg-glibc for an example package that gets built using this.
