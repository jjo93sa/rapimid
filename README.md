## rapimid - RAspberry PI Monitoring In Docker

### About

Designed to work inconjunction with Glances to provide extra monitoring of Raspberry Pi boards to an InfluxDB instance. YMMV with other systems.

Provides monitoring of NTP performance, Docker container count, system temperature, and iptables chain rule count. Requires a bunch of run-time parameters, which are configured in an environment file for convenience.

### Dependencies

Various - listed in the individual Docker files, but you clearly need an InfluxDB running to make any use of this at all.

### Usage

0. Build or download the image
1. Run the container

Commands for building the image and running the container are contained in the header of the Docker file.

Pre-built images can be downloaded from my Docker registry, [r.j2o.it](https://r.j2o.it). Architectures currently supported are:

* x86-64
* arm32v6

The [list](https://r.j2o.it) is created by the awesome [reg](https://github.com/genuinetools/reg) from genuinetools.


### Support and feature requests

Ping me if you have any questions, suggestions or requests for new features.

### License

Distributed under the MIT License, see LICENSE file in the repository root for more information.
