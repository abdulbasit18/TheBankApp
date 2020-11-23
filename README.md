# TheBankApp

## Prereqs

- Xcode 11.5
- iOS 13+

## Usage

- Run ```Pod Install```  to install the dependencies 

## Features

App consists of 3 screens:
* Main - Bic Lisiting
* Search - For searching Bics
* validations - Validate IBAN, BIC , Postcode 

## Flow
*  Bic Listing - When user opens an App starting screen will show bics listings and as user scrolls more list will be added automatically.
*  Bic Listing  - If a user wants to search specific Bic he can tap on filter button which will land him into search screen where he has options to search through Blz, Country Code, Bank Name and Location.
*  Validation Screen  - If user wants to validate Bic, Iban and Post Code, He can navigate to the validation screen by tapping validation button.


## Overall Architecture 

App is based on **MVVM-C** architecture and all UI is done programatically to avoid Git merge conflicts. Structure is broken down by the general purpose of contained source files. Below are the dependencies used in the project

1. **RxSwift** : Used to bind the flow between layers.
2. **IQKeyboardManagerSwift** : Used to Manage Keyboard States.
3. **NVActivityIndicatorView** : Used to show loading states.
4. **SwiftLint** : A tool to enforce Swift style and conventions, loosely based on
[GitHub's Swift Style Guide](https://github.com/github/swift-style-guide).
5. **Swinject** : Used to manage and Inject dependencies.
6. **iOSSnapshotTestCase** : Used to write snapshot tests.
7. **SnapKit** : SnapKit is a DSL to make Auto Layout easy .


Networking is abstracted in a protocol - ```NetworkService```.
* ```BasicNetworkServiceImpl``` - regular API client.

## Unit/UI Testing 

For Running tests successfully go to file ```SnapShotTestsConfiguration``` and turn on the property ```recordMode```
Run Tests ```CMD + U``` it will fail fail the tests initially. Run the tests again after turning off ```recordMode``` 

## iOSSnapshotTestCase 
A "snapshot test case" takes a configured UIView or CALayer and uses the necessary UIKit or Core Animation methods to generate an image snapshot of its contents. It compares this snapshot to a "reference image" stored in your source code repository and fails the test if the two images don't match.

## RxSwift 
RxSwift and RxCocoa are part of the suite of ReactiveX (Rx) language tools that span multiple programming languages and platforms.

While ReactiveX started as part of the .NET/C# ecosystem, it’s grown extremely popular with Rubyists, JavaScripters and, particularly, Java and Android developers.

RxSwift is a framework for interacting with the Swift programming language, while RxCocoa is a framework that makes Cocoa APIs used in iOS and OS X easier to use with reactive techniques.

ReactiveX frameworks provide a common vocabulary for tasks used repeatedly across different programming languages. This makes it easy to focus on the syntax of the language itself rather than figuring out how to map a common task to each new language.

## SnapKit 
Simple & Expressive chaining DSL allows building constraints with minimal amounts of code while ensuring they are easy to read and understand.
Type Safe by design to reduce programmer error and keep invalid constraints from being created in the first place for maximized productivity.

## Swinject
Swinject is a lightweight dependency injection framework for Swift.

Dependency injection (DI) is a software design pattern that implements Inversion of Control (IoC) for resolving dependencies. In the pattern, Swinject helps your app split into loosely-coupled components, which can be developed, tested and maintained more easily. Swinject is powered by the Swift generic type system and first class functions to define dependencies of your app simply and fluently.
