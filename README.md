# evrythng-scan-sdk-ios

> **Beta**:
> This is the initial stable beta release of this SDK for developers to use, and may be subject to change and improvement in the future until this beta label is removed. If you encounter any problems using it, please [get in touch](https://developers.evrythng.com/docs/support) let us know.

This project contains an iOS native SDK for embedding a barcode scanning experience inside a native iOS application. It also includes functionality for authenticating as an EVRYTHNG application and creating/logging in and out of Application Users. 

Visit the [EVRYTHNG Developer Hub](https://developers.evrythng.com) for more information on the EVRYTHNG Platform.

## Minimum Requirements: 

* Xcode 8.3+ / Swift 3
* Actual device running iOS 10.0+
* [EVRYTHNG developer account](https://developers.evrythng.com/docs/using-the-dashboard-overview#section-getting-started)

## Project Setup
1. Download the [respository](https://github.com/evrythng/evrythng-ios-sdk)
2. After downloading, take note of the following frameworks in the topmost folder:
    1. _Alamofire.framework_
    2. _AlamofireObjectMapper.framework_
    3. _KRActivityIndicatorView.framework_
    4. _KRProgressHUD.framework_
    5. _Moya.framework_
    6. _MoyaSugar.framework_
    7. _Moya_ObjectMapper.framework_
    8. _Moya_SwiftyJSONMapper.framework_
    9. _ObjectMapper.framework_
    10. _Result.framework_
    11. _SwiftyJSON.framework_
    12. _EvrythngiOS.framework_
    13. _GoogleInterchangeUtilities.framework_
    14. _GoogleMobileVision.framework_
    15. _GoogleNetworkingUtilities.framework_
    16. _GoogleSymbolUtilities.framework_
    17. _GoogleUtilities.framework_
    18. _BarcodeDetector.framework_
    
3. If you’ve already created your own Xcode Project, you may skip and proceed to **Step #7** instead. Otherwise, continue to the next step.
4. Create a new project and choose `Single View Application`. Click `Next`.
5. Fill in the required fields and click `Next`.
6. Select the folder where you want to save your project. Click `Save`.
7. Navigate to `Project Navigator` and create a new Group from your root app directory and name it `Frameworks`(if not yet existing) and drag the 18 frameworks stated in **Step #2** inside this folder and ensure that **Copy Files if Needed** is checked.
8. Navigate to your _**Project’s**_ `Targets` -> `Build Phases` -> `Link Binary With Libraries` and ensure that all 18 frameworks are included in the list.
![Link Binary with Libraries](https://preview.ibb.co/heARPa/Screen_Shot_2017_07_11_at_11_32_01_AM.png)

9. Still in your _**Project’s Targets**_ -> `Build Phases` tab add a **New Copy Files Phase** by clicking the `+` button on the upper left portion of the window below the `General` tab
10. Navigate through the list and select frameworks #1-12(of Step #2) under the `Frameworks` folder and click `Add`
![Add New Copy Files Phase](https://preview.ibb.co/cnuyTQ/Screen_Shot_2017_06_13_at_12_32_52_PM.png)

11. Make sure that all added Frameworks from Step #10 have the **Code Sign On Copy** checked.
![Copy Files Phase](https://preview.ibb.co/ebOQ8Q/Screen_Shot_2017_06_13_at_12_24_43_PM.png)

Make sure that the selected `Destination` is set to **Frameworks**

12. Make sure that frameworks on each build phases should be the same as these lists.
![embedded binaries](https://user-images.githubusercontent.com/10010236/28449628-19f590a4-6e14-11e7-814b-8437d08f9d02.png)
![linked frameworks and libraries](https://user-images.githubusercontent.com/10010236/28449631-1bc71b14-6e14-11e7-82aa-5f74c3067404.png)
![link binary with libraries](https://user-images.githubusercontent.com/10010236/28449632-1d97dfbe-6e14-11e7-8837-6e699a37e871.png)
![copy files](https://user-images.githubusercontent.com/10010236/28449635-1f0eab48-6e14-11e7-9c3a-5a17e8a8daa7.png)

13. Initial setup is done! Try and build your project. 

If you encounter an error relating to `unresolved symbols`, you need to target your Xcode on an actual iOS Device (e.g. iPhone) instead of using iOS Simulator. See below for an explanation of this.

## Code Usage Example

Before anything else, you must have a registered [EVRYTHNG developer account](https://developers.evrythng.com/docs/using-the-dashboard-overview#section-getting-started).

### Initialization
1. In your app’s _**Info.plist**_ file and declare the following key-value properties:
    `evrythng_app_token: <YOUR_API_KEY>` **(optional)**

![Info.plist](https://preview.ibb.co/efFu2k/Screen_Shot_2017_06_13_at_12_26_21_PM.png)

If you wish to use the **Scan** feature of the SDK, you **MUST** include:

```
Privacy - Camera Usage Description: <YOUR_MESSAGE_STRING>
```

as this will be the message that will be prompted to the user upon request to use the App's camera device.

2. In your `AppDelegate`, declare your import of the SDK:

```
import EvrythngiOS
```

3. In your AppDelegate's `didFinishLaunchingWithOptions()` insert:

```
Evrythng.initialize(delegate: nil)
```
         
 4. If you wish to enable debugging(disabled by default), you may do so by including:

```
Evrythng.DEBUGGING_ENABLED = true
```

### View Controller Implementation

1. Declare your import of the SDK:

```
import EvrythngiOS
```

2. In your ViewController's `viewDidLoad()`, insert the code:

```
let evrythngApiManager = EvrythngApiManager(apiKey: “<insert_your_api_key_here>”)
```

or

```
let evrythngApiManager = EvrythngApiManager()
```

Use the latter if you have already declared the API key in your app’s **Info.plist** just as stated in _SDK Initialization **Step #1**_

### Creating a Non-Anonymous User

To test if your API Key works, let's take an example by creating an User in `viewDidLoad()`:

```
let newUser = User()
newUser.firstName = "John"
newUser.lastName = "Doe"
newUser.email = "johndoe@testemail.com"
newUser.password = "test1234"

apiManager.authService.evrythngUserCreator(user: newUser).execute(completionHandler: { (credentials, err) in
    print("Credentials: \(String(describing: credentials?.jsonData))")
})
```

### Creating an Anonymous User

In some cases, you can allow a user without actually going through the registration:

```
evrythngApiManager.authService.evrythngUserCreator(user: nil).execute(completionHandler: { (credentials, err) in
    print("Credentials: \(String(describing: credentials?.jsonData))")
})
```

As you can see above, you just have to set the user argument to `nil` and the function will return a valid Credentials object if the request succeeded.

Now, run your app in a real device and you should see something similar in your Xcode's Console Window:

![Console Window Output](https://preview.ibb.co/kUUX55/Screen_Shot_2017_06_13_at_8_41_01_PM.png)

### Activating / Validating a Newly-Registered Non-Anonymous User

Before you can actually use and login your newly created non-anonymous `User`, you first have to activate / validate it:

```
apiManager.authService.evrythngUserValidator(userId: userId, activationCode: activationCode).execute(completionHandler: { (credentials, err) in
    if(err != nil) {
        completion?(nil, err)
    } else {
        print("Creds: \(String(describing: credentials))")
        if let createdCredentialsStringResp = credentials?.jsonData?.rawString() {
            print("Validation Credentials: \(createdCredentialsStringResp)")
        }
        completion?(credentials, nil)
    }
})
```

where `userId` and `activationCode` is the `evrythngUser` and `activationCode` properties you get from the `Credentials` object upon User registration, respectively.

### Authenticating a User (Not anonymous)

```
 evrythngApiManager.authService.evrythngUserAuthenticator(email: email, password: password).execute(completionHandler: { (credentials, err) in
    if(err != nil) {
        completion?(nil, err)
    } else {
        if let createdCredentialsStringResp = credentials?.jsonData?.rawString() {
            print("Created Credentials: \(createdCredentialsStringResp)")
        }
        completion?(credentials, nil)
    }
})
```

### Scanning an Product / Thng

**Using the device's camera**

You can use the default integrated barcode scanner by using the following code:

```
let evrythngScanner = EvrythngScanner.init(presentedBy: self, withResultDelegate: self)
evrythngScanner.scanBarcode()
```

In your ViewController, you must implement the protocol `EvrythngIdentifierResultDelegate` to get the results:

```
// MARK: EvrythngIdentifierResultDelegate

extension ViewController: EvrythngIdentifierResultDelegate {

    public func evrythngScannerWillStartIdentify() {
        // Notifies you that the scanning will commence
    }

    public func evrythngScannerDidFinishIdentify(scanIdentificationsResponse: EvrythngScanIdentificationsResponse?, value: String, error: Swift.Error?) {
        // Notifies you if the scanning succeeds / fails
    }
}
```

If the scanning succeeds, you can inspect the `scanIdentificationsResponse`:

```
if let scanResponse = scanIdentificationsResponse {        
    if let results = scanResponse.results {
        print("Scan Result Successful: \(value)")
        print("Results: \(String(describing:scanResponse.results)")
    }
}
```

Otherwise, you may check the value of `error`:

```
if let err = error { 
    print("Scan Result Error: \(err.localizedDescription)")
}
```

**Using `UIImage` instance**

The SDK also allows you to scan a barcode directly from a UIImage instance using the following code in your ViewController:

```
let evrythngScanner = EvrythngScanner.init(presentedBy: self, withResultDelegate: self)
evrythngScanner.scanBarcodeImage(image: UIImage(named:"<your_own_image>")!)
```

Similarly, you can get the results the same way when using the device's camera with the implementation of the `EvrythngIdentifierResultDelegate`:

```
// MARK: EvrythngIdentifierResultDelegate

extension ViewController: EvrythngIdentifierResultDelegate {

    public func evrythngScannerWillStartIdentify() {
        // Notifies you that the scanning will commence
    }

    public func evrythngScannerDidFinishIdentify(scanIdentificationsResponse: EvrythngScanIdentificationsResponse?, value: String, error: Swift.Error?) {
        // Notifies you if the scanning succeeds / fails
    }
}
```

If the scanning succeeds, you can inspect the `scanIdentificationsResponse`:

```
if let scanResponse = scanIdentificationsResponse {        
    if let results = scanResponse.results {
        print("Scan Result Successful: \(value)")
        print("Results: \(String(describing:scanResponse.results)")
    }
}
```

Otherwise, you may check the value of `error`:

```
if let err = error { 
    print("Scan Result Error: \(err.localizedDescription)")
}
```

<!--
### Custom Scanning
-->
<!--
In some cases, you may also opt to use a pre-determined encoded barcode value to identify a `Product` or `Thng` explicitly by using the following code:
-->
<!--
```
evrythngApiManager.scanService.evrythngScanOperator(scanType: <EvrythnngScanTypes>, scanMethod: <EvrythngScanMethods>, value: <barcode_value>).execute { (scanIdentifactionsResponse, err) in
    completionHandler(scanIdentifactionsResponse, err)
}
```
-->
<!--
where `scanType` and `scanMethod` are of `EvrythnngScanTypes` and `EvrythngScanMethods` Enum types, respectively. (Reference: https://developers.evrythng.com/v3.0/docs/identifier-recognition)
-->

<!--
### Custom Scanning Using an Image
-->
<!--
The SDK also allows you to use an image to identify a `Product`. There are two ways to do this. One is to provide the Base64 string value of your image and the other, by providing the actual `UIImage` instance and letting the SDK do the conversion implicitly for you.
-->
<!--
**Using `Base64 String` value**
-->
<!--
If you have the base64 string representation, you may use it immediately:
-->
<!--
```
//note: string is truncated for example's sake
let base64Value:String = "data:image/png;base64,iVBORw0KGgoAAAANSUh..."
```
-->
<!--     
Otherwise; you may use the SDK's `UIImage` extension to convert it first to a base64 string:
-->
<!--
```
let base64Value:String = myUIImage.toBase64()!
```
-->
<!--
Then, explicitly invoke evrythngScanOperator and pass the base64 string as depicted below:
-->
<!--
```            
evrythngApiManager.scanService.evrythngScanOperator(imageBase64Value: base64Value).execute(completionHandler: { (scanIdentificationsResponse, error) in
    completionHandler(scanIdentifactionsResponse, err)
})
```
-->
<!--
**Using `UIImage` instance**
-->
<!--
Create your own UIImage
-->
<!--
```
let myUIImage:UIImage! = UIImage(named: "mySampleImage.png")!
```
-->
<!--
Then, explicitly invoke evrythngScanOperator and pass the `UIImage` instance:
-->
<!--
```
evrythngApiManager.scanService.evrythngScanOperator(image: myUIImage).execute(completionHandler: { (scanIdentificationsResponse, error) in
    completionHandler(scanIdentifactionsResponse, err)
})
```
-->

### Logging Out a User

Log a non-anonymous user out by providing their App User API key:

```
evrythngApiManager.authService.evrythngUserLogouter(apiKey: credentials.evrythngApiKey!).execute(completionHandler: { (logoutResp, err) in }
```

### Other Important Developer Notes

Please note that you will have to target your project against an actual test device (non-simulator e.g. iPhone) for you to successfully compile your Xcode Project. This is the target behavior as of now as this relieves you (the developer) the issue when you submit your app (.ipa) on AppStore since `EvrythngiOS.framework` does not target an iOS Simulator(x86) architecture which Apple prohibits.

In case you wanted to run EvrythngiOS.framework on simulator follow these instruction

1.  Go to Build Settings -> Architecture -> Valid Architecture -> Debug -> Add x86_64
![valid arch](https://user-images.githubusercontent.com/10010236/28452026-56269014-6e23-11e7-8cf8-d7ae6513c48f.png)
2.  Go to Xcode Product then Build
3. You can now add EvrythngiOS.framework under the products group to your project 

## FAQs (Frequently Asked Questions)

1. Q: I have completed importing the Frameworks and when I try to build/run it crashes upon loading

A: <b>Make you sure you followed Steps #9 onwards. </b> 

2. Q: I have completed Steps #9 onwards and when I try to build / run, it says something like `No Such Module`, `Use of unresolved identifier`, etc.

A: <b>Make sure you followed Step #13 wherein you need to target Xcode to an actual device (e.g. iPhone)</b> 
