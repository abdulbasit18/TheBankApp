# TheBankApp
## Overview
This repo is dedicated to show my approach to building iOS apps involving MVVM architecture, RxSwift framework, Coordinator pattern in order to create robust and statically typed system within the app.

All UI layout is done using SnapKit framework.

App consists of 3 screens:
* Main - Bank Lisiting
* Search - For searching banks
* validations - Validate IBAN, BIC , Postcode 

Networking is abstracted in a protocol - ```NetworkService```.
* ```BasicNetworkServiceImpl``` - regular API client.

Unit/UI Testing with coverage upto 80%
For Running tests successfully go to file ```SnapShotTestsConfiguration``` and turn on the property ```recordMode```
Run Tests it will fail and run tets again after turning off ```recordMode``` 

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

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)

