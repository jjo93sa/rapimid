#
# Title:  rapmid/Dockerfile
#
# Description:
#   A Raspberry Pi monitoring tool to send operational data to an InfluxDB
#   complementing the output of Glances. Runs regulary using cron.
#
#   We use an environment file to define the parameters needed for the
#   services. See rapimid.env in the repository, and complete with your
#   settings. Intended that this container use the same settings, hence
#   environment file, as r.j2o.it/glances & variants.
#
#   The base image, r.j2o.it/cron, is a "template" image that uses a lot of
#   ONBUILD instructions. This means we must define some parameters for the
#   build to complete successfully. Key is that we define a CRON_SPEC either
#   before the _FIRST_ FROM or as an argument in the build command, thus:
#
#        --build-arg CRON_SPEC="* * * * *"
#
#   For ease of automated building, we define CRON_SPEC in this file. If
#   building from the Dockerfile, you may still over-ride this setting during
#   build by specifying the --build-arg as above.
#
#   This image uses a default base of r.j2o.it/cron, which is built for X86-64
#   processors. The default architecture can be changed at build-time with the
#   following --build-arg, e.g. for Raspberry Pi images:
#
#        --build-arg ARCH="r.j2o.it/arm32v6/cron"
#
# Dependencies:
#   (1) There must be an image of r.j2o.it/cron (or r.j2o.it/arm32v6/cron)
#       available for the build to complete.
#   (2) The running container needs read access to /var/run/docker.sock
#   (3) The running container needs access to the host network and PID space
#   (4) The running container requires cap NET_ADMIN for iptables monitoring
#   (5) And of course you need an InfluxDB running as well...
#
# Credits:
#   None
#
# Usage:
#   Usage of this file is very simple, just download the image from
#   r.j2o.it/rapimid, or other cpu architecture variant, and jump to step (3)
#   below.
#
#   If you prefer to build your own, for example to set the CRON_SPEC
#   differently, the steps are:
#
#   (1) Create an image of cron/Dockerfile from repository
#       https://github.com/jjo93sa/dockerfiles.git, or download the pre-built
#       image for your architecture from: r.j2o.it
#   (2) Build this file, specifying the correct ARCH and CRON_SPEC:
#
#           docker build --build-arg CRON_SPEC="<insert>" \
#                        --build-arg ARCH="<insert>" \
#                        -t <your-tag>/rapimid .
#
#       (which requires a previously built cron/Dockerfile image)
#
#   (3) Edit rapimid.env with your token information
#   (4) Run a container from the rapimid image:
#
#           docker run -d --env-file rapimid.env \
#                      --cap-add NET_ADMIN \
#                      -v /var/run/docker.sock:/var/run/docker.sock:ro \
#					   --net host --pid host \
#                      --rm --name rapimid <your-tag>/rapimid
#
# Maintainer:
#   James Osborne, dr.j.osborne@gmail.com
#
# License:
#   MIT, see LICENSE file in repoistory root.
#
ARG CRON_SPEC="* * * * *"
ARG ARCH=r.j2o.it
ARG SRCT=latest
FROM $ARCH/cron:$SRCT

LABEL maintainer "dr.j.osborne@gmail.com"
LABEL version "0.2"
LABEL status "development"

# Install the tools we need from the standard repos
RUN apk --no-cache add curl \
						iptables \
						jq

# ntpsec is only available in testing:
RUN apk --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
	--no-cache add ntpsec

# task script is copied by parent image ONBUILD

# NB: ENTRYPOINT/CMD inherited through ONBUILD from parent image
