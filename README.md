## Minimum Requirements: 
Xcode 8.3 / Swift 3

## Project Setup
1. Download the [respository](https://github.com/evrythng/evrythng-ios-sdk)
2. After downloading, do take note of the following frameworks in the topmost folder:
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
3. If you’ve already created your own Xcode Project, you may skip and proceed to **Step #7** instead. Otherwise, continue to the next step.
4. Create a new project and choose `Single View Application`. Click `Next`
5. Fill in the required fields and click `Next`.
6. Select the folder where you want to save your project. Click `Save`
7. Navigate to `Project Navigator` and drag the 12 frameworks stated in **Step #2** inside `Frameworks` folder and ensure that **Copy Files if Needed** is checked.
8. Navigate to your _**Project’s Targets**_ -> `Build Phases` -> `Link Binary With Libraries` and ensure that all 12 frameworks are included in the list
![Link Binary with Libraries](https://preview.ibb.co/g60GF5/Screen_Shot_2017_06_13_at_12_24_30_PM.png)

9. Still in your _**Project’s Targets**_ -> `Build Phases` tab add a **New Copy Files Phase** by clicking the `+` button on the upper left portion of the window below the `General` tab
10. Navigate through the list and add select all the 12 frameworks under the `Frameworks` folder and click `Add`

![Add New Copy Files Phase](https://preview.ibb.co/cnuyTQ/Screen_Shot_2017_06_13_at_12_32_52_PM.png)

11. Make sure that all added Frameworks have the **Code Sign On Copy** checked
![Copy Files Phase](https://preview.ibb.co/ebOQ8Q/Screen_Shot_2017_06_13_at_12_24_43_PM.png)
12. Initial setup is done! Try and build your project. 

## Code Usage Example

### Initialization
1. In your app’s _**Info.plist**_ file and declare the following key-value properties:
    `evrythng_app_token: <YOUR_API_KEY>` **(optional)**

![Info.plist](https://preview.ibb.co/efFu2k/Screen_Shot_2017_06_13_at_12_26_21_PM.png)

If you wish to use the **Scan** feature of the SDK, you **MUST** include:

       Privacy - Camera Usage Description: <YOUR_MESSAGE_STRING>

as this will be the message that will be prompted to the user upon request to use of the App's camera device.

2. In your `AppDelegate`, declare your import of the SDK:

       import EvrythngiOS

3. In your AppDelegate's `didFinishLaunchingWithOptions()` insert:

       Evrythng.initialize(delegate: nil)
         
   if you wish to enable debugging, you may do so by having: 

       Evrythng.DEBUGGING_ENABLED = true

### View Controller Implementation

1. Declare your import of the SDK:

         import EvrythngiOS

2. In your ViewController's `viewDidLoad()`, insert the code:


         let evrythngApiManager = EvrythngApiManager(apiKey: “<insert_your_api_key_here>”)


or


     let evrythngApiManager = EvrythngApiManager()


 Use the latter if you have already declared the api key in your app’s **Info.plist** just as stated in _SDK Initialization **Step #1**_

### Creating an Anonymous User

To test if your API Key works, let's take an example by creating an anonymous user in `viewDidLoad()`:

     evrythngApiManager.authService.evrythngUserCreator(user: nil).execute(completionHandler: { (creds, err) in
         print("Credentials: \(String(describing: creds?.jsonData))")
     })

Now, run your app in a real device and you should see something similar in your Xcode's Console Window:

![Console Window Output](https://preview.ibb.co/kUUX55/Screen_Shot_2017_06_13_at_8_41_01_PM.png)

### Authenticating a User (Not anonymous)

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

### Scanning an Product / Thng

You can use the default integrated barcode scanner by using the following code:

      let evrythngScanner = EvrythngScanner.init(presentedBy: self, withResultDelegate: self)
      evrythngScanner.scanBarcode()

or you may opt to use your own custom Barcode Scanner and just use the following code upon successfully retrieving the barcode value result:

      evrythngApiManager.scanService.evrythngScanOperator(scanType: <scan_type>, scanMethod: <scan_method>, value: <barcode_value>).execute { (scanIdentifactionsResponse, err) in
                completionHandler(scanIdentifactionsResponse, err)
            }

### Logging Out a User

       evrythngApiManager.authService.evrythngUserLogouter(apiKey: credentials.evrythngApiKey!).execute(completionHandler: { (logoutResp, err) in }

Hooray! You've just integrated Evrythng iOS SDK into your application!
