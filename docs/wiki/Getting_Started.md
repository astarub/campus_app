This page explains how to set up your development environment and the first steps to start contributing to our project.

---

## Install Flutter

First you need to install Flutter. The [official flutter documentation](https://docs.flutter.dev/get-started/install) provides a handy tutorial about Flutter installation.

---

## Setup an editor and emulator

To write code you need an editor or IDE. We recommend to follow the official VS Code setup from the [Flutter documentation](https://docs.flutter.dev/get-started/editor?tab=vscode).

In addition to the editor setup you need a running phone emulator. For non-macOS users, Android Studio with the Virtual Device Manager is a good choice.
The [Android developer documentation](https://developer.android.com/studio/run/managing-avds) provides a tutorial about AVD creation and management. We recommend using the newest Android API level (or at least API level 30). Google Play support is optional.

---

## Clone repository

If you work the first time with git, check out this [cheat sheet](https://training.github.com/downloads/github-git-cheat-sheet/).

You can easily clone the repository with the command `git clone https://github.com/astarub/campus_app`. Git will create a new folder for you inside your current directory.

Now you can open VS Code with `code ./campus_app` and start development.

---

## Start development

After opening VS Code, open a terminal and download dependencies with `flutter pub get`.

Meanwhile you can start your emulator with `flutter emulator --launch <emulator_name>`.

Then execute `flutter run` to start the app. After source changes you can press `r` or `R` for hot reload/restart.
Press `q` to quit.

If you work with custom backend credentials, also set up the `.env` file as described in `Environment_Variables.md`.

Happy coding. :)

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

### Start App

`flutter run`
​
### Update Dependencies

`flutter pub get` // Download dependencies <br>
`flutter pub upgrade` // Update dependencies

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
