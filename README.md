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

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)

