%pre
%ksappend /run/install/repo/kickstart/pre-install.sh
%end

%include /tmp/ks-urls.txt

bootloader --append="amd_pstate=active amd_iommu=off amdgpu.gttsize=8128 spi_amd.speed_dev=1 audit=0 initcall_blacklist=simpledrm_platform_driver_init rd.luks.options=discard"

%post --logfile=/root/ks-post.log --erroronfail --nochroot
%end
