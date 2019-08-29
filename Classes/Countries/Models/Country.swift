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
    let phoneRegex: PhoneRegex?
}

public enum PhoneRegex: String, Codable {
    case the00109612 = "[0]{0,1}[0-9]{6,12}$"
    case the00171791097 = "[0]{0,1}[7]{1}[7-9]{1}[0-9]{7}$"
}
