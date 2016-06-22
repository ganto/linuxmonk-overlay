# Linuxmonk Overlay

[![Build Status](https://travis-ci.org/ganto/linuxmonk-overlay.png)](https://travis-ci.org/ganto/linuxmonk-overlay)

This is a personal [Gentoo Portage Overlay](https://wiki.gentoo.org/wiki/Overlay). It mostly contains ebuilds of applications and libraries that I am/was interested to try on one of my Gentoo boxes or that solve a particular issue with an upstream ebuild.

Feel free to use any ebuild for your own purpose, however I might not be able to help you with any problems, as I'm not regularly using most of the packaged applications. Still every ebuild published here is in a fully functional condition at the time of upload.


### Installing the overlay

In order to manage the overlay, the package **app-portage/layman** must be installed into your environment:

```
emerge -av app-portage/layman
```

If the installation of _layman_ was successfully completed, then you are ready to add this overlay by fetching its remote list as showed below:

```
wget -O /etc/layman/overlays/linuxmonk-overlay.xml https://raw.github.com/ganto/linuxmonk-overlay/master/overlay.xml
```

At this point you can execute:

```
layman -a linuxmonk-overlay
```


### Updating the overlay

Keep the overlay up to date with:

```
layman -s linuxmonk-overlay
```


### Removing the overlay

The process of removing this overlay from your Gentoo environment is quite straightforward:

```
layman -d linuxmonk-overlay
rm -r /etc/layman/overlays/linuxmonk-overlay.xml
```
