
# FMPhoneTextField

FMPhoneTextField provides a simple and easy way to deal with mobile number field by selecting the country from a list which supports Arabic and English language, And it will find the current country of user using SIM card or locale (your choise).

It is compatible with **iOS** (9.0 - 13.0)

## Preview
<img src="https://github.com/AaoIi/FMPhoneTextField/blob/master/sample.png?raw=true">

# IMPORTANT

## Supporting Swift 5+

To install **FMPhoneTextField** for Swift 5.x using CocoaPods, include the following in your Podfile
```
pod 'FMPhoneTextField', '~> 1.0'
```

## Installation

### CocoaPods
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

## How to use?

### Subclass textfield to **FMPhoneTextField**
```swift
@IBOutlet var countryTextField: FMPhoneTextField!
```

### Calling initiate method is the core of handling everything
```swift
countryTextField.initiate(delegate: FMPhoneDelegate, language: language)
```

### Style
```swift
countryTextField.setBorderColor(_ color: UIColor,width:CGFloat)
countryTextField.setCornerRadius(_ size:CGFloat)
countryTextField.setBackgroundTint(_ color:UIColor)
countryTextField.setCountryCodeTextColor(_ color:UIColor)
countryTextField.setSeparatorColor(_ color:UIColor)
```

### Getting the phone number starting with 00/+
```swift
countryTextField.getPhoneNumberIncludingIAC(withPlus: false)
```

### Validation
```swift
let isValid = self.countryTextField.validatePhone()
```

### Customization

#### Find out the default country depending on phone locale or cellular (Must be called before initiate)
```swift
countryTextField.setDefaultCountrySearch(to: .locale)
```

#### Set country code display (Must be called before initiate)
```swift
countryTextField.setCountryCodeDisplay(type: .bothIsoShortCodeAndInternationlKey)
```

#### Hide Country code in list 
```swift
countryTextField.setCountryCodeInList(hidden: false)
```

### FMPhoneDelegate
```swift
func didSelectCountry(_ country: CountryElement) {

    //have access on selected country
}

func didGetDefaultCountry(success: Bool, country: CountryElement?) {

    if success{
        // updated already
    }else {

    // Fail to get default code in these cases:
    // 1.Airplane mode.
    // 2.No SIM card in the device.
    // 3.Device is outside of cellular service range.

    // Set Default Text
    let country = CountryElement(isoCode: "USA", isoShortCode: "US", nameAr: "الولايات المتحدة الامريكية", nameEn: "United States", countryInternationlKey: "+1",phoneRegex:"")
    countryTextField.updateCountryDisplay(country: country)

    }

}
```

## Want to help?

Got a bug fix, or a new feature? Create a pull request and go for it!
