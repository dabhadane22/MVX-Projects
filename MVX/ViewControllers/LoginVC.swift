//
//  LoginVC.swift
//  MVX
//
//  Created by Rupali Patil on 12/10/20.
//  Copyright © 2020 Rupali Patil. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import FacebookCore
import FacebookLogin
import GoogleSignIn
import JWTDecode


class LoginVC: UIViewController,GIDSignInDelegate {

    @IBOutlet weak var PopupClosebtn: UIButton!
    @IBOutlet weak var m_cPasswordtxt: UITextField!
    
    @IBOutlet weak var m_cMobileVerifyView: UIView!
    @IBOutlet weak var m_cEmailtxt: UITextField!
    
    @IBOutlet weak var m_cPasswordView: UIView!
   // @IBOutlet weak var m_cEmailView: UIView!
    @IBOutlet weak var m_cAccountInfolbl: UILabel!
    
    @IBOutlet weak var m_cGooglelbl: UILabel!
    @IBOutlet weak var m_cGoogleView: UIView!
    @IBOutlet weak var m_cDontHaveAccountlbl: UILabel!
    @IBOutlet weak var m_cfacebooklbl: UILabel!
    @IBOutlet weak var m_cFacebookView: UIView!
    @IBOutlet weak var m_cORlbl: UILabel!
    @IBOutlet weak var m_cLeftSeprator: UIView!
    @IBOutlet weak var m_cRightSeprator: UIView!
    @IBOutlet weak var m_cForgetPwd: UIButton!
    @IBOutlet weak var m_cAccountlbl: UILabel!
    
    @IBOutlet weak var Submitbtn: UIButton!
    @IBOutlet weak var Resendbtn: UIButton!
    var m_cHomeScreen : HomeScreenVC!
    
    @IBOutlet weak var m_cEmailView: UIView!
    
    let appdel = UIApplication.shared.delegate as! AppDelegate
    var fcmToken = String()
    
    var m_cSocialID: String!
    var m_cDict: NSDictionary!
    
    @IBOutlet weak var m_cMobiletxt: UITextField!
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("The user has not signed in before or they have since signed out.")
        } else {
          print("\(error.localizedDescription)")
        }
        return
      }
      // Perform any operations on signed in user here.
      
        
        
        let idToken = user.authentication.idToken
