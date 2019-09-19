//
//  FMPhoneTextField.swift
//
//
//  Created by Saad Basha on 5/16/17.
//  Copyright © 2017 Saad Basha. All rights reserved.
//

import UIKit
import CoreTelephony

public protocol FMPhoneDelegate : class{
    func didGetDefaultCountry(success:Bool,country: CountryElement?)
    func didSelectCountry(_ country:CountryElement)
}

public class FMPhoneTextField: UITextField {
    
    public enum CodeDisplay {
        case isoShortCode
        case internationlKey
        case bothIsoShortCodeAndInternationlKey
        case countryName
    }
    
    public enum SearchType {
        case cellular
        case locale
        case both
    }
    
    // Views
    private var contentViewholder : UIView!
    private var countryButton: UIButton!
    private var countryCodeLabel : UILabel!
    private var separator : UIView!
    
    // Default Styles
    private var borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
    private var borderWidth : CGFloat = 1
    private var cornerRadius : CGFloat = 7
    private var backgroundTintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
    private var codeTextColor = UIColor(red: 107/255, green: 174/255, blue: 242/255, alpha: 1.0)
    private var separatorBackgroundColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
    private var separatorWidth : CGFloat = 1
    private var defaultRegex = "(\\d{9,10})"
    
    private var selectedCountry : CountryElement?
    
    private weak var countryDelegate : FMPhoneDelegate?
    private var language : language! = .english
    private var defaultsSearchType : SearchType = .locale
    private var countryCodeDisplay : CodeDisplay = .bothIsoShortCodeAndInternationlKey
    private var isCountryCodeInListHidden : Bool = false

    //MARK: - Life cycle

    /// It will setup the view and layout, including getting the default country
    ///
    /// - Parameters:
    ///   - delegate: managing the details of country and phone field.
    ///   - language: selected language (arabic,english)
    public func initiate(delegate:FMPhoneDelegate,language:language){
        
        // update local variables
        self.countryDelegate = delegate
        self.language = language
        
        // force layout to be left to right
        self.semanticContentAttribute = .forceLeftToRight
        
        // Add country left View
        self.setupCountryView()
        
        // Setup TextField Keyboard
        if #available(iOS 10, *){
            self.keyboardType = .asciiCapableNumberPad
        }else {
            self.keyboardType  = .phonePad
        }
        
