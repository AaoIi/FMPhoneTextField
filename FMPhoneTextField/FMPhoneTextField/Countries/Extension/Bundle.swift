//
//  Bundle.swift
//  FMPhoneTextField
//
//  Created by Mobile build server on 9/19/19.
//  Copyright © 2019 Saad Albasha. All rights reserved.
//

import UIKit

extension Bundle {
    
    static func getFrameworkBundle()->Bundle?{
        let frameworkBundle = Bundle(for: FMPhoneTextField.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("FMPhoneTextField.bundle")
        return Bundle(url: bundleURL!)
    }
    
}
