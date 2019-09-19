//
//  CountryCell1.swift
//  BookDoctor
//
//  Created by Saad Albasha on 11/12/18.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {
    
    @IBOutlet var containerViewLogo: UIView!
    @IBOutlet var logo: UIImageView!{
        didSet{
            logo.layer.borderWidth = 0.5
            logo.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet var name: UILabel!
    @IBOutlet var code: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.accessoryType =  selected ? .checkmark : .none
        
    }
    
    func populateCell<T>(object: T?,isCountryCodeHidden:Bool,language:language) where T : Decodable, T : Encodable {

        guard let country = object as? CountryElement else{return}
        
        self.logo?.image = UIImage(named: country.isoShortCode?.lowercased() ?? "",in: Bundle.getFrameworkBundle(),compatibleWith: nil)
        
        self.code?.text = isCountryCodeHidden ? "" : country.countryInternationlKey
        self.code?.textColor = .gray
        
        self.name?.text = language == .arabic ? country.nameAr : country.nameEn
        
        self.textLabel?.textColor = .black
        self.textLabel?.numberOfLines = 0
        self.textLabel?.sizeToFit()
        
    }
    
}
