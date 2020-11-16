//
//  CommanDataStore.swift
//  ASKnGIVE App
//
//  Created by Nikita on 28/09/20.
//  Copyright © 2020 Glosys. All rights reserved.
//

import Foundation

class UserInfo: NSObject,Codable
{
    
    var id : String?
    var name : String?
    var email : String?
    var password : String?
    var mobile: Int64?
    var isMobileVerified: Bool?
    var isEmailVerified: Bool?
    var entryType: String?
    var Age: Int!
    var address: String
    
    init(id: String, name: String, email: String, password: String, mobile: Int64, isMobileVerified: Bool,isEmailVerified: Bool,entryType: String, age: Int, address: String)
    {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.mobile = mobile
        self.isMobileVerified = isMobileVerified
        self.isEmailVerified = isEmailVerified
        self.entryType = entryType
        self.Age = age
        self.address = address
    }
    
}

class CommanDataStore : NSObject
{
    var m_cUserInfo : UserInfo!

     let defaults = UserDefaults.standard


    override init()
    {
        
    }

    func setData(cUserInfo: UserInfo)
    {
        self.m_cUserInfo = cUserInfo

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cUserInfo) {

            defaults.set(encoded, forKey: "SavedPerson")
        }


    }

    func getData() -> UserInfo?
    {

        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserInfo.self, from: savedPerson) {
                //print(loadedPerson.name)
                return loadedPerson
            }
        }

        return m_cUserInfo
    }

    func storeCrdentials(cUserName: String!, cPassword: String!)
    {
        UserDefaults.standard.set(cUserName, forKey: "userId")  //Integer
        UserDefaults.standard.set(cPassword, forKey: "userPwd") //setObject
        UserDefaults.standard.synchronize()
    }

    func clearUserCreditials()
    {
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "userPwd")
//         if let appDomain = Bundle.main.bundleIdentifier {
//        UserDefaults.standard.removePersistentDomain(forName: appDomain)
//         }
    }
}
