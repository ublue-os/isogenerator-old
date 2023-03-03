# isogenerator
An action to generate custom ISOs of OCI images

***HELP WANTED***: Inquire within!

## Current Plan

This repo is to prototype a github action to generate an ISO for repos in this org.
We don't want one repo generating a bunch of ISOs, instead what we want is is an action that can be placed in any custom repo that will generate each ISO for that individual repo:

The action needs to:

- Determine when the release-please action is fired off and has completed successfully
- Grab the [Fedora Everything installer](https://download.fedoraproject.org/pub/fedora/linux/releases/37/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-37-1.7.iso) or the Fedora IoT installer (tbd)
- Use the example `ublue.ks` in this repo
- Execute the following command:
    - `mkksiso ublue.ks Fedora-Everything-netinst-x86_64-37-1.7.iso ublue.iso`
    - The ISO's name should be generated so that it matches the image name and our naming convention
- Sign the iso and generate verification signatures
- Take the resulting ISO image and signatures and attach it to the release the release-please action just generated. 

Note: the `ublue.ks` in this repo is using the current ostree method of kickstarting, but we can do all of this until the feature lands, then we just update the kickstart file, verify it works, then use it in other repos. 

## Why this method?

It's basically what people do to generate kickstart ISOs, so it makes sense to reuse it. 
The Fedora installer is in the middle of being rewritten so just using anaconda with this is the easiest way to get ISOs and ship our custom images. 

The ks file is minimal, we'll only use it to point to the custom image for that repo.
This makes Anaconda ask all the questions it needs but use the custom image for final installation. 
Flatpaks aren't handled in this case which works out for us. 

## Upstream issues

- https://github.com/rhinstaller/anaconda/pull/4561
