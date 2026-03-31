# Installing NetOpsy

## Standard NetOpsy (LIVE)

NetOpsy focuses on `Digital forensic investigation`, that's why by default NetOpsy is not installed on `Bare Metal`, but is run via `Bootable Media`, generally `Flash Drive`, so that when booting `NetOpsy will always be clean` and not contaminated with other systems.

Install step:

You need a `Flash Drive` at least with `16GB` capacity.
> Note: This process will erase every data on your `Flash drive`

After Downloading NetOpsy `ISO` Image you need to burn it into the `Flash Drive`
as example our `Flash drive` are located in `/dev/sda`.

```
# This process uses dd and may taking 5-10 Minutes Depends on NetOpsy Image size and your USB speed.
nethydra@nethydra:~# dd if=netopsy-dfir-2026.1.img of=/dev/sda bs=4M status=progress
```
