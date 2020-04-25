# LXQT on Slackware

A collection of scripts to let you build [LXQT](https://github.com/lxqt/lxqt/) 0.15.0 on Slackware

## Getting Started

If you want to build lxqt on Slackware these scripts will help you. I tried to make every step trivial but I can't be sure these instructions will work on every system. If you want to build different versions of LXQT those script will probably not work unless you modify them.

### Prerequisites

In order to build LXQT on Slackware you'll need a few packages from [SlackBuilds.org](https://slackbuilds.org/), here's the list:

* openbox - [SBo](https://slackbuilds.org/repository/14.2/desktop/openbox/)
* imlib2 (optional for openbox) - [SBo](https://slackbuilds.org/repository/14.2/libraries/imlib2/)
* muParser - [SBo](https://slackbuilds.org/repository/14.2/libraries/muParser/)
* libstatgrab - [SBo](https://slackbuilds.org/repository/14.2/libraries/libstatgrab/)
* libconfig - [SBo](https://slackbuilds.org/repository/14.2/libraries/libconfig/)

Then I used AlienBob's ktown repository and installed his KDE5 packages, I've used the PAM enabled packages because I recently converted my slackware64-current to PAM, so if you decide to go the non-PAM way, I have no idea if you'll be able to build without the need for patches.
The latest set of packages for KDE5 from AlienBob are here --> [ktown](https://alien.slackbook.org/ktown/current/)

### Preparation

Before we get to start building we need to do a few things:

* Check prerequisite packages to ensure that we have all dependancies:
    * after running this script we'll have a log of all the installed dependancies as well as hints on where to find those packages we are missing.
    * a little notice regarding gtk+2 and gtk+3, even if those 2 packages are installed, my script doesn't see them, I think it has something to do with the way regex works and the fact that there's a + in the name, but I didn't investigate much. Bottom line, if you have them installed you're good to go!

```
sh CHECK_PREREQ.sh
```

* Download the source tree, this operation will also give us the version numbers for every package
    * this script will generate a versioning file containing all the version numbers for the packages.

```
sh DOWNLOAD.sh
```

### Building and Installing

Now we have everything we need, with a little luck we don't need to do much except:
```
sh build_all.sh
```
and after a while we should see our packages inside the packages directory.

## Tested on

I tested this bunch of scripts on a fresh install of slackware64-current updated on 24/04/2020, the system is running inside a chroot that I reinstall fresh everytime I have to build something.
If your system is not so clean YMMV as you can imagine.

## Contributing

Feel free to contribute however you feel like. 

## Authors

* **Danilo 'danix' Macrì** - *owner* - [danix.xyz](https://danix.xyz)

## License

This project is licensed under the GPLv3 - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Huge thans to [AlienBob](https://alien.slackbook.org/blog/) whose original lxqt slackbuilds I've used and modified to write this set
* Of course all the people behind [LXQT](https://github.com/lxqt/lxqt/), what they do is amazing and I can't thank them enough.
