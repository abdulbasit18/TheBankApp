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

