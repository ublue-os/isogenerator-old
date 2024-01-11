%pre
%ksappend /run/install/repo/kickstart/pre-install.sh
%end

%include /tmp/ks-urls.txt

bootloader --append="rd.driver.blacklist=nouveau modprobe.blacklist=nouveau nvidia-drm.modeset=1 rd.luks.options=discard"

%post --logfile=/root/ks-post.log --erroronfail --nochroot
%ksappend /run/install/repo/kickstart/post-install.sh
%end
