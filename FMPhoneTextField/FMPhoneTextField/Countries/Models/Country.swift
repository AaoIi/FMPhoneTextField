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
    public let isoCode: String?
    public let isoShortCode: String?
    public let nameAr, nameEn, countryInternationlKey: String?
    public let phoneRegex: String?
    
    public enum CodingKeys: String, CodingKey {
        case isoCode, isoShortCode, nameAr, nameEn,
        countryInternationlKey, phoneRegex
    }
    
    public init(isoCode: String?, isoShortCode: String?, nameAr: String?, nameEn: String?, countryInternationlKey: String?,phoneRegex: String?) {
        self.isoCode = isoCode
        self.isoShortCode = isoShortCode
        self.nameAr = nameAr
        self.nameEn = nameEn
        self.countryInternationlKey = countryInternationlKey
        self.phoneRegex = phoneRegex
    }
}
