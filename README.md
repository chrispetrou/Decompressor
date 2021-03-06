# Decompressor [![GPLv3 license](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://github.com/chrispetrou/Decompressor/blob/master/LICENSE)

**Decompressor** is a _perl_ script and unix utility that automates the process of decompressing data by invoking the appropriate command. For the time it can automatically decompress the following archive formats:

|||||
|-|-|-|-|
| .z | .Z | .zip | .apk |
| .xz | .bz2 | .jar | .pkg |
| .gz | .tgz | .tar | .dmg |
| .7z | .lz | .rar | .war |
| .rz | .arj | .xar | .deb |

The script has been successfully tested on _**linux**_ and _**macOS**_ operating systems.

### Installation:

The best way to use this script is to create an _alias_ command. `setup.sh` script  automatically installs the perl-dependencies and creates an alias command `uc` (_or what other name you prefer_):

<img src="images/decompressor.png" width="70%">

To install the perl-requirements manually:

`cpanm --installdeps .`

`cpanm` command allows easy installation of CPAN modules and is part of the [App::cpanminus](https://metacpan.org/pod/distribution/App-cpanminus/bin/cpanm) distribution. Of course it's not the only way to install the dependencies.

### Requirements

Since the script works by invoking the appropriate, based on the filetype, commands, the following programs/utilities must be installed (_most of the them are pre-installed on linux/macOS systems_):

*   7z
*   gzip
*   dpkg
*   xar
*   tar
*   rzip
*   lzip
*   unzip
*   unrar
*   arj (_linux_) / unarj (_macOS_)

## License

This project is licensed under the GPLv3 License - see the [LICENSE](LICENSE) file for details