        self.getCurrentCountryCode()
    
    }
    
    //MARK: - Update Views
    
    /// This is called automaticaly after country is being selected, its responsible for displaying the country/code details
    ///
    /// - Parameter country: object to be displayed
    public func updateCountryDisplay(country: CountryElement){
        
        var text = ""
        
        switch countryCodeDisplay {
        case .bothIsoShortCodeAndInternationlKey:
            text = "\(country.isoShortCode ?? "") \(country.countryInternationlKey ?? "")"
            break;
        case .countryName:
             let name = language == .arabic ? country.nameAr : country.nameEn
             text = "\(name ?? "")"
             break;
        case .isoShortCode:
            text = "\(country.isoShortCode ?? "")"
            break;
        case .internationlKey:
            text = "\(country.countryInternationlKey ?? "")"
            break;
        }
        
        self.setupCountryView(text: text)
        self.selectedCountry = country
        
    }
    
    /// Get the phone number in full shape,
    /// IAC : International Access Code which is + or 00
    /// - Parameter withPlus: will return 00 if passed false else will return +
    /// - Returns: the full phone number including country code.
    public func getPhoneNumberIncludingIAC(withPlus:Bool = false)->String{
        
        guard let code = self.selectedCountry?.countryInternationlKey else { print("Error: Could not get country"); return "" }
        
        if withPlus {
            
            let text = self.text ?? ""
            
            if text.count > 0 {
                if text.first == "0" {
                    let phone = String(text.dropFirst())
                    self.text = phone
                }
            }
            
            return  code + (self.text ?? "")
            
        }else {
            
            let code = code.replacingOccurrences(of: "+", with: "00")
            let text = self.text ?? ""
            
            if text.count > 0 {
                if text.first == "0" {
                    let phone = String(text.dropFirst())
                    self.text = phone
                }
            }
            
            return  code + (self.text ?? "")
            
        }
        
        
    }
    
    //MARK: - Validation Method
    
    /// Will use the regex provided in each country object to validate the phone
    ///
    /// - Returns: valid phone or not
    public func validatePhone()->Bool{
        
        if self.selectedCountry == nil {
            return self.evaluate(text: self.text ?? "", regex: defaultRegex)
        }else {
            let mobile = self.text ?? ""
            let regex = self.selectedCountry?.phoneRegex ?? defaultRegex
            return self.evaluate(text: mobile, regex: regex)
        }
        
    }
    
    private func evaluate(text:String, regex:String)->Bool{
        let phoneRegex = regex
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: text)
    }
    
    //MARK: - Helping Methods
    
    private func getCurrentCountryCode(){
        
        var countryCode : String? = nil
        
        if self.defaultsSearchType == .locale {
            countryCode = FMPhoneTextField.getCountryCodeFromLocale()
        }else if self.defaultsSearchType == .cellular {
            countryCode = FMPhoneTextField.getCountryCodeFromCellularProvider()
        }else {
            countryCode = FMPhoneTextField.getCountryCodeFromCellularProvider() ?? FMPhoneTextField.getCountryCodeFromLocale()
        }
        
        guard let countries = CountriesDataSource.getCountries(language: language) else {return}
        
        for country in countries {
            
            if country.isoShortCode?.lowercased() == countryCode?.lowercased() {
                
                self.updateCountryDisplay(country: country)
                
                guard let delegate = self.countryDelegate else {print("Error:delegate is not set"); return }
                delegate.didGetDefaultCountry(success: true, country: country)
                
                return;
            }
            
        }
        
        guard let delegate = self.countryDelegate else { return }
        delegate.didGetDefaultCountry(success: false, country: nil)
        
    }
    
    private func getTopMostViewController()->UIViewController?{
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return nil}
        guard let visableVC = keyWindow.visibleViewController() else { return nil}
        
        return visableVC
        
    }
    
    
    //MARK: - Country Left View
    
    private func setupCountryView(text:String? = nil){
        
        // setup default size for leftview
        let height = self.frame.size.height;
        let frame = CGRect(x:0,y:0,width: self.frame.size.width / 2.9,height: height)
        
        // Setup main View
        self.contentViewholder = UIView(frame: frame)
        self.contentViewholder.backgroundColor = .clear
        
        // Setup Button and should be equal to left view frame
        self.countryButton = UIButton(frame: frame)
        self.countryButton.backgroundColor = .clear
        
        // Setup label size to be dynamicly resized
        let startPadding = self.frame.size.width / 3.2
        let labelOriginX = frame.width - startPadding
        let labelWidth = frame.width - labelOriginX - labelOriginX
        
        self.countryCodeLabel = UILabel(frame: CGRect(x:labelOriginX,y:frame.origin.y,width: labelWidth,height: height))
        self.countryCodeLabel.text = text
        self.countryCodeLabel.textAlignment = .center
        self.countryCodeLabel.sizeToFit()
        
        // Setup separator to be at trailing of left view
        let topPadding = height / 3.5
        let leftPadding : CGFloat = 8
        self.separator = UIView(frame: CGRect(x: self.countryCodeLabel.frame.width + labelOriginX + leftPadding,y:topPadding,width: separatorWidth,height: height - topPadding*2))
        
        // Set default style
        self.separator.backgroundColor = separatorBackgroundColor
        self.countryCodeLabel.textColor = codeTextColor
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.borderWidth = self.borderWidth
        self.layer.cornerRadius = self.cornerRadius
        self.layer.masksToBounds = true
        self.backgroundColor = self.backgroundTintColor
        
        // Add Target To Button
        self.countryButton.addTarget(self, action: #selector(presentCountries(_:)), for: .touchUpInside)
        
        // resize the left view depending on the views inside (label/separator/padding)
        let leftViewRightPadding : CGFloat = 8
        let newContentViewFrame = CGRect(x:0,y:0,width: self.countryCodeLabel.frame.width + labelOriginX + leftPadding + separatorWidth + leftViewRightPadding,height: height)
        self.contentViewholder = UIView(frame: newContentViewFrame)
        
        // Setup contentView
        self.contentViewholder.addSubview(countryCodeLabel)
        self.contentViewholder.addSubview(countryButton)
        self.contentViewholder.addSubview(separator)
        
        // set left view
        self.leftViewMode = UITextField.ViewMode.always
        self.leftView = self.contentViewholder
        
        // re center country code label
        self.countryCodeLabel.center.y = self.contentViewholder.center.y
        
    }
    
    //MARK: - Style
    
    public func setStyle(backgroundTint:UIColor,separatorColor:UIColor,borderColor:UIColor,borderWidth:CGFloat,cornerRadius:CGFloat,countryCodeTextColor:UIColor){
        
        self.setBorderColor(borderColor, width: borderWidth)
        self.setCornerRadius(cornerRadius)
        self.setBackgroundTint(backgroundTint)
        self.setCountryCodeTextColor(countryCodeTextColor)
        self.setSeparatorColor(separatorColor)
        
    }
    
    public func setBorderColor(_ color: UIColor,width:CGFloat){
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        
    }
    
    public func setCornerRadius(_ size:CGFloat){
        
        self.layer.cornerRadius = size
        self.layer.masksToBounds = true
        
    }
    
    public func setBackgroundTint(_ color:UIColor){
        
        self.backgroundColor = color
        
    }
    
    public func setCountryCodeTextColor(_ color:UIColor){
        
        countryCodeLabel.textColor = color
        
    }
    
    public func setSeparatorColor(_ color:UIColor){
        
        separator.backgroundColor = color
        
    }
    
    //MARK:- Display Customizations
    
    /// This is responsible to set the search algo for finding the country eather using locale or sim card, or even both.
    ///
    /// - Parameter type: SearchType
    public func setDefaultCountrySearch(to type:SearchType){
        
        self.defaultsSearchType = type
    }
    
    /// It will hide the country international key in the countries list
    ///
    /// - Parameter hidden: true or false
    public func setCountryCodeInList(hidden:Bool ){
        
        self.isCountryCodeInListHidden = hidden
    }
    
    /// This is responsible for setting your prefered way of showing the selected country in code field, Example US +1 or US or +1 etc.
    ///
    /// - Parameter type: CodeDisplay
    public func setCountryCodeDisplay(type:CodeDisplay){
        
        self.countryCodeDisplay = type
    }

    //MARK: - Actions and Selectors
    
    @objc private func presentCountries(_ textField:FMPhoneTextField){
        
        let vc = CountriesViewController(delegate: self, language: language,isCountryCodeHidden: self.isCountryCodeInListHidden)
        let navigation = UINavigationController(rootViewController: vc)
        guard let topMostViewController = self.getTopMostViewController() else { print("Could not present"); return }
        topMostViewController.present(navigation, animated: true, completion: nil)
        
    }
    
}