//      let userId = user.userID                  // For client-side use only!
//       // Safe to send to the server
//      let fullName = user.profile.name
//      let givenName = user.profile.givenName
//      let familyName = user.profile.familyName
//      let email = user.profile.email
        
        if idToken != nil
        {
            let lcDict = ["id": user.userID, "email": user.profile.email, "first_name": user.profile.name] as [String: AnyObject]
            self.m_cSocialID = user.userID
            self.ConfirmMobileNo(lcDict: lcDict)
           // g_cMainContainerVC.ShowHomeVC()
        }
      // ...
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
    
    @IBAction func OnSubmitbtn_Click(_ sender: Any) {
        self.ResendOTP(bResendOtp: false)
    }
    
    @IBAction func onResentbtn_Click(_ sender: Any) {
        self.m_cMobileVerifyView.isHidden = true
    }
    
    @IBAction func PopupClosebtn_Click(_ sender: Any) {
        
        self.m_cMobileVerifyView.isHidden = true
    }
    
    func ResendOTP(bResendOtp: Bool)
    {
         let lcURL = ApiConstant.BaseUrl + ApiConstant.VeriyAuthtication + "/\(self.m_cSocialID!)"
        
       
        self.view.makeToastActivity(.center)
        let lcParam = ["mobile" : Int64(self.m_cMobiletxt.text!)!] as [String: Any]
        
        Alamofire.request(lcURL, method: .put, parameters: lcParam, encoding: JSONEncoding.default).responseJSON { (resp) in
             print(resp)
            
            switch resp.result
            {
            case .success(_):
                
                let dict = resp.result.value as! NSDictionary
                let lcMessage = dict["message"] as! String
                if lcMessage == "Your mobile has been updated successfully, please verify it using sent otp."
                {
                   let name = "\(self.m_cDict!["firstName"]!) \(self.m_cDict!["lastName"]!)"
                    
                    let lcProfileData = UserInfo(id: self.m_cDict["id"] as! String, name: name , email: self.m_cDict["email"] as! String, password: "" , mobile: Int64(self.m_cMobiletxt.text!)!, isMobileVerified: self.m_cDict["isMobileVerified"] as! Bool, isEmailVerified: false, entryType: "Buyer" , age: 0, address: "")
                    
                     m_cCommanData.setData(cUserInfo: lcProfileData)
                    self.m_cMobileVerifyView.isHidden = true
                    g_cMainContainerVC.m_cuserType = "social"
                    g_cMainContainerVC.m_cBgOTPView.isHidden = false
                    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        self.m_cMobiletxt.setupView()
        self.m_cMobiletxt.setLeftPaddingPoints(10)
       // self.Submitbtn.DesignCornerbtn()
        //self.Resendbtn.DesignCornerbtn()
        self.PopupClosebtn.Designbtn()
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        fcmToken = appdel.instanceToken ?? ""
        print(fcmToken)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.m_cMobileVerifyView.isHidden = true
        OrientationManager.landscapeSupported = true
         let value = UIInterfaceOrientation.portrait.rawValue
                
         UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func awakeFromNib() {
        self.m_cHomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
    }
    
    @IBAction func onGooglebtn_Click(_ sender: Any) {
        self.m_cMobiletxt.text = ""
        GIDSignIn.sharedInstance()?.presentingViewController = self

          // Automatically sign in the user.
        //  GIDSignIn.sharedInstance()?.restorePreviousSignIn()

          // ...
        
        GIDSignIn.sharedInstance()?.signIn()
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    @IBAction func onFbbtn_Click(_ sender: Any) {
        self.m_cMobiletxt.text = ""
        LoginManager.init().logIn(permissions: [.publicProfile,.email], viewController: self) { (result) in
          switch result {
          case .success(let granted, let declined, let token):
              print("granted: \(granted), declined: \(declined), token: \(token)")
            self.getFacebookData()
          case .cancelled:
              print("Login: cancelled.")
          case .failed(let error):
            print("Login with error: \(error.localizedDescription)")
          }
        }
    }
    
    func getFacebookData()
    {
        // Make sure the permissions of these fields are all granted; Else Facebook would not return these to app
        
        if AccessToken.current != nil
        {
            let requestedFields = "id,email, first_name, last_name"
            GraphRequest.init(graphPath: "me", parameters: ["fields":requestedFields]).start { (connection, result, error) -> Void in
                let lcDict = result as! [String: AnyObject]
                print(lcDict)
                
                self.ConfirmMobileNo(lcDict: lcDict)
            }
        }
       
    }
    
    func ConfirmMobileNo(lcDict: [String: AnyObject])
    {
        //let lcId = lcDict["id"]!
        let lcPararm = [String: [String: AnyObject]]()
        
        let lcFinalParam = ["userDetailsObject" : lcPararm as AnyObject,
                            "email": lcDict["email"] as AnyObject,
                            "name" : lcDict["first_name"] as AnyObject,
                    "provider" : "facebook" as AnyObject,
                    "firstName": lcDict["first_name"] as AnyObject,
                    "lastName": lcDict["last_name"] as AnyObject,
        ]
        
        let ConfirmMobielNoApi = ApiConstant.BaseUrl + ApiConstant.loginSocial
        
        g_cMainContainerVC.ShowToastProgress()
     
        
        Alamofire.request(ConfirmMobielNoApi, method: .post, parameters: lcFinalParam, encoding: JSONEncoding.default).responseJSON { (resp) in
             print(resp)
            
            switch resp.result
            {
            case .success(_):
                let lcMainDict = resp.result.value as? NSDictionary
             
                self.m_cDict = lcMainDict!["data"] as! NSDictionary
                
                let isMobieVerified = self.m_cDict["isMobileVerified"] as! Int
               
                self.m_cSocialID = self.m_cDict["id"]! as? String
               
                if 0 == isMobieVerified
                {
                    
                    self.m_cMobileVerifyView.isHidden = false
               }
                else
                {
                   
                    g_cMainContainerVC.ShowHomeVC()
                }
              
                
                
                break
                
            case .failure(_):
                self.view.makeToast("The Internet connection appears to be offline", duration: 3.0, position: .center)
                break
            }
            g_cMainContainerVC.HideToastProgress()
           
        }
        
    }
    
    
    @IBAction func onSignupbtn_Click(_ sender: Any) {
        g_cMainContainerVC.onSignup_Click(sender)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        m_cGooglelbl.textColor = UIColor(named: "#696969")
       
         m_cfacebooklbl.textColor = UIColor(named: "#696969")
        m_cFacebookView.layer.borderColor =  UIColor(named: "#696969")?.cgColor
        m_cFacebookView.layer.cornerRadius = 4.0
        m_cGoogleView.layer.borderColor =  UIColor(named: "#696969")?.cgColor
        m_cGoogleView.layer.cornerRadius = 4.0
        m_cORlbl.textColor = UIColor(named: "#696969")
        self.m_cGoogleView.layer.borderWidth = 0.5
        self.m_cFacebookView.layer.borderWidth = 0.5
        self.m_cForgetPwd.titleLabel?.textColor  = UIColor(named: "#696969")
        m_cDontHaveAccountlbl.textColor = UIColor(named: "#696969")
        m_cAccountInfolbl.textColor = UIColor(named: "#696969")
        
        self.m_cEmailView.layer.borderWidth = 0.1
        self.m_cEmailView.layer.cornerRadius = 4.0
        self.m_cEmailView.layer.borderColor =  UIColor(named: "#696969")?.cgColor
        
        self.m_cPasswordView.layer.borderWidth = 0.1
        self.m_cPasswordView.layer.cornerRadius = 4.0
        self.m_cPasswordView.layer.borderColor =  UIColor(named: "#696969")?.cgColor
    }
    
    
    @IBAction func onLoginbtn_Click(_ sender: Any) {
        
       
        if Validation()
        {
            self.getLogin(cUserId: self.m_cEmailtxt.text, cPassword: self.m_cPasswordtxt.text)
        }
    }
    
    func getLogin(cUserId: String!, cPassword: String!)
    {
        let loginApi = ApiConstant.BaseUrl + ApiConstant.login
        let param = ["email" : self.m_cEmailtxt.text as Any,
                     "password" : self.m_cPasswordtxt.text as Any,

            ] as [String: Any]
       
    
        
        g_cMainContainerVC.ShowToastProgress()
        
        Alamofire.request(loginApi, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (resp) in
           //  print(resp)
            
            switch resp.result
            {
            case .success(_):
                let dict = resp.result.value as! NSDictionary
              //  print(dict)
                
               
                let status = dict["message"] as! String
                
                if status == "You are logged in successfully."
                {
                    let lcToken = dict["token"]
                    let jwt = try! decode(jwt: lcToken as! String)
                   // print(jwt)
                   
                    let Body = jwt.body
                    print(Body)
                    let lcDict = Body["data"] as! NSDictionary
                    
                    let lcEmail = lcDict["email"]
                    print(lcEmail)
                    
                    
                    let lcProfileData = UserInfo(id: lcDict["id"] as! String, name: lcDict["name"] as! String, email: lcDict["email"] as! String, password: lcDict["password"] as! String, mobile: lcDict["mobile"] as! Int64, isMobileVerified: lcDict["isMobileVerified"] as! Bool, isEmailVerified: lcDict["isEmailVerified"] as! Bool, entryType: lcDict["entryType"] as! String, age: lcDict["age"] as! Int, address: lcDict["address"] as! String)
                    
                    m_cCommanData.setData(cUserInfo: lcProfileData)
                    
                    g_cMainContainerVC.ShowHomeVC()
                
                }
                else
                {
                    self.view.makeToast(status, duration: 3.0, position: .center)
                }
                    
    
                
                break
                
            case .failure(_):
                self.view.makeToast("The Internet connection appears to be offline", duration: 3.0, position: .center)
                break
            }
            g_cMainContainerVC.HideToastProgress()
            //self.view.hideToastActivity()
        }
        
    }
    
    func Validation() -> Bool
    {
        if m_cEmailtxt.text == "" && m_cPasswordtxt.text == ""
        {
            self.view.makeToast("Both fields are mandatory")
            return false
        }
        
        if m_cEmailtxt.text == "" || m_cPasswordtxt.text == ""
        {
            self.view.makeToast("Both fields are mandatory")
            return false
        }
        
        if m_cEmailtxt.text == ""
        {
            self.view.makeToast("Please Enter Your Email")
            return false
        }
        if m_cPasswordtxt.text == ""
        {
            self.view.makeToast("Please Enter Your Password")
            return false
        }
        
        if (!(m_cEmailtxt.text?.isValidEmail())!)
        {
            self.view.makeToast("Please Enter Correct Email")
            return false
        }
        
       
        
        return true
    }
    
    @IBAction func onForgotPwdbtn_Click(_ sender: Any) {
        
        g_cMainContainerVC.ShowForgotPwdView()
    }
    
}


extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }

   
    
    func isValidContact() -> Bool
    {
        //        let phoneNumberRegex = "^[6-9]\\d{9}$"
        //        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        //        let isValidPhone = phoneTest.evaluate(with: self)
        //        return isValidPhone
        
        let phoneNumberRegex = "^(?:|0|[1-9]\\d*)(?:|0|[/]\\d*)(?:\\.\\d*)?$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        
        return phoneTest.evaluate(with: self)
        
    }
}

extension UITextField{
      @IBInspectable var placeHolderColor: UIColor? {
           get {
               return self.placeHolderColor
           }
           set {
               self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
           }
       }
}

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
//extension JWT {
//
//    func claim(name: String) -> Claim {
//          let value = self.body[name]
//          return Claim(value: value)
//      }
//}
