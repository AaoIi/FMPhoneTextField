//
//  Language.swift
//  FMPhoneTextField
//
//  Created by Mobile build server on 8/29/19.
//  Copyright © 2019 Saad Basha. All rights reserved.
//

import UIKit

public enum language {
    case english
    case arabic
}

class LanguageManager{
    
    var title : String?
    var cancel : String?
    var allCountries:String?
    var search:String?
    
    init(language:language) {
        self.setupLanguage(language:language)
    }
    
    private func setupLanguage(language:language){
        
        switch language {
        case .english:
            
            self.title =  "Select Country"
            self.cancel = "Cancel"
            self.allCountries =  "ALL COUNTRIES"
            self.search = "Search"
            
        case .arabic:
            
            self.title =  "اختر الدولة"
            self.cancel =  "إلغاء"
            self.allCountries = "جميع الدول"
            self.search =  "البحث"

        }
        
    }
    
}
