//
//  LaunchVC.swift
//  MVX
//
//  Created by Rupali Patil on 17/10/20.
//  Copyright © 2020 Rupali Patil. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BG")!)
        self.extendSplashScreenPresentation()
        // Do any additional setup after loading the view.
    }
    
    @objc private func dismissSplashController() {
        let MainContainerVC = self.storyboard?.instantiateViewController(identifier: "MainContainerVC") as! MainContainerVC
        MainContainerVC.modalPresentationStyle = .fullScreen
        self.present(MainContainerVC, animated: false, completion: nil)
        
     }

    private func extendSplashScreenPresentation(){
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(dismissSplashController), userInfo: nil, repeats: false)
    }

}
