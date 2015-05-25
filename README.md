<h3 align="center">
  <a href="https://github.com/KrauseFx/fastlane">
    <img src="assets/fastlane.png" width="150" />
    <br />
    fastlane
  </a>
</h3>
<p align="center">
  <a href="https://github.com/KrauseFx/deliver">deliver</a> &bull;
  <a href="https://github.com/KrauseFx/snapshot">snapshot</a> &bull;
  <a href="https://github.com/KrauseFx/frameit">frameit</a> &bull;
  <a href="https://github.com/KrauseFx/PEM">PEM</a> &bull;
  <b>sigh</b> &bull;
  <a href="https://github.com/KrauseFx/produce">produce</a> &bull;
  <a href="https://github.com/KrauseFx/cert">cert</a> &bull;
  <a href="https://github.com/KrauseFx/codes">codes</a>
</p>
-------

<p align="center">
    <img src="assets/sigh.png">
</p>

sigh
============

[![Twitter: @KauseFx](https://img.shields.io/badge/contact-@KrauseFx-blue.svg?style=flat)](https://twitter.com/KrauseFx)
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/KrauseFx/sigh/blob/master/LICENSE)
[![Gem](https://img.shields.io/gem/v/sigh.svg?style=flat)](http://rubygems.org/gems/sigh)

###### Because you would rather spend your time building stuff than fighting provisioning

`sigh` can create, renew, download and repair provisioning profiles (with one command). It supports App Store, Ad Hoc, Development and Enterprise profiles and supports nice features, like auto-adding all test devices.

Get in contact with the developer on Twitter: [@KrauseFx](https://twitter.com/KrauseFx)

Special thanks to [Matthias Tretter](https://twitter.com/myell0w) for coming up with the name.

-------
<p align="center">
    <a href="#features">Features</a> &bull;
    <a href="#installation">Installation</a> &bull;
    <a href="#usage">Usage</a> &bull;
    <a href="#resign">Resign</a> &bull;
    <a href="#how-does-it-work">How does it work?</a> &bull;
    <a href="#tips">Tips</a> &bull;
    <a href="#need-help">Need help?</a>
</p>

-------

<h5 align="center"><code>sigh</code> is part of <a href="https://fastlane.tools">fastlane</a>: connect all deployment tools into one streamlined workflow.</h5>


# Features

- **Download** the latest provisioning profile for your app
- **Renew** a provisioning profile, when it has expired
- **Repair** a provisioning profile, when it is broken
- **Create** a new provisioning profile, if it doesn't exist already
- Supports **App Store**, **Ad Hoc** and **Development** profiles
- Support for **multiple Apple accounts**, storing your credentials securely in the Keychain
- Support for **multiple Teams**
- Support for **Enterprise Profiles**

To automate iOS Push profiles you can use [PEM](https://github.com/KrauseFx/PEM).

##### [Like this tool? Be the first to know about updates and new fastlane tools](https://tinyletter.com/krausefx)

### Why not let Xcode do the work?

- ```sigh``` can easily be integrated into your CI-server (e.g. Jenkins)
- Xcode sometimes invalidates all existing profiles ([Screenshot](assets/SignErrors.png))
- You have control over what happens
- You still get to have the signing files, which you can then use for your build scripts or store in git

See ```sigh``` in action:

![assets/sighRecording.gif](assets/sighRecording.gif)

# Installation
    sudo gem install sigh

Make sure, you have the latest version of the Xcode command line tools installed:

    xcode-select --install

# Usage

    sigh
Yes, that's the whole command!

```sigh``` will create, repair and download profiles for the App Store by default.

You can pass your bundle identifier and username like this:

    sigh -a com.krausefx.app -u username

If you want to generate an **Ad Hoc** profile instead of an App Store profile:

    sigh --adhoc

If you want to generate a **Development** profile:

    sigh --development

To generate the profile in a specific directory:

    sigh -o "~/Certificates/"

For a list of available commands run

    sigh --help

### Advanced

By default, ```sigh``` will install the downloaded profile on your machine. If you just want to generate the profile and skip the installation, use the following flag:

    sigh --skip_install

To save the provisioning profile under a specific name, use the -f option:

    sigh -a com.krausefx.app -u username -f "myProfile.mobileprovision"

If you need the provisioning profile to be renewed regardless of its state use the `--force` option. This gives you a profile with the maximum lifetime. `--force` will also add all available devices to this profile.

    sigh --force

By default, ```sigh``` will include all certificates on development profiles, and first certificate on other types. If you need to specify which certificate to use you can either use the environment variable `SIGH_CERTIFICATE`, or pass the name or expiry date of the certificate as argument:

    sigh -c "SunApps GmbH"

Or identify be expire date if you're using the same names for multiple certificates

    sigh -d "Nov 11, 2017"

### Renewing all expired certificates

Sigh can list out all expired profiles at the command line and even optionally renew all of the expired profiles in one command.

    sigh expired

By default `sigh` will only list the expired certificates.  If you want to renew each certificate, pass the `--renew` option.

    sigh expired --renew

# Resign

If you generated your `ipa` file but want to apply a different code signing onto the ipa file, you can use `sigh resign`:


    sigh resign

`sigh` will find the ipa file and the provisioning profile for you if they are located in the current folder.

You can pass more information using the command line:

    sigh resign ./path/app.ipa -i "iPhone Distribution: Felix Krause" -p "my.mobileprovision"

# Manage

With `sigh manage` you can list all provisioning profiles installed locally.

    sigh manage

Delete all expired provisioning profiles

    sigh manage -e

Or delete all `iOS Team Provisioning Profile` by using a regular expression

    sigh manage -p "iOS\ ?Team Provisioning Profile:"

## Environment Variables
In case you prefer environment variables:

- `SIGH_USERNAME`
- `SIGH_APP_IDENTIFIER` (The App's Bundle ID , e.g. `com.yourteam.awesomeapp`)
- `SIGH_TEAM_ID` (The Team ID, e.g. `Q2CBPK58CA`)
- `SIGH_PROVISIONING_PROFILE_NAME` (set a custom name for the name of the generated file)

Choose signing certificate to use:

- `SIGH_CERTIFICATE` (The name of the certificate to use)
- `SIGH_CERTIFICATE_ID` (The ID of the certificate)
- `SIGH_CERTIFICATE_EXPIRE_DATE` (The expire date of the certificate)

If you're using [cert](https://github.com/KrauseFx/cert) in combination with [fastlane](https://github.com/KrauseFx/fastlane) the signing certificate will automatically be selected for you. (make sure to run `cert` before `sigh`)

`sigh` will store the `UDID` of the generated provisioning profile in the environment: `SIGH_UDID`.

# How does it work?

```sigh``` will access the ```iOS Dev Center``` to download, renew or generate the ```.mobileprovision``` file. Check out the full source code: [developer_center.rb](https://github.com/KrauseFx/sigh/blob/master/lib/sigh/developer_center.rb).


## How is my password stored?
```sigh``` uses the [password manager](https://github.com/KrauseFx/CredentialsManager) from `fastlane`. Take a look the [CredentialsManager README](https://github.com/KrauseFx/CredentialsManager) for more information.

# Tips
## [`fastlane`](https://fastlane.tools) Toolchain

- [`fastlane`](https://fastlane.tools): Connect all deployment tools into one streamlined workflow
- [`deliver`](https://github.com/KrauseFx/deliver): Upload screenshots, metadata and your app to the App Store using a single command
- [`snapshot`](https://github.com/KrauseFx/snapshot): Automate taking localized screenshots of your iOS app on every device
- [`frameit`](https://github.com/KrauseFx/frameit): Quickly put your screenshots into the right device frames
- [`PEM`](https://github.com/KrauseFx/pem): Automatically generate and renew your push notification profiles
- [`produce`](https://github.com/KrauseFx/produce): Create new iOS apps on iTunes Connect and Dev Portal using the command line
- [`cert`](https://github.com/KrauseFx/cert): Automatically create and maintain iOS code signing certificates
- [`codes`](https://github.com/KrauseFx/codes): Create promo codes for iOS Apps using the command line

##### [Like this tool? Be the first to know about updates and new fastlane tools](https://tinyletter.com/krausefx)

## Use the 'Provisioning Quicklook plugin'
Download and install the [Provisioning Plugin](https://github.com/chockenberry/Provisioning).

It will show you the ```mobileprovision``` files like this:
![assets/QuickLookScreenshot.png](assets/QuickLookScreenshot.png)


# Need help?
- If there is a technical problem with ```sigh```, submit an issue.
- I'm available for contract work - drop me an email: sigh@krausefx.com

# License
This project is licensed under the terms of the MIT license. See the LICENSE file.

# Contributing

1. Create an issue to start a discussion about your idea
2. Fork it (https://github.com/KrauseFx/sigh/fork)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request
