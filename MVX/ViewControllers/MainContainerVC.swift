//
//  ViewController.swift
//  MVX
//
//  Created by Rupali Patil on 12/10/20.
//  Copyright © 2020 Rupali Patil. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift


var g_cMainContainerVC: MainContainerVC!


class MainContainerVC: UIViewController
{
    @IBOutlet weak var m_cClosebtn: UIButton!
    
    @IBOutlet weak var m_cForgotPwdSubView: Cardview!
    @IBOutlet weak var m_cForgotPwdView: UIView!
    @IBOutlet weak var m_cForgotEmailsubmitbtn: UIButton!
    @IBOutlet weak var m_cForgotEmailtxt: UITextField!
    @IBOutlet weak var m_cCloseEmailbtn: UIButton!
    
    @IBOutlet weak var m_cBgOTPView: UIView!
    
    @IBOutlet weak var m_cOTPtxt: UITextField!
    
    @IBOutlet weak var m_cContainerView: UIView!
    
    @IBOutlet weak var m_cOTPView: Cardview!
    
    @IBOutlet weak var m_cSignupbtn: UIButton!
    @IBOutlet weak var m_cLoginbtn: UIButton!
    @IBOutlet weak var m_cBottomViewLogin: NSLayoutConstraint!
    @IBOutlet weak var m_cSignupLeading: NSLayoutConstraint!
    @IBOutlet weak var m_cLoginbtnLeading: NSLayoutConstraint!
    
    
    
    var m_cLoginVC : LoginVC!
    var m_cSingupVC: SignupVC!
    var m_cHomeVC: HomeScreenVC!
    var m_cForgotVC: ForgotVC!
    
    var m_cUserInfo: UserInfo!
    var m_cForgotOTP: Bool!
    var m_cuserType: String!
   
    @IBAction func onClosebtn_Click(_ sender: Any) {
        m_cBgOTPView.isHidden = true
    }
    
    @IBAction func onForgotPwdClosebnt_Click(_ sender: Any) {
        self.m_cForgotPwdView.isHidden = true
    }
    
    @IBAction func onForgotEmailSubmitbtn_Click(_ sender: Any)
    {
     
        if self.ValidEmailCheck()
        {
            
              ResendOTP(bResendOtp: false)
        }
      
    }
    
    func ValidEmailCheck() -> Bool
    {
        if m_cForgotEmailtxt.text == ""
        {
            self.view.makeToast("Please Enter Email ID")
            return false
        }
        
        if (!(m_cForgotEmailtxt.text?.isValidEmail())!)
        {
            self.view.makeToast("Please Enter Correct Email")
           return false
        }
       return true
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BG")!)
        
        g_cMainContainerVC = self
        
        self.m_cForgotEmailtxt.setupView()
        self.m_cOTPtxt.setupView()
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
          OpenVC(cViewController: self.m_cLoginVC, bStatus: false)
        m_cForgotEmailtxt.setLeftPaddingPoints(10)
        m_cOTPtxt.setLeftPaddingPoints(10)
        self.m_cBgOTPView.isHidden = true
        self.m_cForgotPwdView.isHidden = true
        
        m_cClosebtn.Designbtn()
        m_cCloseEmailbtn.DesignCornerbtn()
       
       
    }
    
    override func awakeFromNib() {
        self.m_cLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.m_cSingupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as? SignupVC
        
        self.m_cHomeVC = storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as? HomeScreenVC
        self.m_cForgotVC = storyboard?.instantiateViewController(withIdentifier: "ForgotVC") as? ForgotVC
       }
        
    func ShowForgotPwdView()
    {
        self.m_cForgotPwdView.isHidden = false
    }
    func ShowOTPView()
    {
        
        self.m_cBgOTPView.isHidden = false
    }
    
    func ShowHomeVC()
    {
        OpenVC(cViewController: self.m_cHomeVC, bStatus: true)
    
    }
    
    func OpenVC(cViewController: UIViewController, bStatus: Bool)
    {
        
        cViewController.view.clipsToBounds = true
        
        if !bStatus
        {
            cViewController.view.frame = self.m_cContainerView.bounds
            self.m_cContainerView.addSubview(cViewController.view)
            
        }else{
         
            self.present(self.m_cHomeVC, animated: true)
        }
        
        self.m_cLoginVC.didMove(toParent: self)
    }
    
    func SetupLoginVC()
    {
      //self.m_cLoginbtnLeading.constant
        OpenVC(cViewController: self.m_cLoginVC, bStatus: true)
       
    }

    @IBAction func onLogin_Click(_ sender: Any) {
        self.m_cLoginbtn.setImage(UIImage(named: "Log in"), for: .normal)
        self.m_cSignupbtn.setImage(UIImage(named: "Sign up-2"), for: .normal)
        self.m_cBottomViewLogin.constant = 0
        OpenVC(cViewController: self.m_cLoginVC, bStatus: false)
        self.m_cSingupVC.view.removeFromSuperview()
       
    }
    
    
    
    @IBAction func onSignup_Click(_ sender: Any) {
        self.m_cSignupbtn.setImage(UIImage(named: "Sign up"), for: .normal)
        self.m_cSignupbtn.layoutIfNeeded()
        
        self.m_cLoginbtn.setImage(UIImage(named: "Log in-2"), for: .normal)
        self.m_cBottomViewLogin.constant = 80
        OpenVC(cViewController: self.m_cSingupVC, bStatus: false)

       self.m_cLoginVC.view.removeFromSuperview()
        
    }
    
    
    @IBAction func onResend_Click(_ sender: Any) {
        self.m_cForgotOTP = true
        self.ResendOTP(bResendOtp: true)
    }
    
