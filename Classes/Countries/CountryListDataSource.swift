//
//  CountryListDataSource.swift
//  
//
//  Created by Saad Basha on 5/17/17.
//  Copyright © 2017 Saad Basha. All rights reserved.
//

import UIKit

struct kCountryDefaults {
    
    static let kCountryName        = "name"
    static let kCountryCallingCode = "dial_code"
    static let kCountryCode        = "code"
    static let kArabicCountryName  = "ar_name"
    static let kCountriesFileName  = "countries.json"
    
}

class CountryListDataSource: NSObject {

    private var countriesList : [Dictionary<String,Any>]?

    override init() {
        super.init()
        
        self.parseJSON()
        
    }
    
    func countries()->[Dictionary<String,Any>]{
    
        return countriesList!;

    }
    
    private func parseJSON(){
        
        let data = NSData(contentsOfFile: Bundle.main.path(forResource: "countries", ofType: "json")!)
    
        do {
        
            let parsedObject = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)
        
            self.countriesList = parsedObject as? [Dictionary<String,Any>]
            
        }catch {
        
            print("Cannot be parsed for some reason")
        
        }
        
    
    }

}
