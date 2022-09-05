This page provides an overview about the architecture of this project and it used
design patterns and principles.

---

## Folder Structure

All the source code is located inside the `lib` folder and the corresponding unit
tests inside the `test` folder. The first level inside these folders is always a
main feature of the app like the Moodle, Flexnow or eCampus integration. Each
of these features is structured via a [layerized architecture](https://medium.com/kayvan-kaseb/the-layered-architecture-pattern-in-software-architecture-324922d381ad).

The source code inside the `lib` folder is separated in three parts `core`, `pages`
and `utils`. The `core` folder contain all features (like authentication) and basic
functionalities which are used in multiple pages. The `pages` folder contain all
independent features and inside `utils` you can find all helper functions and classes
like APIs. The `test` folder is structured the same way.  

As a tree-structure our project looks at follows:

```
├── assets
│   ├── documents
│   ├── img
│   ├── l10n
│   ├── ...
├── docs
│   ├── postman
│   ├── wiki
│   ├── ...
├── lib
│   ├── core
│   │   ├── feature-xyz
│   │   ├── themes
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
│   ├── core
│   │   ├── ...
│   ├── pages
│   │   ├──feature-xyz
│   │   ├── ...
│   ├── utils
│   │   ├── ...
|    ...
├── .gitignore
├── analysis_options.yaml
├── l10n.yaml
├── LICENSE
├── pubspec.yaml
├── README.md
```

The `assets` folder contain all static elements as images, language files or documents.
Special to mentioned is the subfolder `l10n` which contain all
[.arb-language files](https://localizely.com/flutter-arb/) to allow multi-language support.

The `docs` folder contain all documentation's files. The GitHub Wiki markdown files
are located inside the `wiki` folder and all network requests are documented in a
[Postman](https://www.postman.com/) collection located in `postman`. Postman is a
tool to document and handle API calls. The collection can easily imported and provide
a handy overview about all network request handled by our app.

The file `l10n.yaml` defines some basic configuration to provide multi-language support.
All language files are located inside the `assets/l10n` folder and use the basic
[ARB-syntax](https://localizely.com/flutter-arb/).  

---

## Layerized Architecture

For better development and testing we need a software architecture. In this project
we use the clean architecture approach. This section will give you a short summary
about this architecture. For future reading you can read the [explaination by Microsoft](https://docs.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures#clean-architecture) at their article about common web application architectures.

Let's start with a visualization of this architecture:

```mermaid
graph BT;
subgraph <h3>Infrastructure Layer
 api{API} -->|Raw Data| rds(Remote Datasource)
 db{DB} -->|Raw Data| lds(Local Datasource)
end
subgraph <h3>Domain Layer
 rds -->|Model| repo
 lds -->|Model| repo
 repo(Repository) -->|Entity| uc(Use Cases)
end
subgraph <h3>Application Layer
 uc --> appl(Presentation <br> Logic Holder)
 repo -.->|Entity| appl
end
subgraph <h3>Presentation Layer
 appl --> wid(Widgets)
end
```

As you can see the architecture is characterized in four different layers:

- Presentation: UI View
- Application: State Management / View Controller
- Domain: Business Logic
- Infrastructure: Communication with APIs and Databases

### Presentation Layer

The Presentation Layer is the end user's entry point of the whole app. It handle
all user interactions and is responsible for the UI view. Its primary concerns are routing requests to the Application Layer and present the Data requested by user
interactions.

### Application Layer

The Application Layer handles the state of our App. All user requests coming from the
UI are validated and handled at this point. So validation also into this layer. It could be argued that Validation goes into the domain, but the risk there is that errors raised may reference fields not present in the View Model which would cause confusion.

In Flutter their a Stateful-Widgets which can handle the State by them self and
global states can be handled by Change Notifiers. So their aren't different files
for the Presentation and Application Layer. [¹]

### Domain Layer

The Domain Layer is the core of our application, and responsible for our models. Models should be persistence ignorant, and encapsulate logic where possible. We want to avoid ending up with Anemic Models (i.e. models that are only collections of properties).

So the whole purpose of Models is to convert Raw Data into our Entities (Objects),
which are used to represent the data requested by the user. For example: If an user
want to check current Events then a Calendar Entity could be use to represent this data.
So an event has i.e. a date, a place and a title, which our properties of the event
entity. If we request event data from an API, i.e. we get a JSON String as Raw Data.
The event model's task should be the conversion of this JSON String into an event entity.

The Repository is responsible to collect each single Model and ensure the correctness
of the corresponding Entity. Sometimes we want to collect multiple Entities in "one
user requested data" object. I.e. there should be Posts and Events in one UI page.
Than we write a Use Case for this, which collect the different Entities from the Repository. In the case the UI just have to represent a single Entity, then the Application Layer can call the Repository directly and we do not have to write a
special usecase for that.

### Infrastructure Layer

The Infrastructure Layer handles all communication with APIs, Databases or other
third-party structures. It works hand-on-hand with the corresponding Repository to
convert the Raw Data into our defined Entities by using Models.

---

## Dependency Injection

Dependency injection is a programming technique that makes a class independent of its dependencies. It achieves that by decoupling the usage of an object from its creation.
That allows us to change the dependencies at runtime (because dependencies can be injected at runtime rather than at compile time).

If there is any change in objects, then DI looks into it and it should not concern the class using those objects. This way if the objects change in the future, then its DI’s responsibility to provide the appropriate objects to the class.

For Example: It makes a Car class independent from creating the objects of Wheels, Battery, etc.

So why we want that? In a Nutshell: It helps to keep our code organized and more testable. All classes of our App would recognized in a single Injection Container
and Units of our software can be easaly testet independenly of each other by using Mocks [²]. For further reading: [Why use dependency injection? by Chris Cooper](https://medium.com/trade-me/when-i-was-first-introduced-to-dagger-it-solved-a-lot-of-issues-that-i-had-with-android-development-748dc9f167df)

Our Injection Container is located inside the `lib/core/injection.dart`-file and
we are using the [GetIt](https://pub.dev/packages/get_it) Plugin. The Function
`init()` is called directly in our Main Function inside `main.dart`.

### Singelton

> "In software engineering, the singleton pattern is a software design pattern that restricts the instantiation of a class to one "single" instance. This is useful when exactly one object is needed to coordinate actions across the system." -
> [Wikipedia](https://en.wikipedia.org/wiki/Singleton_pattern)

In our App we will have multiple dependencies to another object, i.e. an HTTP-client
in remote datasources. The Singelton Pattern describes that instead of creating a
new instance of this object, we could reuse the already existing one. So the call
of `sl.registerLazySingleton()` in `lib/core/injection.dart` create a new instance
for all depending classes. The Term "Lazy" indicates that the object will create when
it is used the first time.

---

[¹]: In an early state of development we used the BLoC-Pattern, but we decided to
switch to Stateful-Widget because this approach is more likely to easily understand
and the BLoC-pattern was mostly a kind of 'over-engineering'.

[²]: The purpose of mocking is to isolate and focus on the code being tested and not on the behavior or state of external dependencies. In mocking, the dependencies are replaced by closely controlled replacements objects that simulate the behavior of the real ones.
