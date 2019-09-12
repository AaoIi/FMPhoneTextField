//
//  Country.swift
//  FMPhoneTextField
//
//  Created by Mobile build server on 8/28/19.
//  Copyright © 2019 Saad Basha. All rights reserved.
//

import Foundation

// MARK: - Country
public struct Country: Codable {
    let countries: [CountryElement]?
}

// MARK: - CountryElement
public struct CountryElement: Codable {
    let isoCode: String?
    let isoShortCode: String?
    let nameAr, nameEn, countryInternationlKey: String?
    let phoneRegex: String?
    
    enum CodingKeys: String, CodingKey {
        case isoCode, isoShortCode, nameAr, nameEn,
        countryInternationlKey, phoneRegex
    }
}
