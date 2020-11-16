//
//  ForgotVC.swift
//  MVX
//
//  Created by Rupali Patil on 17/10/20.
//  Copyright © 2020 Rupali Patil. All rights reserved.
//

import UIKit
import Alamofire

class ForgotVC: UIViewController
{
    @IBOutlet weak var m_cClosebtn: UIButton!
    @IBOutlet weak var m_cEmailAddrss: UITextField!
    @IBOutlet weak var m_cConfirmPwd: UITextField!
    @IBOutlet weak var m_cPassword: UITextField!
    @IBOutlet weak var m_cOTP: UITextField!
    @IBOutlet weak var m_cBgCardView: Cardview!
    
    var m_cEmail: String!
    var m_cMobile: Int64!
    var m_cID: String!
    
    @IBOutlet weak var m_cSubmitbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.m_cEmailAddrss.isUserInteractionEnabled = false
        self.m_cClosebtn.Designbtn()
        self.m_cSubmitbtn.DesignCornerbtn()
        self.m_cEmailAddrss.text = self.m_cEmail
        self.m_cBgCardView.backgroundColor = UIColor(patternImage: UIImage(named: "BG")!)
        // Do any additional setup after loading the view.
    }
    @IBAction func onClosebtn_Click(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    func setUpData(cEmail: String,id: String, mobile: Int64)
    {
        self.m_cMobile = mobile
        self.m_cEmail = cEmail
        self.m_cID = id
    }
    
    
    @IBAction func onSubmitbtn_Click(_ sender: Any) {
      
        if m_cOTP.text == ""
        {
            self.view.makeToast("Please Enter OTP")
            return
        }
        
        if m_cPassword.text == ""
        {
            self.view.makeToast("Please Enter Your Password")
            return
        }
        
        if m_cConfirmPwd.text == ""
        {
            self.view.makeToast("Please Enter Confirm Password")
            return
        }
        
        if self.m_cPassword.text != self.m_cConfirmPwd.text
        {
            self.view.makeToast("Please doesn't match")
            return
        }
        
        self.SendForgetPwd()
    }
    
    func SendForgetPwd()
    {
        let loginApi = ApiConstant.BaseUrl + ApiConstant.resetForgotPwd
        
        
        
        let param = ["email" : self.m_cEmail!,
                     "password" : self.m_cPassword.text as Any,
                     "confirmPassword": self.m_cConfirmPwd.text as Any,
                     "mobile": self.m_cMobile as Any,
                     "otp": self.m_cOTP.text!,
                     "id": "64d2ae70-e7e4-11ea-939c-2bb922b6e598" as Any,
                    
        ] as [String : Any]
        
        
        g_cMainContainerVC.ShowToastProgress()
       
        
        Alamofire.request(loginApi, method: .put, parameters: param, encoding: JSONEncoding.default).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let dict = resp.result.value as! NSDictionary
                
                let status = dict["message"] as! String
                
                if status == "Your password has been updated successfully"
                {
                    self.view.makeToast(status, duration: 3.0, position: .center)
                    g_cMainContainerVC.onLogin_Click(self.m_cSubmitbtn)
                    g_cMainContainerVC.m_cForgotPwdView.isHidden = true
                    self.m_cOTP.text = ""
                    self.m_cPassword.text = ""
                    self.m_cConfirmPwd.text = ""
                    self.view.removeFromSuperview()
                }else{
                    self.view.makeToast(status, duration: 3.0, position: .center)
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
    
    @IBAction func onLoginbtn_Click(_ sender: Any) {
        
        g_cMainContainerVC.onLogin_Click(sender)
        g_cMainContainerVC.m_cForgotPwdView.isHidden = true
        self.view.removeFromSuperview()
    }
    
    @IBAction func onRegisterbtn_Click(_ sender: Any) {
        g_cMainContainerVC.onSignup_Click(sender)
        g_cMainContainerVC.m_cForgotPwdView.isHidden = true
        self.view.removeFromSuperview()
    }
    

}
