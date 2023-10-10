FROM fedora:38 as offline_builder


COPY ./deps.txt /tmp/deps.txt
RUN dnf install \
        --disablerepo='*' \
        --enablerepo='fedora,updates' \
        --setopt install_weak_deps=0 \
        --assumeyes \
        $(cat /tmp/deps.txt)

FROM offline_builder as netinstall_builder 

# We need to hijack the build process to inject our custom configuration
COPY lorax-templates/efi.tmpl /usr/share/lorax/templates.d/99-generic/efi.tmpl
COPY lorax-templates/x86.tmpl /usr/share/lorax/templates.d/99-generic/x86.tmpl