    func ResendOTP(bResendOtp: Bool)
    {
       
        var lcURL: String!
        
        if bResendOtp
        {
            //if self.m_cForgotOTP
            //{
                self.m_cUserInfo = m_cCommanData.getData()
                lcURL = ApiConstant.BaseUrl + ApiConstant.ResendOTP + "91\(m_cUserInfo.mobile!)"
           /* }else{
                self.m_cUserInfo = m_cCommanData.getData()
                lcURL = ApiConstant.BaseUrl + ApiConstant.ResendOTP + "\(m_cForgotEmailtxt.text!)"
            }*/
            
        }else{
            lcURL = ApiConstant.BaseUrl + ApiConstant.forgotPwdOtp + "\(m_cForgotEmailtxt.text!)"
        }
        
       
        
        
        self.view.makeToastActivity(.center)
        
        Alamofire.request(lcURL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (resp) in
             print(resp)
            
            switch resp.result
            {
            case .success(_):
                let dict = resp.result.value as! NSDictionary
             
                if bResendOtp
                {
                    let lcMessage = dict["message"] as! String
                    if self.m_cForgotOTP
                    {
                        if lcMessage == "OTP re-sent successfully."
                        {
                            self.view.makeToast(lcMessage, duration: 3.0, position: .center)
                            
                        }else{
                            self.view.makeToast(lcMessage, duration: 3.0, position: .center)
                        }
                    }else{
                        if lcMessage == "OTP re-sent successfully."
                        {
                            let lcEmail = self.m_cUserInfo.email
                            let id = self.m_cUserInfo.id
                            let mobile = self.m_cUserInfo.mobile
                            
                            if lcEmail != ""
                            {
                                self.m_cForgotVC.setUpData(cEmail: lcEmail!,id: id!, mobile: mobile!)
                                self.m_cForgotVC.view.frame = self.view.bounds
                                self.view.addSubview(self.m_cForgotVC.view)
                                
                                
                                self.m_cForgotVC.view.clipsToBounds = true
                            }
                            
                        }else{
                            self.view.makeToast(lcMessage, duration: 3.0, position: .center)
                        }
                    }
                }else{
                    let lcMessage = dict["message"] as! String
                    
                    if lcMessage == "Couldn't resend otp because of missing or invalid mobile number."
                    {
                        self.view.makeToast(lcMessage, duration: 3.0, position: .center)
                    }else{
                        self.view.makeToast(lcMessage, duration: 3.0, position: .center)
                    if let userdata = dict["user"] as? NSDictionary {
                        UserDefaults.standard.set(userdata, forKey: "userData")
                        
                    
                        let lcEmail = userdata["email"] as! String
                        let id = userdata["id"] as! String
                        let mobile = userdata["mobile"] as! Int64
                        
                        if lcEmail != ""
                        {
                            self.m_cForgotVC.setUpData(cEmail: lcEmail,id: id, mobile: mobile)
                            self.m_cForgotVC.view.frame = self.view.bounds
                            self.view.addSubview(self.m_cForgotVC.view)
                            
                            
                            self.m_cForgotVC.view.clipsToBounds = true
                        }
                      
                      
                    }
                  }
                }
               
                break
                
            case .failure(_):
                self.view.makeToast("The Internet connection appears to be offline", duration: 3.0, position: .center)
                break
            }
            
            self.view.hideToastActivity()
        }
        
    }
    
    @IBAction func onSumit_Click(_ sender: Any) {
        self.SendOTP()
    }
    
   
    func GetDict()-> [String: Any]
    {
        let lcDict = [
            "id" : self.m_cUserInfo.id!,//"127-agfg-fsgfhs-fgsh",
            "name" : self.m_cUserInfo.name!,
            "email" : self.m_cUserInfo.email!]
        
        return lcDict as [String : Any]
    }
    
    func SendOTP()
    {
       
        self.m_cUserInfo = m_cCommanData.getData()
        let loginApi = ApiConstant.BaseUrl + ApiConstant.otp
        let mobile = "91\(String(self.m_cUserInfo.mobile!))"
        let param = ["mobile" : mobile as Any,
                     "otp" : self.m_cOTPtxt.text! as Any,
                     "user": self.GetDict() as Any,
                     "userType": self.m_cuserType as Any
                     ]
        
        print(param)
        
        self.view.makeToastActivity(.center)
        
        Alamofire.request(loginApi, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (resp) in
             print(resp)
            
            switch resp.result
            {
            case .success(_):
                let dict = resp.result.value as! NSDictionary
             
                let lcMessage = dict["message"] as! String
                
                if lcMessage == "You are logged in successfully."
                {
                    self.ShowHomeVC()
                    
                }else{
                    self.view.makeToast(lcMessage, duration: 3.0, position: .center)
                }
                
                break
                
            case .failure(_):
                self.view.makeToast("The Internet connection appears to be offline", duration: 3.0, position: .center)
                break
            }
            
            self.view.hideToastActivity()
        }
        
    }
    
    func ShowToastProgress()
    {
        self.view.makeToastActivity(.center)
    }
    func HideToastProgress()
    {
        self.view.hideToastActivity()
    }
    
    
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            return .portrait
        }
    }

    
    @IBAction func OnResentForgetPwdOTP_Click(_ sender: Any) {
        if ValidEmailCheck()
        {
            self.m_cForgotOTP = false
            ResendOTP(bResendOtp: true)
        }
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIButton
{
    func Designbtn()
    {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    func DesignCornerbtn()
    {
        self.layer.cornerRadius = 18
        self.clipsToBounds = true
    }
   
}

extension UITextField
{
    func setupView()
    {
        self.layer.borderWidth = 0.1
        self.layer.cornerRadius = 4.0
        self.layer.borderColor =  UIColor(named: "#696969")?.cgColor
    }
}
