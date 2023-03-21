ostreecontainer --url="ghcr.io/ublue-os/silverblue-main:38" 
url --url="https://download.fedoraproject.org/pub/fedora/linux/releases/38/Everything/x86_64/os/"

%post --logfile=/root/ks-post.log --erroronfail
%end
