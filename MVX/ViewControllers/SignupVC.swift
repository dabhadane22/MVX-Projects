//
//  SignupVC.swift
//  MVX
//
//  Created by Rupali Patil on 12/10/20.
//  Copyright © 2020 Rupali Patil. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import DropDown

class SignupVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var m_cYearlbl: UILabel!
    
    @IBOutlet weak var m_cOTPView: UIView!
    @IBOutlet weak var m_cAddresslbl: UILabel!
    @IBOutlet weak var m_cMobiletxt: UITextField!
    @IBOutlet weak var m_cAgetxt: UITextField!
    @IBOutlet weak var m_cDaylbl: UILabel!
    
    @IBOutlet weak var m_cMonthlbl: UILabel!
    
    @IBOutlet weak var m_cAgebtn: UIButton!
    
    @IBOutlet weak var m_cEntryTypebtn: UIButton!
    
    @IBOutlet weak var m_cAddresstxtView: UITextView!
    
    @IBOutlet weak var m_cPasswordtxt: UITextField!
    @IBOutlet weak var m_cUserNametxt: UITextField!
    
    @IBOutlet weak var m_cEmailtxt: UITextField!
    
    @IBOutlet weak var m_cNumbertxt: UITextField!
    
    @IBOutlet weak var m_cAddressView: UIView!
    @IBOutlet weak var m_cNameView      : UIView!
    @IBOutlet weak var m_cEmailIDView: UIView!
    @IBOutlet weak var m_cUserNameView: UIView!
    @IBOutlet weak var m_cEntryTypeView: UIView!
    @IBOutlet weak var m_cAgedView: UIView!
    @IBOutlet weak var m_cPasswordView: UIView!
    @IBOutlet weak var m_cBirdayView: UIView!
    
    
    @IBOutlet weak var m_cOTPtxt: UITextField!
    
    var m_cEntryType = DropDown()
    var m_cEntryTypeStr = String()
    @IBAction func OnResentbtn_Click(_ sender: Any) {
    }
    
    @IBAction func OnSubmitbtn_Click(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.m_cAddresstxtView.delegate = self
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        // Do any additional setup after loading the view.
        
        m_cEntryType.anchorView = m_cEntryTypeView
        m_cEntryType.direction = .top
        m_cEntryType.bottomOffset = CGPoint(x: 0, y:(m_cEntryType.anchorView?.plainView.bounds.height)!)
        self.m_cMobiletxt.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupView(cView: m_cNameView)
        self.setupView(cView: m_cEmailIDView)
        self.setupView(cView: m_cUserNameView)
        self.setupView(cView: m_cEntryTypeView)
        self.setupView(cView: m_cAgedView)
        self.setupView(cView: m_cPasswordView)
        self.setupView(cView: m_cBirdayView)
        self.setupView(cView: m_cAddressView)
        self.m_cAddresslbl.isHidden = false
    }
    
   
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        self.m_cAddresslbl.isHidden = true
//        return true
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let rangeOfTextToReplace = Range(range, in: textView.text) else {
            return false
        }
        let substringToReplace = textView.text[rangeOfTextToReplace]
        let count = textView.text.count - substringToReplace.count + text.count
        
        
        if count == 0
        {
            self.m_cAddresslbl.isHidden = false
        }else{
            self.m_cAddresslbl.isHidden = true
        }
        
        return true
        
    }
    
    func setupView(cView: UIView)
    {
        cView.layer.borderWidth = 0.1
        cView.layer.cornerRadius = 4.0
        cView.layer.borderColor =  UIColor(named: "#696969")?.cgColor
    }
    
    
    @IBAction func onSignupbtn_Click(_ sender: Any) {
       
        if Validation()
        {
            self.SendSingup()
        }
    }
    
    @IBAction func OnAgebtn_Click(_ sender: Any) {
    }
    
    @IBAction func onEntryTypeClcin(_ sender: Any) {
        
        self.m_cEntryType.dataSource =  ["Buyer","Builder","Investor","Broker","Owner"]
        self.m_cEntryType.show()
        
        m_cEntryType.selectionAction = { [unowned self] (index: Int, item: String) in
            self.m_cEntryTypeStr = item
            self.m_cEntryTypebtn.setTitle(item, for: .normal)
        }
        
    }
    
    func SendSingup()
    {
        let loginApi = ApiConstant.BaseUrl + ApiConstant.register
        let param = ["email" : self.m_cEmailtxt.text!,
                     "password" : self.m_cPasswordtxt.text!,
                     "name": self.m_cNumbertxt.text!,
                     "mobile": Int(self.m_cMobiletxt.text!),
                     "age": Int(self.m_cAgetxt.text!),
                     "address": self.m_cAddresstxtView.text!,
                     "entryType": self.m_cEntryTypeStr,
                     "city": "",
                     "state": ""
        ] as [String : Any]
        
      
        g_cMainContainerVC.ShowToastProgress()
       // self.view.makeToastActivity(.center)
        
        Alamofire.request(loginApi, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let dict = resp.result.value as! NSDictionary
                
                let status = dict["message"] as! String
                
                if status == "Sucessfully registered user with email \(self.m_cEmailtxt.text!)"
                {
                    if let userdata = dict["data"] as? NSDictionary {
                        UserDefaults.standard.set(userdata, forKey: "userData")
                        
                        let lcUserInfo = UserInfo(id: userdata["id"] as! String, name: userdata["name"] as! String, email: userdata["email"] as! String, password: userdata["password"] as! String, mobile: userdata["mobile"] as! Int64, isMobileVerified: userdata["isMobileVerified"] as! Bool, isEmailVerified: userdata["isEmailVerified"] as! Bool, entryType: userdata["entryType"] as! String, age: userdata["age"] as! Int, address: userdata["address"] as! String)
                        
                        m_cCommanData.setData(cUserInfo: lcUserInfo)
                      
                    }
                    
                    g_cMainContainerVC.m_cuserType = "manual"
                    g_cMainContainerVC.ShowOTPView()
                    self.view.makeToast(status, duration: 3.0, position: .center)
                }
                else
                {
                    if let errmsg = dict["data"] as? NSDictionary {
                        let msg = errmsg["message"] as? String
                        self.view.makeToast(msg, duration: 3.0, position: .center)
                    }
                }
                
                break
                
            case .failure(_):
                self.view.makeToast("The Internet connection appears to be offline", duration: 3.0, position: .center)
                break
            }
            
           // self.view.hideToastActivity()
            g_cMainContainerVC.HideToastProgress()
        }
        
    }
    
    
    func Validation() -> Bool
    {
        if m_cNumbertxt.text == ""
        {
            self.view.makeToast("Please Enter Your Name")
            return false
        }
        
       
        
        if m_cEmailtxt.text == ""
        {
            self.view.makeToast("Please Enter Your Email")
            return false
        }
        if m_cUserNametxt.text == ""
        {
            self.view.makeToast("Please Enter Your User Name")
            return false
        }
        
        if m_cPasswordtxt.text == ""
        {
            self.view.makeToast("Please Enter Your Password")
            return false
        }
        
        if m_cAddresstxtView.text == ""
        {
            self.view.makeToast("Please Enter Your Address")
            return false
        }
        
        if m_cAgetxt.text == ""
        {
            self.view.makeToast("Please Enter Your Age")
            return false
        }
        
        if m_cMobiletxt.text == ""
        {
            self.view.makeToast("Please Enter Your Mobile")
            return false
        }
        
        
        if (!(m_cEmailtxt.text?.isValidEmail())!)
        {
            self.view.makeToast("Please Enter Correct Email")
            return false
        }
        let lbIsPhoneNumber = m_cMobiletxt.text?.isPhoneNumber
               
        if (!lbIsPhoneNumber!)
        {
            self.view.makeToast("Please Enter Correct Number")
            return false
        }
        
        return true
    }
   
}

extension SignupVC: UITextFieldDelegate {

    // Remove error message after start editing
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == m_cMobiletxt
        {
            guard let text = m_cMobiletxt.text else { return true }
            let newLength = text.count + string.count - range.length
            
            return newLength <= 10
        }
        
        return true

    }

   
   
}
