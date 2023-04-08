FROM fedora:38

RUN dnf install \
        --disablerepo='*' \
        --enablerepo='fedora,updates' \
        --setopt install_weak_deps=0 \
        --assumeyes \
        ansible \
        curl \
        isomd5sum \
        jq \
        parted \
        ShellCheck \
        tree \
        xorriso
