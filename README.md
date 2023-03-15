# hvqmsample

Sample code taken from <https://github.com/CrashOveride95/n64sdkmod/tree/master/packages/n64-demos/usr/src/PR/demos/hvqmsample>.

This repository has been adapted to minimize system-wide dependencies and include as most as possible in the same repository.

## Dependencies

* make
* build-essential
* binutils-mips-linux-gnu
* gcc-mips-linux-gnu

Under Debian / Ubuntu, you can install them with the following commands:

```bash
sudo apt update
sudo apt install make build-essential binutils-mips-linux-gnu gcc-mips-linux-gnu
```

## Building

```bash
make
```

This will generate a rom at `build/sample.z64`
