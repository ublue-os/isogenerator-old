%pre
%ksappend /run/install/repo/kickstart/pre-install.sh
%end

%include /tmp/ks-urls.txt

%post --logfile=/root/ks-post.log --erroronfail
%end
