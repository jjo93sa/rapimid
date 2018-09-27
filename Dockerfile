#
# Title:  rapmid/Dockerfile
#
# Description:
#   A raspberry Pi monitoring tool to send operational data to an InfluxDB
#   complementing the output of glances. Runs regulary using cron.
#
# Dependencies:
#
# Credits:
#   None
#
# Usage:
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
LABEL version "0.1"
LABEL status "development"

RUN apk --no-cache add curl \
						iptables \
						jq 
						
RUN apk --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --no-cache add ntpsec

# task script is copied by parent image ONBUILD

# NB: ENTRYPOINT/CMD inherited through ONBUILD from parent image
