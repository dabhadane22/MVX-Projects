//
//  ProfileVC.swift
//  MVX
//
//  Created by Rupali Patil on 24/10/20.
//  Copyright © 2020 Rupali Patil. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var m_cClosebtn: UIButton!
    @IBOutlet weak var m_cNametxt: UITextField!
    @IBOutlet weak var m_cEmailtxt: UITextField!
    @IBOutlet weak var m_cAddresstxt: UITextView!
    @IBOutlet weak var m_cTypebtn: UIButton!
    @IBOutlet weak var m_cMobiletxt: UITextField!
    @IBOutlet weak var m_cAgetxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BG")!)
        // Do any additional setup after loading the view.
        self.m_cClosebtn.layer.cornerRadius = self.m_cClosebtn.frame.width / 2
        self.m_cClosebtn.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        OrientationManager.landscapeSupported = true
         let value = UIInterfaceOrientation.portrait.rawValue
         UIDevice.current.setValue(value, forKey: "orientation")
        
        if let lcUserInfo = m_cCommanData.getData()
        {
            self.m_cNametxt.text = lcUserInfo.name
            self.m_cEmailtxt.text = lcUserInfo.email
            self.m_cAddresstxt.text = lcUserInfo.address
            self.m_cAgetxt.text = String(lcUserInfo.Age)
            self.m_cMobiletxt.text = String(lcUserInfo.mobile!)
            self.m_cTypebtn.setTitle(lcUserInfo.entryType, for: .normal)
        }
        
    }
    
    @IBAction func onClosebtn_Click(_ sender: Any) {
        OrientationManager.landscapeSupported = true
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        
        UIDevice.current.setValue(value, forKey: "orientation")
        self.dismiss(animated: true, completion: nil)
    }
    

}
