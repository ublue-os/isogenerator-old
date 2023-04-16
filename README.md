# isogenerator
An action to generate custom ISOs of OCI images. 

## Usage

To use this action, you will need to be using a Fedora based container image.  This is because the action uses `mkksiso` 
which is only available in Fedora. In order to publish ISOs as part of the release process you can add it to the end of your release-please action: 

Example:

```yaml
  release-please:
  id: release-please
  ... 
  build-iso:
    name: Generate and Release ISOs
    runs-on: ubuntu-latest
    needs: release-please
    if: needs.release-please.outputs.releases_created
    container: 
      image: fedora:38
      options: --privileged
    steps:
      - uses: actions/checkout@v3
      - name: Generate ISO  
        uses: ublue-os/isogenerator@main
        id: isogenerator
        with:
          image-name: nameoftheiso-38
          installer-repo: development
          installer-major-version: 38
      - name: install github CLI
        run: |
          sudo dnf install 'dnf-command(config-manager)' -y
          sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
          sudo dnf install gh -y
      - name: Upload ISO
        env:
          GITHUB_TOKEN: ${{ github.token }}
        run:
          gh release upload ${{ needs.release-please.outputs.tag }} ${{ steps.isogenerator.outputs.iso-path }} -R ublue-os/main --clobber
      - name: Upload SHA256SUM
        env:
          GITHUB_TOKEN: ${{ github.token }}
        run:
          gh release upload ${{ needs.release-please.outputs.tag }} ${{ steps.isogenerator.outputs.sha256sum-path }} -R ublue-os/main --clobber

```

This action expects the following inputs:
- `image-name`: The name of the ISO to generate.  This does not include the ISO extension.
- `installer-major-version`: The major version of the Fedora installer to use.  This is usually the same as the image major version.
- `installer-repo`: Either `development` to grab the latest Fedora installer, or `release` for the latest stable release
- `cpu-arch`: CPU architecture for the installer ISO. Optional, defaults to `x86_64`
- `output-filename`: Output filename for ISO. Optional, defaults to `${IMAGE_NAME}-${MAJOR_VERSION}-${ARCH}-${DATE}.iso"`
This action will generate an ISO and output the path to the file.

## Why this method?

It's basically what people do to generate kickstart ISOs, so it makes sense to reuse it. 
The Fedora installer is in the middle of being rewritten so just using anaconda with this is the easiest way to get ISOs and ship our custom images. 

The ks file is minimal, we'll only use it to point to the custom image for that repo.
This makes Anaconda ask all the questions it needs but use the custom image for final installation. 
Flatpaks aren't handled in this case which works out for us. 

## Upstream issues

- https://github.com/rhinstaller/anaconda/pull/4561
