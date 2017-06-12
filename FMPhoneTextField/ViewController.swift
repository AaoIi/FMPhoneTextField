//
//  ViewController.swift
//  FMPhoneTextField
//
//  Created by Saad Basha on 6/5/17.
//  Copyright © 2017 Saad Basha. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CountryTextFieldDelegate {

    
    @IBOutlet var countryTextField: FMCountryTextField!{
        didSet{
            //countryTextField.isArabic = true
            countryTextField.countryDelegate = self
        }
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Textfield Style
        countryTextField.setBorderColorWithWidth(UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0), width: 1)
        countryTextField.setCornerRadius(7)
        countryTextField.setBackgroundTint(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0))
        countryTextField.setCountryCodeLabelTextColor(UIColor(red: 107/255, green: 174/255, blue: 242/255, alpha: 1.0))
        countryTextField.setSeparatorBackgroundColor(UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions and Selectors
    
    @IBAction func validateAction(_ sender: Any) {
        
        if self.countryTextField.validatePhone() {
            
            print(self.countryTextField.getPhoneNumberWithCode(withPlus: false))
            
            (sender as! UIButton).setTitle("Valid Phone", for: .normal)
            
        }else {
            
            (sender as! UIButton).setTitle("Invalid Phone", for: .normal)
            
        }
        
    }
    
    //MARK: - Country TextField Delegate
    
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


}

