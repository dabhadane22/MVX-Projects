//
//  AboutUsVC.swift
//  MVX
//
//  Created by Rupali Patil on 24/10/20.
//  Copyright © 2020 Rupali Patil. All rights reserved.
//

import UIKit

class AboutUsVC: UIViewController {

    @IBOutlet weak var m_cClosebtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BG-2")!)
        // Do any additional setup after loading the view.
        self.m_cClosebtn.layer.cornerRadius = self.m_cClosebtn.frame.width / 2
        self.m_cClosebtn.clipsToBounds = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        OrientationManager.landscapeSupported = true
         let value = UIInterfaceOrientation.landscapeLeft.rawValue
                
         UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    @IBAction func onClosebtn_Click(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
