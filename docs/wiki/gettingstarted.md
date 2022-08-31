# Getting Started

This pages will explain how to setup your development environment and first steps to start contributing to our project.

---

## Install Flutter

First you need to install Flutter. The [official flutter documentation](https://docs.flutter.dev/get-started/install) provides a handy tutorial about Flutter installation.

---

## Setup an editor and emulator

To write code you need an editor or IDE (obvously :D ). Wer would recommend to follow
the official steps for VS Code by the [official flutter documentation](https://docs.flutter.dev/get-started/editor?tab=vscode).

In addition of the VS Code setup you need a running phone emulator. The best case, for non-MAC-users, is to install Android Studio Code and the included Virtual Device Manager.
The [android developer documentation](https://developer.android.com/studio/run/managing-avds) provide a useful tutorial about AVD creation and management. We would recommend to create a phone with the newest Android API Level or at least API level 30 (Android 11.0). Google Play support is optional.  

---

## Clone repository

If you work the first time with git, check out this [cheat sheet](https://training.github.com/downloads/github-git-cheat-sheet/).

You can easily clone the repository with the command `git clone https://github.com/astarub/campus_app`. Git will create a new folder for you inside your current directory.

Now you can open VS Code with the command `code ./campus_app` and start development.

---

## Flutter Cheat Sheet

Last but not least we will provide a small cheat sheet about all Flutter commands you will need to develop.

### Flutter help

`flutter -h`

### Flutter Version

`flutter --version`

### Check out Flutter channel / branch:​

`flutter channel`

### Check your Development Environment

`flutter doctor`
​

### Upgrade Flutter Version

`flutter upgrade`

### Downgrade Flutter Version

`flutter downgrade <version>`

### Create a new Flutter app

`flutter create <app name>`
​

### List virtual devices

`flutter emulator`
​

### Start an Emulator

`flutter emulator --launch <emulator_name>`

### Create Mocks

`flutter packages run build_runner build --delete-conflicting-outputs`

### Generate language files

`flutter gen-l10n`
