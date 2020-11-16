//
//  ApiConstant.swift
//  PolicyTracker
//
//  Created by Rupali Patil on 15/07/19.
//  Copyright © 2019 Nishikant Ashok UMBARKAR. All rights reserved.
//

import Foundation

class ApiConstant
{
   
    static let BaseUrl = "https://onm9k3etak.execute-api.ap-south-1.amazonaws.com/live/"
    
    
    static let login = "login"
    static let register = "users"
    static let logout = "logout"
    static let changePwd = "change-password"
    static let otp = "verifyOtp"
    static let ResendOTP = "retryOtp/"
    static let forgotPwdOtp = "forgotPwdOtp/"
    static let resetForgotPwd = "resetForgotPwd"
    static let VeriyAuthtication = "socialUser"
    static let loginSocial = "loginSocial"
    
}

