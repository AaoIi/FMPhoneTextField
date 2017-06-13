
# FMPhoneTextField

FMPhoneTextField provides a simple and easy way to deal with mobile number field by selecting the country from a list which supports Arabic and English language, And it will find the current location of user using SIM card.

It is compatible with **iOS** (8.0 - 10.0)

## Preview
<img src="https://github.com/AaoIi/FMPhoneTextField/blob/master/sample.png?raw=true">

# IMPORTANT

## Supporting Swift 3+

To install **FMPhoneTextField** for Swift 3.x using CocoaPods, include the following in your Podfile
```
pod 'FMPhoneTextField', '~> 1.0'
```
To install **FMPhoneTextField** for Swift 3.x using Carthage, include the following in your Cartfile
```
github "aaoii/FMPhoneTextField" ~> 1.0
```

## Installation
### Manual
Just drop the **FMPhoneTextField/Classes** folder into your project. That's it!

### CocoaPods (Pending)
[CocoaPods][] is a dependency manager for Cocoa projects. To install FMPhoneTextField with CocoaPods:

 1. Make sure CocoaPods is [installed][CocoaPods Installation].

 2. Update your Podfile to include the following:

    ``` ruby
    use_frameworks!
    pod 'FMPhoneTextField'
    ```

 3. Run `pod install`.

[CocoaPods]: https://cocoapods.org
[CocoaPods Installation]: https://guides.cocoapods.org/using/getting-started.html#getting-started
 
 4. In your code import FMPhoneTextField like so:
   `import FMPhoneTextField`

### Carthage (Pending)
[Carthage][] is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.
To install FMPhoneTextField with Carthage:

1. Install Carthage via [Homebrew][]
  ```bash
  $ brew update
  $ brew install carthage
  ```

2. Add `github "aaoii/FMPhoneTextField"` to your Cartfile.

3. Run `carthage update`.

4. Drag `FMPhoneTextField.framework` from the `Carthage/Build/iOS/` directory to the `Linked Frameworks and Libraries` section of your Xcode project’s `General` settings.

5. Add `$(SRCROOT)/Carthage/Build/iOS/FMPhoneTextField.framework` to `Input Files` of Run Script Phase for Carthage.

[Carthage]: https://github.com/Carthage/Carthage
[Homebrew]: http://brew.sh


## Example

```swift
//subclass the textfield from storyboard using identity inspector by setting the Class to **FMCountryTextField**
//declare this property and connnect it to your storyboard textfield
//add the CountryTextFieldDelegate to your class 

    @IBOutlet var countryTextField: FMCountryTextField!{
        didSet{
            //countryTextField.isArabic = true
            countryTextField.countryDelegate = self
        }
    }

//declare this inside of viewDidLoad to style your textfield or override the current style

	countryTextField.setBorderColorWithWidth(UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0), width: 1)
	countryTextField.setCornerRadius(7)
	countryTextField.setBackgroundTint(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0))
    countryTextField.setCountryCodeLabelTextColor(UIColor(red: 107/255, green: 174/255, blue: 242/255, alpha: 1.0))
    countryTextField.setSeparatorBackgroundColor(UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0))

//validate the phone using this proparty

	countryTextField.validatePhone() 

//get full number with country code with + or 00

	countryTextField.getPhoneNumberWithCode(withPlus: false)
	
//add the delegate method to your class its manditory when it fail's to get the current user country

    func didFindDefaultCounryCode(_ success: Bool, withInfo info: (dialCode: String?, code: String?)) {
        
        if success{
            
        }else {
            
            // Fail to get default code in these cases:
            // 1.Airplane mode.
            // 2.No SIM card in the device.
            // 3.Device is outside of cellular service range.
            
            // Set Default Text
            countryTextField.updateCountryLabel(info: (dialCode: "JO", code: "+962", name: "Jordan"))
            
        }
        
    }

```

## Want to help?

Got a bug fix, or a new feature? Create a pull request and go for it!
