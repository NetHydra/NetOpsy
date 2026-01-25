### Building your own NetOpsy image

> [!IMPORTANT]
> The build script is not yet released we will release it soon.
>
>  _Thanks for your patient._


![NetOpsy build system](/assets/netopsy-buildsysten.png)


to build NetOpsy you need at least `2-3GB RAM` and `16GB Disk`

#### Build instructions

You can clone this repository or Download `.tar.gz` or `.zip` from release tag.

Build options:
- `--codename` is branch base will use, as default it will follow NetHydra release `codename`
- `--work-dir` is used for destination build dir `BUILD_DIR`, as default the build path will using `/opt/NetOpsy/build/$ARCH`
- `--with-desktop` is option for building the image with/non desktop `true` or `false` as default it's set with `false` (without desktop).
- `--mirror` is used for using which mirror do you use, the default is NetHydra Mirror `http://repo.rstrike.my.id/`
- `--arch` For now only support for ARM64 architecture.
