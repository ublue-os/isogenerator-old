FROM fedora:38

COPY ./deps.txt /tmp/deps.txt
RUN dnf install \
        --disablerepo='*' \
        --enablerepo='fedora,updates' \
        --setopt install_weak_deps=0 \
        --assumeyes \
        $(cat /tmp/deps.txt)
