//
//  CountryListDataSource.swift
//  
//
//  Created by Saad Basha on 5/17/17.
//  Copyright © 2017 Saad Basha. All rights reserved.
//

import UIKit

class CountryListDataSource {

    private static var country : Country? = {
        return parseJSON()
    }()

    static func getCountries(language:language)->[CountryElement]?{
     
        let sortedCountries = self.country?.countries?.sorted { language == .arabic ? $0.nameAr ?? "" < $1.nameAr ?? "" : $0.nameEn ?? "" < $1.nameEn ?? "" }
        
        return sortedCountries

    }
    
    private static func parseJSON()->Country?{
        
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let coder = JSONDecoder()
                let parsedObject = try coder.decode(Country.self, from: data)
                
                return parsedObject

            } catch (let error){
                // handle error
                print("Cannot be parsed because : \(error.localizedDescription)")
            }
        }

        return Country(countries: [])
    
    }

}