//MARK: - Country Delegate
extension FMPhoneTextField:CountriesDelegate {
    
    internal func didSelectCountry(country: CountryElement) {
        
        DispatchQueue.main.async {
            // update the country and the code
            self.updateCountryDisplay(country: country)
        }
        
        guard let delegate = self.countryDelegate else {return}
        delegate.didSelectCountry(country)
        
    }
    
}

//MARK: - Country Code Getters
fileprivate extension FMPhoneTextField {
    class func getCountryCodeFromCellularProvider() -> String? {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        return carrier?.isoCountryCode
    }
    
    class func getCountryCodeFromLocale() -> String? {
        let currentLocale : NSLocale = NSLocale.current as NSLocale
        let countryCode = currentLocale.object(forKey: NSLocale.Key.countryCode) as? String
        return countryCode
    }
}

//MARK: - View Controller Getter
fileprivate extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController  = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(_ vc:UIViewController) -> UIViewController {
        
        if vc.isKind(of: UINavigationController.self) {
            
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( navigationController.visibleViewController!)
            
        } else if vc.isKind(of: UITabBarController.self) {
            
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController!)
            
        } else {
            
            if let presentedViewController = vc.presentedViewController {
                
                return UIWindow.getVisibleViewControllerFrom(presentedViewController)
                
            } else {
                
                return vc;
            }
        }
    }
    
    
}
