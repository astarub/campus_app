# Student App of the General Student Committee of the Ruhr University Bochum

The purpose of this app is to provide the students of the Ruhr-Universität Bochum
a tool that simplifies, improves and facilitates everyday students life.


## Folder structure

All the source code is located inside the `lib` folder and the corresponding unit
tests inside the `test` folder. The first level inside these folders is allways a
main feature of the app like the moodle, flexnow or ecampus integration. Each
of these features is struturized via the four layer modle. So the `application` layer
holds state management and act as a view controller, the `domain` layer handles
business logic and data entities, the `infrastructure` layer handles the communication
with local or remote data sources and holds corresponding data models and last but
not least the `presentation` layer holds the UI view.

```
├── assets
│   ├── documents
│   ├── img
│   ├── l10n
│   ├── ...
├── docs
│   ├── postman
│   ├── ...
├── lib
│   ├── core
│   │   ├── routes
│   │   ├── theme
│   │   ├── failures
│   │   ├── ...
│   ├── pages
│   │   ├── feature-xyz
│   │   ├── ...
│   ├── utils
│   │   ├── apis
│   │   ├── pages
│   │   ├── ...
|    ...
├── test
│   ├── feature-xyz
|    ...
├── .gitignore
├── analysis_options.yaml
├── l10n.yaml
├── LICENSE
├── pubspec.yaml
├── README.md
```

Other files of interests are the `pubspec.yaml` which defines the flutter / dart
packages and some metadata and `analysis_options.yaml` which defines linting rules.

This project is devoloped under GNU AFFERO GENERAL PUBLIC LICENSE Version 3.

## Contribution

Feel free to report any issues and participate in discussions.
Please keep in mind the following rules when it comes to contribution:

### No direct commits to the main/master branch
We work with feature branches, which means whenever you work on an feature you do that on the explicit branch. If the feature is ready, we **merge it with a pull-request** into the main/master branch.

### No merge without a pull-request
In order to keep things secure, every publish-ready feature or change has to be merged with a pull-request in order to discuss these changes and make corrections.

### No pull-request merge without another persons approval
Always request a review of at least one person before merging the feature.

---

## Flutter Cheat Sheet

Flutter help:
`flutter -h`

Flutter Version:
`flutter --version`

​Check out flutter channel / branch:
`flutter channel`

Check DevEnv:
`flutter doctor`
​
Upgrade Flutter:
`flutter upgrade`

Downgrade flutter:
`flutter downgrade <version>`

Create a new app:
`flutter create <app name>`
​

List devices:
`flutter emulator`
​

Start Emulator:
`flutter emulator --launch <emulator_name>`

Create Mocks: 
`flutter packages run build_runner build --delete-conflicting-outputs`

Generate language files: 
`flutter gen-l10n`

Generate Routes: 
`flutter packages pub run build_runner build`
