//
//  CountryListViewController.swift
//
//
//  Created by Saad Basha on 5/17/17.
//  Copyright © 2017 Saad Basha. All rights reserved.
//

import UIKit

protocol CountryListViewDelegate {
    func didSelectCountry(country:Dictionary<String,Any>)
}

class CountryListViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var searchTextField : UITextField!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var tableViewBottomConstraint: NSLayoutConstraint!
    
    private var showNoCountryCode = false
    private var countriesDataSourceArray : [Dictionary<String,Any>]?
    private var searchResultArray : [Dictionary<String,Any>]?
    private var countriesReferenceArray : [Dictionary<String,Any>]?
    
    var delegate:CountryListViewDelegate?
    var isArabic = false
    
    var titleEN = "Select Country"
    var titleAR = "اختر الدولة"
    var cancelAR = "Cancel"
    var cancelEN = "إلغاء"
    var AllCountriesAR = "جميع الدول"
    var AllCountriesEN = "ALL COUNTRIES"
    var SearchAR = "البحث"
    var SearchEN = "Search"
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: - Life Cycle
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultArray = [Dictionary<String,Any>]()
        countriesReferenceArray = [Dictionary<String,Any>]()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
        
        // status bar colors
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        
        if (isArabic){
            self.navigationItem.title = titleAR
            self.searchTextField.placeholder = SearchAR
        }else {
            self.navigationItem.title = titleEN
            self.searchTextField.placeholder = SearchEN
        }
        
        self.searchTextField.textAlignment = .center
        
        // Back Buton
        let cancelBarButtonItem = UIBarButtonItem(title: isArabic ? cancelEN : cancelAR, style: .plain, target: self, action: #selector(dismissPresentedView))
        cancelBarButtonItem.tintColor = .black
        
        if (isArabic){
            self.navigationItem.rightBarButtonItem = cancelBarButtonItem
        }else {
            self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        }
        
        let dataSource = CountryListDataSource()
        countriesDataSourceArray = dataSource.countries()
        countriesReferenceArray = dataSource.countries()
        searchResultArray = dataSource.countries()
        
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(searchTextFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: self.searchTextField)
        
        
        //* add notification for keyboard when note is active
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        //* remove notification for keyboard when exiting screen
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
        
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CountryCell
        
        if(cell == nil) {
            cell = CountryCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        }
        
        if (self.showNoCountryCode == true){
            
        }else {
            
            if isArabic {
                
                //for arabic
                cell?.textLabel?.text = (countriesDataSourceArray![indexPath.row])[kCountryDefaults.kCountryCallingCode] as? String
                cell?.textLabel?.textColor = .gray
                
                
                
            }else {
                
                // for english
                cell?.detailTextLabel?.text = (countriesDataSourceArray![indexPath.row])[kCountryDefaults.kCountryCallingCode] as? String
                cell?.detailTextLabel?.textColor = .gray
                
            }
            
            
        }
        
        if isArabic {
            
            // for arabic
            cell?.detailTextLabel?.text = (countriesDataSourceArray![indexPath.row])[kCountryDefaults.kArabicCountryName] as? String
            cell?.detailTextLabel?.textColor = .black
            
        }else {
            
            // for english
            cell?.textLabel?.text = (countriesDataSourceArray![indexPath.row])[kCountryDefaults.kCountryName] as? String
            cell?.textLabel?.textColor = .black
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.sizeToFit()
        }
        
        
        return cell!;
        
    }
    
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let headerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100))
        headerView.contentView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        
        return headerView
        
    }
    
    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if isArabic {
            
            return AllCountriesAR
            
        }else {
            
            return AllCountriesEN
            
        }
        
        
    }
    
    internal func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = UIColor(red: 174/255, green: 174/255, blue: 174/255, alpha: 1.0)
        header.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        if isArabic {
            
            header.textLabel?.textAlignment = .right
            
        }
        
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: - UITableView Delegate methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if delegate != nil {
            
            self.view.endEditing(true)
            
            self.delegate?.didSelectCountry(country: countriesDataSourceArray![indexPath.row])
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Keyboard Helping Methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @objc private func keyboardWillHide(sender: NSNotification) {
        
        if let dic = sender.userInfo, let duration = (dic[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
            self.tableViewBottomConstraint.constant = 0
            UIView.animate(withDuration: duration + 0.25, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveLinear, animations: { () -> Void in
                
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    @objc private func keyboardWillShow(sender:NSNotification){
        
        
        if let dic = sender.userInfo {
            if let keyboardFrame = (dic[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
                if let duration = (dic[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
                    
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
        
        if (self.searchTextField.text?.characters.count == 0) {
            
            self.searchTextField.text = "";
            self.countriesDataSourceArray = countriesReferenceArray;
            
            self.tableView.reloadData()
            
        }else{
            
            
            let predicate = NSPredicate(format: "\(kCountryDefaults.kCountryName) CONTAINS[cd] %@ OR \(kCountryDefaults.kArabicCountryName) CONTAINS[cd] %@ OR \(kCountryDefaults.kCountryCallingCode) CONTAINS[cd] %@", self.searchTextField.text!,self.searchTextField.text!,self.searchTextField.text!)
            self.countriesDataSourceArray = (searchResultArray! as NSArray).filtered(using: predicate) as? [Dictionary<String, Any>]
            
            self.tableView.reloadData()
        }
        
    }
    
    @objc private func dismissPresentedView(){
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    
}
