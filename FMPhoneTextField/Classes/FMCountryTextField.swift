//
//  FMCountryTextField.swift
//
//
//  Created by Saad Basha on 5/16/17.
//  Copyright © 2017 Saad Basha. All rights reserved.
//

import UIKit

protocol CountryTextFieldDelegate {
    
    func didFindDefaultCounryCode(_ success:Bool,withInfo info: (dialCode:String?,code:String?))
    
}

class FMCountryTextField: UITextField,CountryListViewDelegate {
    
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
    
    var countryDelegate : CountryTextFieldDelegate?
    var isArabic = false
    private var info : (dialCode:String?,code:String?,name:String?)!
    
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add country left View
        self.addCountryView()
        
        // Setup TextField Keyboard
        if #available(iOS 10, *){
            
            self.keyboardType = .asciiCapableNumberPad
            
        }else {
        
            self.keyboardType  = .phonePad
        
        }

        self.getCurrentCountryCode()

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    

    
    //MARK: - Update Views

    func updateCountryLabel(info: (dialCode:String,code:String,name:String)){
    
        self.countryCodeLabel.text = "\(info.dialCode) \(info.code)"
        self.info = (info.dialCode,info.code,info.name)
    
    }
    
    func getPhoneNumberWithCode(withPlus:Bool = false)->String{
    
        guard let code = self.info.code else { print("Error:Could not get the dial Code"); return "" }

        if withPlus {
            
            if self.text!.characters.count > 0 {
                if self.text!.characters.first == "0" {
                    let phone = String(self.text!.characters.dropFirst())
                    self.text! = phone
                }
            }
            
            return  code + self.text!
            
        }else {
        
            let code = code.replacingOccurrences(of: "+", with: "00")
            if self.text!.characters.count > 0 {
                if self.text!.characters.first == "0" {
                    let phone = String(self.text!.characters.dropFirst())
                    self.text! = phone
                }
            }
            
            return  code + self.text!
        
        }
        
    
    }

    //MARK: - Validation Method
    
    func validatePhone()->Bool{
    
        let phoneRegex = "(\\d{9,10})"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        return phoneTest.evaluate(with: self.text)
    
    }
    
    //MARK: - Helping Methods
    
    private func getCurrentCountryCode(){
        
        let currentLocale : NSLocale = NSLocale.current as NSLocale
        let countryCode = currentLocale.object(forKey: NSLocale.Key.countryCode) as? String
        
        let countries = CountryListDataSource().countries()
        
        for country in countries {
            
            if country[kCountryDefaults.kCountryCode] as? String == countryCode {
                
                let dialCode = (country[kCountryDefaults.kCountryCallingCode]) as! String
                let code = (country[kCountryDefaults.kCountryCode]) as! String
                let name = self.isArabic ? (country[kCountryDefaults.kArabicCountryName]) as! String : (country[kCountryDefaults.kCountryName]) as! String
                
                self.updateCountryLabel(info: (dialCode: dialCode, code: code, name: name))
                
                guard let delegate = self.countryDelegate else {print("Error:delegate is not set"); return }
                delegate.didFindDefaultCounryCode(true, withInfo: (dialCode: dialCode, code: code))
                
                break;
            }
            
        }
        
        guard let delegate = self.countryDelegate else { return }
        delegate.didFindDefaultCounryCode(false, withInfo: (dialCode: nil, code: nil))
        
    }
    
    private func getTopMostViewController()->UIViewController?{
    
        guard let keyWindow = UIApplication.shared.keyWindow else { return nil}
        guard let visableVC = keyWindow.visibleViewController() else { return nil}

        return visableVC
    
    }
    
    
    //MARK: - Country Left View
    
    private func addCountryView(){
        
        let height = self.frame.size.height;
        let frame = CGRect(x:0,y:0,width: self.frame.size.width / 2.9,height: height)
        
        // Setup main View
        self.contentViewholder = UIView(frame: frame)
        self.contentViewholder.backgroundColor = .clear
        
        // Setup Button
        self.countryButton = UIButton(frame: frame)
        self.countryButton.backgroundColor = .clear

        // Setup label
        let startPadding = self.frame.size.width / 3.2
        let labelOriginX = frame.width - startPadding
        let labelWidth = frame.width - labelOriginX - labelOriginX
        
        self.countryCodeLabel = UILabel(frame: CGRect(x:labelOriginX,y:frame.origin.y,width: labelWidth,height: height))
        self.countryCodeLabel.text = ""
        self.countryCodeLabel.textAlignment = .center
        self.countryCodeLabel.minimumScaleFactor = 0.5
        
        // Setup separator
        let topPadding = height / 3.5
        self.separator = UIView(frame: CGRect(x:labelWidth + labelOriginX + (labelOriginX / 4.0),y:topPadding,width: 1,height: height - topPadding*2))
        
        // Set default style
        self.separator.backgroundColor = separatorBackgroundColor
        self.countryCodeLabel.textColor = codeTextColor
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.borderWidth = self.borderWidth
        self.layer.cornerRadius = self.cornerRadius
        self.layer.masksToBounds = true
        self.backgroundColor = self.backgroundTintColor
        
        // Add Target To Button
        self.countryButton.addTarget(self, action: #selector(presentCountryView(_:)), for: .touchUpInside)
        
        // Setup contentView
        self.contentViewholder.addSubview(countryCodeLabel)
        self.contentViewholder.addSubview(countryButton)
        self.contentViewholder.addSubview(separator)
        
        self.leftViewMode = UITextFieldViewMode.always
        
        self.leftView = self.contentViewholder
        
        self.addSubview(self.contentViewholder)
        
        
    }
    
    
    //MARK: - Style
    
    func setBorderColorWithWidth(_ color: UIColor,width:CGFloat){
    
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    
    }
    
    func setCornerRadius(_ size:CGFloat){
    
        self.layer.cornerRadius = size
        self.layer.masksToBounds = true
    
    }
    
    func setBackgroundTint(_ color:UIColor){
    
         self.backgroundColor = color
        
    }
    
    func setCountryCodeLabelTextColor(_ color:UIColor){
    
        countryCodeLabel.textColor = color
    
    }
    
    func setSeparatorBackgroundColor(_ color:UIColor){
        
        separator.backgroundColor = color
        
    }
    
    //MARK: - Actions and Selectors
    
    @objc private func presentCountryView(_ textField:FMCountryTextField){
        
        let vc = CountryListViewController(nibName: "CountryListViewController", bundle: nil)
        vc.delegate = self
        if self.isArabic {
            vc.isArabic = self.isArabic
        }
        let navigation = UINavigationController(rootViewController: vc)
        guard let topMostViewController = self.getTopMostViewController() else { print("Could not present"); return }
        topMostViewController.present(navigation, animated: true, completion: nil)
        
    }
    
    //MARK: - Country Delegate
    
    internal func didSelectCountry(country: Dictionary<String, Any>) {
        
        let dialCode = (country[kCountryDefaults.kCountryCallingCode]) as! String
        let code = (country[kCountryDefaults.kCountryCode]) as! String
        let name = self.isArabic ? (country[kCountryDefaults.kArabicCountryName]) as! String : (country[kCountryDefaults.kCountryName]) as! String
        
        // update the country and the code
        self.updateCountryLabel(info: (dialCode: dialCode, code: code, name: name))
        
    }
    

}
