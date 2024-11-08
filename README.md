# Pre-built Raspberry Pi images to simplify using the Pi as a USB gadget.

- The IP to connect to is: 10.55.0.1

The basic Raspberry Pi OS images are a faithful reproduction of the work done by [Ben Hardill][bh],
with some additional automation wrapped around to get to a publish release on GitHub.

Other operating systems are derived from the basic template used in Raspberry Pi OS.

## Available Images

* Raspberry Pi OS Lite arm64

## Burning Your Image

with [Raspberry Pi Imager][rpimg].

## Building Images with Docker

The easiest way to build images locally is to use the pre-built `packer-builder-arm`[pba] Docker images

```
docker run --rm --privileged -v /dev:/dev -v ${PWD}:/build mkaczanowski/packer-builder-arm build <build_json_path>
```

Replace `<build_json_path>` with any of the image definition files in the root directory.

## Building Images with Packer directly

To build you need [Packer][packer] and the `packer-builder-arm` plugin.
To build `packer-build-arm` you need [Go][go].

With Packer and `packer-builder-arm` installed:

```
sudo packer build raspios-lite-usb-gadget-arm.json
```

You can substitute any other build specification in the call to `packer build`.


[packer]: https://www.packer.io/
[pba]: https://github.com/mkaczanowski/packer-builder-arm
[bh]: https://www.hardill.me.uk/wordpress/2020/02/21/building-custom-raspberry-pi-sd-card-images/
[go]: https://golang.org
[rpimg]: https://www.raspberrypi.com/software/
