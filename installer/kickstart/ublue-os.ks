%pre
%ksappend /run/install/repo/kickstart/pre-install.sh
%end

%include /tmp/ks-urls.txt

bootloader --append="rd.luks.options=discard"

%post --logfile=/root/ks-post.log --erroronfail
%end
