# Changelog

## [2.0.2](https://github.com/ublue-os/isogenerator/compare/v2.0.1...v2.0.2) (2023-05-20)


### Bug Fixes

* improve stat and sha256sum file path handling ([#70](https://github.com/ublue-os/isogenerator/issues/70)) ([4b3a0a9](https://github.com/ublue-os/isogenerator/commit/4b3a0a9de439fb18c8b3b6262c18d28e6bd66f2c))
* use basename to strip file path of ISO file in sha256sum file ([#68](https://github.com/ublue-os/isogenerator/issues/68)) ([ce9ad6e](https://github.com/ublue-os/isogenerator/commit/ce9ad6ef133a78458784fdbe05308419f1392c47))

## [2.0.1](https://github.com/ublue-os/isogenerator/compare/v2.0.0...v2.0.1) (2023-05-19)


### Bug Fixes

* don't hardcode ublue-os on grub.cfg, use github repository name ([#61](https://github.com/ublue-os/isogenerator/issues/61)) ([111381f](https://github.com/ublue-os/isogenerator/commit/111381f493c913aaddbc82801ab1f0bacbc8deeb))
* use new mirror for boot.iso ([#66](https://github.com/ublue-os/isogenerator/issues/66)) ([d7b37f0](https://github.com/ublue-os/isogenerator/commit/d7b37f0201f57e28d18af91a00ec2f58583f7706))

## [2.0.0](https://github.com/ublue-os/isogenerator/compare/v1.2.0...v2.0.0) (2023-04-22)


### ⚠ BREAKING CHANGES

* allow customized boot_menu.yml from consumer ([#59](https://github.com/ublue-os/isogenerator/issues/59))

### Features

* allow customized boot_menu.yml from consumer ([#59](https://github.com/ublue-os/isogenerator/issues/59)) ([ebd119b](https://github.com/ublue-os/isogenerator/commit/ebd119bb757839e869368f92064ba29436fd0ff7))

## [1.2.0](https://github.com/ublue-os/isogenerator/compare/v1.1.0...v1.2.0) (2023-04-20)


### Features

* add DE info to image menu ([#56](https://github.com/ublue-os/isogenerator/issues/56)) ([51b09d7](https://github.com/ublue-os/isogenerator/commit/51b09d7e6a0d6373261c4b16fc8a43f6db886e5f))


### Bug Fixes

* correct EFI mode check and ensure mokutil does not cause the installer to fail ([#58](https://github.com/ublue-os/isogenerator/issues/58)) ([4f8f574](https://github.com/ublue-os/isogenerator/commit/4f8f574de0573788756211c897c96d72166a6f6b))

## [1.1.0](https://github.com/ublue-os/isogenerator/compare/v1.0.4...v1.1.0) (2023-04-18)


### Features

* promote ISO to F38 GA ([#54](https://github.com/ublue-os/isogenerator/issues/54)) ([75eafd2](https://github.com/ublue-os/isogenerator/commit/75eafd26e6ed13fe18f1547e00df34277b88007e))


### Bug Fixes

* move output to GITHUB_WORKSPACE so consumer action can access it ([#53](https://github.com/ublue-os/isogenerator/issues/53)) ([c4987d0](https://github.com/ublue-os/isogenerator/commit/c4987d0629f5ea9daa5d0e88adf2965383a745a9))

## [1.0.4](https://github.com/ublue-os/isogenerator/compare/v1.0.3...v1.0.4) (2023-04-17)


### Bug Fixes

* use $PWD because github.action_path points to the wrong place ([#51](https://github.com/ublue-os/isogenerator/issues/51)) ([52dd6e0](https://github.com/ublue-os/isogenerator/commit/52dd6e0ec62b90db887472f24a1e66d25ded1441))

## [1.0.3](https://github.com/ublue-os/isogenerator/compare/v1.0.2...v1.0.3) (2023-04-17)


### Bug Fixes

* don't ignore CHANGELOG.md ([#49](https://github.com/ublue-os/isogenerator/issues/49)) ([17107b8](https://github.com/ublue-os/isogenerator/commit/17107b852859cb0d04e9a178c54584e28fd7f24e))

## [1.0.2](https://github.com/ublue-os/isogenerator/compare/v1.0.1...v1.0.2) (2023-04-16)


### Bug Fixes

* add tag push trigger so we can get the correct github.ref ([#47](https://github.com/ublue-os/isogenerator/issues/47)) ([ccc6ba5](https://github.com/ublue-os/isogenerator/commit/ccc6ba5255590feadd3db6031189f2817017f12d))

## [1.0.1](https://github.com/ublue-os/isogenerator/compare/v1.0.0...v1.0.1) (2023-04-16)


### Bug Fixes

* fromJSON takes a string, missed quoting in example ([#45](https://github.com/ublue-os/isogenerator/issues/45)) ([318aea6](https://github.com/ublue-os/isogenerator/commit/318aea6148f26bf5ce1c95de153d860b0edb8796))
* split assignments to avoid shellcheck warnings ([#44](https://github.com/ublue-os/isogenerator/issues/44)) ([80f4939](https://github.com/ublue-os/isogenerator/commit/80f493994cdb313b9d6f3e877f4435beff599f6a))

## 1.0.0 (2023-04-16)


### Features

* add bluefin menu entry ([#35](https://github.com/ublue-os/isogenerator/issues/35)) ([bc396a5](https://github.com/ublue-os/isogenerator/commit/bc396a530cc1f67559859052fb8319baceb218e1))
* add new script using manual xorriso calls ([#19](https://github.com/ublue-os/isogenerator/issues/19)) ([f5fa728](https://github.com/ublue-os/isogenerator/commit/f5fa72837cf9e63a2d08ff6335cadb7e91705ab2))
* Add sha256 signing ([#8](https://github.com/ublue-os/isogenerator/issues/8)) ([a31547b](https://github.com/ublue-os/isogenerator/commit/a31547b828bd94741f7f0ae089ed6bb10178edce))
* add shellcheck and fix warnings ([#26](https://github.com/ublue-os/isogenerator/issues/26)) ([1d59e49](https://github.com/ublue-os/isogenerator/commit/1d59e494a082bc7b5871a0c4b66026d05ccd9cc7))
* Create reusable GitHub Action to generate the ISOs ([#1](https://github.com/ublue-os/isogenerator/issues/1)) ([8ddbda8](https://github.com/ublue-os/isogenerator/commit/8ddbda823a84ff20dcc1958fb06a623715d0cec4))
* enable secure boot key enrollment for Nvidia ([#31](https://github.com/ublue-os/isogenerator/issues/31)) ([d38990d](https://github.com/ublue-os/isogenerator/commit/d38990d9ce00185a038c5f5bcf9a95afaa6aca31))
* have action accept more inputs and extrapolate output filename ([#37](https://github.com/ublue-os/isogenerator/issues/37)) ([e63e0ec](https://github.com/ublue-os/isogenerator/commit/e63e0ec72ae41cb0c7cc25321abbb777d86b9bd6))
* Update ublue.ks ([#3](https://github.com/ublue-os/isogenerator/issues/3)) ([3ddacc9](https://github.com/ublue-os/isogenerator/commit/3ddacc9a9658ace083f7fe1bde0802f26aa066ca))


### Bug Fixes

* add `tree` as dependency, fix bug in privileged container ([#22](https://github.com/ublue-os/isogenerator/issues/22)) ([5b0e519](https://github.com/ublue-os/isogenerator/commit/5b0e519d8fb73cc8d2ec4ef3dde806633c2882fd))
* add final no verification flag ([#6](https://github.com/ublue-os/isogenerator/issues/6)) ([c99024b](https://github.com/ublue-os/isogenerator/commit/c99024be4bf3423f9f310de13dbf0c8a7aaa10c7))
* add magic xorriso args to make hybryd iso ([#18](https://github.com/ublue-os/isogenerator/issues/18)) ([0e29a3f](https://github.com/ublue-os/isogenerator/commit/0e29a3f0d43134b495e779166277c9f9a593390e))
* add parted as dependency ([#21](https://github.com/ublue-os/isogenerator/issues/21)) ([f5544eb](https://github.com/ublue-os/isogenerator/commit/f5544eb778f05255d6391c6f0433396af10fb5e6))
* add plan and scope ([4b15d5b](https://github.com/ublue-os/isogenerator/commit/4b15d5b75cf04ab279f54997fb99151f1a4ed845))
* Allow installer ISO to be fetched from different repos ([#5](https://github.com/ublue-os/isogenerator/issues/5)) ([bcff8b7](https://github.com/ublue-os/isogenerator/commit/bcff8b7a5764568240d794f7d5b75cdac7f751f2))
* clean up grub menu template ([#36](https://github.com/ublue-os/isogenerator/issues/36)) ([f08309f](https://github.com/ublue-os/isogenerator/commit/f08309f446fa66f9be25b03617982650244ff1d5))
* correct line in README ([#39](https://github.com/ublue-os/isogenerator/issues/39)) ([e0bcd79](https://github.com/ublue-os/isogenerator/commit/e0bcd7939546a22a9b26de49f30624ba90c74072))
* correct ublue-os-nvidia.ks name ([#23](https://github.com/ublue-os/isogenerator/issues/23)) ([e623822](https://github.com/ublue-os/isogenerator/commit/e623822645debd126d2f32a616cf50635425a4c6))
* don't use colors to avoid ncurses dependency ([#20](https://github.com/ublue-os/isogenerator/issues/20)) ([b68ed66](https://github.com/ublue-os/isogenerator/commit/b68ed6604174f1be62dcaeb3f2e54d42a1f55366))
* fixed missing dependencies and working directory ([#15](https://github.com/ublue-os/isogenerator/issues/15)) ([1e7c5c3](https://github.com/ublue-os/isogenerator/commit/1e7c5c3f30e11af366de38dfcb99101d04eaa6fd))
* have xorriso look for right file ([#16](https://github.com/ublue-os/isogenerator/issues/16)) ([55e6bae](https://github.com/ublue-os/isogenerator/commit/55e6baef1f5d656631d6ea459bbd1651ca4237cc))
* nvidia, bring back old release drivers, get the correct images ([#24](https://github.com/ublue-os/isogenerator/issues/24)) ([2bf0f30](https://github.com/ublue-os/isogenerator/commit/2bf0f303dae349b4d7a8453abb51021625ab99d3))
* realign yaml ([#11](https://github.com/ublue-os/isogenerator/issues/11)) ([0fe334d](https://github.com/ublue-os/isogenerator/commit/0fe334d013b06686678bcd18c87d7d12ab2f64ae))
* remove extra directory created during ISO generation ([#30](https://github.com/ublue-os/isogenerator/issues/30)) ([6b5e9f5](https://github.com/ublue-os/isogenerator/commit/6b5e9f501fa1f48c175cee534e88b509f8f7f699))
* stick to one fast mirror instead of rotating ([#10](https://github.com/ublue-os/isogenerator/issues/10)) ([4300542](https://github.com/ublue-os/isogenerator/commit/43005421dbbff53a287b9f925d1d8c40c8bff234))
* try to have files explicitly updated during ISO creation ([#17](https://github.com/ublue-os/isogenerator/issues/17)) ([55ed06f](https://github.com/ublue-os/isogenerator/commit/55ed06fcfad9fb61528e7c48f94a0eec8df6436e))
* updated output variable, calculate step under run ([#12](https://github.com/ublue-os/isogenerator/issues/12)) ([2cb1a3d](https://github.com/ublue-os/isogenerator/commit/2cb1a3dab335717a7bb407e321520f53db791edd))
