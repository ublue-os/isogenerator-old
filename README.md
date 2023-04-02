# isogenerator
An action to generate custom ISOs of OCI images. 

## Usage

To use this action, you will need to be using a Fedora based container image.  This is because the action uses `mkksiso` 
which is only available in Fedora.

Example:

```yaml
name: Generate ISO

on:
  release:
    types: [published]

jobs:
  build-iso:
    runs-on: ubuntu-latest
    container: fedora:latest
    strategy:
      matrix:
        fedora-version: [ 37 ]
    steps:
      - uses: actions/checkout@v3
        
      - uses: ublue-os/isogenerator@main
        id: isogenerator
        with:
          image-name: example-${{ matrix.fedora-version }}
          installer-major-version: ${{ matrix.fedora-version }}
          kickstart-file-path: ublue.ks
          
      - uses: actions/upload-artifact@v3
        with:
          name: example-${{ matrix.fedora-version }}
          path: ${{ steps.isogenerator.outputs.iso-path }}
```

This action expects the following inputs:
- `image-name`: The name of the ISO to generate.  This does not include the ISO extension.
- `installer-major-version`: The major version of the Fedora installer to use.  This is usually the same as the image major version.
- `kickstart-file-path`: The path to the kickstart file to use.

This action will generate an ISO and output the path to the file.

## Why this method?

It's basically what people do to generate kickstart ISOs, so it makes sense to reuse it. 
The Fedora installer is in the middle of being rewritten so just using anaconda with this is the easiest way to get ISOs and ship our custom images. 

The ks file is minimal, we'll only use it to point to the custom image for that repo.
This makes Anaconda ask all the questions it needs but use the custom image for final installation. 
Flatpaks aren't handled in this case which works out for us. 

## Upstream issues

- https://github.com/rhinstaller/anaconda/pull/4561
