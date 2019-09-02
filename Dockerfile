FROM nginx:1.17-alpine

RUN apk add -u git bash fcgiwrap spawn-fcgi wget openrc && \
    sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf &&\
    echo 'rc_provide="loopback net"' >> /etc/rc.conf &&\
    sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf &&\
    sed -i '/tty/d' /etc/inittab &&\
    sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname &&\
    sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh &&\
    sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh &&\rm -rf /var/cache/apk/* && \
    mkdir /run/openrc && \
    touch /run/openrc/softlevel && \
    rc-update add nginx && \

    adduser git -h /var/lib/git -D && \
    adduser nginx git && \

    git config --system http.receivepack true && \
    git config --system http.uploadpack true && \
    git config --system user.email "gitserver@git.com" && \
    git config --system user.name "Git Server" && \

    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

ADD ./etc /etc
ADD ./entrypoint.sh /usr/local/bin/entrypoint
