//
//  ViewController.swift
//  FMPhoneTextField-Example
//
//  Created by Mobile build server on 9/19/19.
//  Copyright © 2019 Saad Albasha. All rights reserved.
//

import UIKit
import FMPhoneTextField

class ViewController: UIViewController{
    
    @IBOutlet var countryTextField: FMPhoneTextField!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryTextField.setDefaultCountrySearch(to: .locale)
        countryTextField.setCountryCodeInList(hidden: false)
        countryTextField.setCountryCodeDisplay(type: .bothIsoShortCodeAndInternationlKey)
        countryTextField.initiate(delegate: self, language: .english) // must be called
        
        // Setup Textfield Style
        countryTextField.setBorderColor(UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0), width: 1)
        countryTextField.setCornerRadius(7)
        countryTextField.setBackgroundTint(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0))
        countryTextField.setCountryCodeTextColor(UIColor(red: 107/255, green: 174/255, blue: 242/255, alpha: 1.0))
        countryTextField.setSeparatorColor(UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0))
        
    }
    
    
    //MARK: - Actions and Selectors
    
    @IBAction func validateAction(_ validationButton: UIButton) {
        
        if self.countryTextField.validatePhone() {
            
            print(self.countryTextField.getPhoneNumberIncludingIAC(withPlus: false))
            
            validationButton.setTitle("Valid Phone", for: .normal)
            
        }else {
            
            validationButton.setTitle("Invalid Phone", for: .normal)
            
        }
        
    }
    
}

//MARK: - Country TextField Delegate
extension ViewController:FMPhoneDelegate {
    
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
            let country = CountryElement(isoCode: "JOR", isoShortCode: "JO", nameAr: "الاردن", nameEn: "Jordan", countryInternationlKey: "+962",phoneRegex:"")
            countryTextField.updateCountryDisplay(country: country)
            
        }
        
    }
    
}

