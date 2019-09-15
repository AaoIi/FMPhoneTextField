//
//  CountriesViewController.swift
//
//
//  Created by Saad Basha on 5/17/17.
//  Copyright © 2017 Saad Basha. All rights reserved.
//

import UIKit

protocol CountriesDelegate : class{
    func didSelectCountry(country:CountryElement)
}

class CountriesViewController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet private var searchTextField : UITextField!
    @IBOutlet private var tableView : UITableView!
    @IBOutlet private var tableViewBottomConstraint: NSLayoutConstraint!
    
    private var countriesDataSourceArray : [CountryElement]?
    private var searchResultArray : [CountryElement]?
    
    private weak var delegate:CountriesDelegate?
    private var language : language!
    private var languageManager : LanguageManager!
    
    var isCountryCodeHidden = false
    var inheritApplicationStyle = false
    
    // cell configs
    private let countryCellIdentifier = "cell"
    private let estimatedHeightForCountryCell : CGFloat = 200
    
    
    //MARK: - Life Cycle
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    convenience init(delegate:CountriesDelegate?,language:language,isCountryCodeHidden:Bool = false) {
        self.init(nibName:"CountriesViewController", bundle:nil)
        self.language = language; languageManager = LanguageManager.init(language: language);
        self.delegate = delegate
        self.isCountryCodeHidden = isCountryCodeHidden
    }
    
    // This extends the superclass.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    @available (*,unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @available (*,unavailable)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultArray = []
        countriesDataSourceArray = CountriesDataSource.getCountries(language: language)
        searchResultArray = CountriesDataSource.getCountries(language: language)
        
        self.setupViews()
        
    }
    
    @available (*,unavailable)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addObservers()
    }
    
    @available (*,unavailable)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.removeObservers()
        
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: SetupViews
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func setupViews(){
        
        if inheritApplicationStyle {
            
            let navigationBarAppearace = UINavigationBar.appearance()
            self.navigationController?.navigationBar.tintColor = navigationBarAppearace.tintColor
            self.navigationController?.navigationBar.isTranslucent = navigationBarAppearace.isTranslucent
            self.navigationController?.navigationBar.shadowImage = navigationBarAppearace.shadowImage
            self.navigationController?.navigationBar.backgroundColor = navigationBarAppearace.backgroundColor
            self.navigationController?.navigationBar.barStyle = navigationBarAppearace.barStyle
            self.navigationController?.navigationBar.barTintColor = navigationBarAppearace.barTintColor
            
            // SB: Remove back arrow indicator image
            self.navigationController?.navigationBar.backIndicatorImage = navigationBarAppearace.backIndicatorImage
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = navigationBarAppearace.backIndicatorTransitionMaskImage
            
        }else {
            
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = .white
            
            // status bar colors
            self.navigationController?.navigationBar.barStyle = UIBarStyle.default
            
        }
        
        // set title
        self.navigationItem.title = languageManager.title
        
        // set search config
        self.searchTextField.placeholder = languageManager.search
        self.searchTextField.textAlignment = .center
        
        
        // setup Back Buton
        let cancelBarButtonItem = UIBarButtonItem(title: languageManager.cancel, style: .plain, target: self, action: #selector(dismissPresentedView))
        cancelBarButtonItem.tintColor = .black
        
        if (language == .arabic || UIView.appearance().semanticContentAttribute == .forceRightToLeft){
            self.navigationItem.rightBarButtonItem = cancelBarButtonItem
        }else {
            self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        }
        
        // tableview related
        self.tableView.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: countryCellIdentifier)
        self.tableView.semanticContentAttribute = self.language == .arabic ? .forceRightToLeft : .forceLeftToRight
        
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
        
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Keyboard Helping
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func addObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(searchTextFieldDidChange), name: UITextField.textDidChangeNotification, object: self.searchTextField)
        
        //* add notification for keyboard when note is active
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    private func removeObservers(){
        
        NotificationCenter.default.removeObserver(self)

    }
    
    @objc private func keyboardWillHide(sender: NSNotification) {
        
        if let dic = sender.userInfo, let duration = (dic[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
            self.tableViewBottomConstraint.constant = 0
            UIView.animate(withDuration: duration + 0.25, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveLinear, animations: { () -> Void in
                
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    @objc private func keyboardWillShow(sender:NSNotification){
        
        if let dic = sender.userInfo {
            if let keyboardFrame = (dic[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
                if let duration = (dic[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
                    
                    self.tableViewBottomConstraint.constant = +keyboardFrame.height
                    
                    UIView.animate(withDuration: duration + 0.25, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveLinear, animations: { () -> Void in
                        self.view.layoutIfNeeded()
                        
                    }, completion: nil)
                }
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK:- Actions
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @objc private func searchTextFieldDidChange(_ textfield:UITextField) {
        
        self.filterCountriesArrayAndUpdateTable()
        
    }
    
    private func filterCountriesArrayAndUpdateTable() {
        
        if (self.searchTextField.text?.count == 0) {
            
            self.countriesDataSourceArray = CountriesDataSource.getCountries(language: language)
            
            self.tableView.reloadData()
            
        }else{
            
            self.countriesDataSourceArray = searchResultArray?.filter({ (country) -> Bool in
                country.nameEn!.lowercased().contains(self.searchTextField.text!.lowercased()) || country.nameAr!.contains(self.searchTextField.text!) || country.countryInternationlKey!.contains(self.searchTextField.text!)
            })
            
            self.tableView.reloadData()
        }
        
    }
    
    @objc private func dismissPresentedView(){
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    
}

extension CountriesViewController:UITableViewDataSource,UITableViewDelegate  {
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: - UITableView Datasource
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.countriesDataSourceArray?.count)!
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: countryCellIdentifier) as? CountryCell else {return UITableViewCell()}
        
        cell.selectionStyle = .none
        
        let object = countriesDataSourceArray?[indexPath.row]
        
        cell.populateCell(object: object, isCountryCodeHidden: isCountryCodeHidden,language: language)
        
        return cell
        
    }
    
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let headerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100))
        headerView.contentView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        
        return headerView
        
    }
    
    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return languageManager.allCountries
        
    }
    
    internal func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = UIColor(red: 174/255, green: 174/255, blue: 174/255, alpha: 1.0)
        header.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        if (language == .arabic || UIView.appearance().semanticContentAttribute == .forceRightToLeft){
            header.textLabel?.textAlignment = .right
        }
        
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: - UITableView Delegate
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)

        guard let delegate = self.delegate else {return}
        if let country = countriesDataSourceArray?[indexPath.row] {
            delegate.didSelectCountry(country: country)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedHeightForCountryCell
    }
    
}
