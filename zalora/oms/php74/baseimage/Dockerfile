FROM phusion/baseimage:18.04-1.0.0

MAINTAINER Zydney Ambat <zydney.ambat@zalora.com>
MAINTAINER Dat Le <dat.le@zalora.com>
MAINTAINER Huan Nguyen <huan.nguyen@zalora.com>

# Initialize frontend dialog since it requires a controlling fucking tty
ENV DEBIAN_FRONTEND noninteractive

# Enable SSH
# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. the init system will auto-generate one during boot.
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# According to https://github.com/phusion/baseimage-docker
# This prevents zombie processes and also prevents file corruption when stopping services
CMD ["/sbin/my_init"]
