%pre
%ksappend /run/install/repo/kickstart/pre-install.sh
%end

%include /tmp/ks-urls.txt

bootloader --append="amd_iommu=off amdgpu.gttsize=8128 spi_amd.speed_dev=1 rd.luks.options=discard"

%post --logfile=/root/ks-post.log --erroronfail --nochroot
%ksappend /run/install/repo/kickstart/post-install.sh
%end
