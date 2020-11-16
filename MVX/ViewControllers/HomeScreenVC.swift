//
//  HomeScreenVC.swift
//  MVX
//
//  Created by Nikita on 14/10/20.
//  Copyright © 2020 Rupali Patil. All rights reserved.
//

import UIKit

class HomeScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BG-2")!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        OrientationManager.landscapeSupported = true
         let value = UIInterfaceOrientation.landscapeLeft.rawValue
                
         UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    @IBAction func btnSetting_onClick(_ sender: Any) {
        
        let settingvc = self.storyboard?.instantiateViewController(identifier: "SettingVC") as! SettingVC
        settingvc.complition = {
            g_cMainContainerVC.onLogin_Click(sender)
            g_cMainContainerVC.m_cBgOTPView.isHidden = true
            self.dismiss(animated: false, completion: nil)
            
        }
        
        self.present(settingvc, animated: false, completion: nil)
        
    }
    
    @IBAction func onEnterExpo_Click(_ sender: Any) {
        
    }
    
    @IBAction func onAboutus_Click(_ sender: Any) {
        let lcAboutusvc = self.storyboard?.instantiateViewController(identifier: "AboutUsVC") as! AboutUsVC
        self.present(lcAboutusvc, animated: true, completion: nil)
    }
    
    
}

