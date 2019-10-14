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
#   This image uses a default base of r.j2o.it/cron, which is built for amd64
#   arm64, and arm/v7 processors.
#
# Dependencies:
#   (1) To build: there must be an image of r.j2o.it/cron containing a
#       manifest for your chosen processor architecture.
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
#   r.j2o.it/rapimid, and jump to step (3) below. The following processor
#   architectures are supported amd64, arm64, arm/v7.
#
#   If you prefer to build your own, for example to set the CRON_SPEC
#   differently, the steps are as follows. Using the experimental buildx
#   feature in Docker will allow you to build a multiarch image:
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
#                      --net host --pid host \
#                      --rm --name rapimid <your-tag>/rapimid
#
# Maintainer:
#   James Osborne, dr.j.osborne@gmail.com
#
# License:
#   MIT, see LICENSE file in repoistory root.
#
ARG CRON_SPEC="* * * * *"
ARG REG=r.j2o.it
ARG TAG=latest
FROM $REG/cron:$TAG

LABEL maintainer "dr.j.osborne@gmail.com"
LABEL version "0.3"
LABEL status "development"

# Install the tools we need from the standard repos
RUN apk --no-cache add curl \
                       iptables \
                       jq \
                       ntpsec

# ntpsec is in Edge. Usual --repository flag was causing issues, so this:
#RUN sed -i -e 's/v[[:digit:]]\.[[:digit:]]/edge/g' /etc/apk/repositories

# ntpsec is only available in testing:
RUN apk --no-cache add ntpsec

# task script is copied by parent image ONBUILD

# NB: ENTRYPOINT/CMD inherited through ONBUILD from parent image
