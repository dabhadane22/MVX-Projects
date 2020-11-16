//
//  SettingVC.swift
//  MVX
//
//  Created by Nikita on 14/10/20.
//  Copyright © 2020 Rupali Patil. All rights reserved.
//

import UIKit
import AVFoundation
import StoreKit

class SettingVC: UIViewController,SKStoreProductViewControllerDelegate {

    @IBOutlet weak var m_cSwiftchbtn: UIButton!
    typealias complitionHandler = ()-> Void
    
    var complition : complitionHandler?
    
    var m_bSwitch = Bool(false)
    
    var m_cSKStoreProductViewController : SKStoreProductViewController!
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_cSKStoreProductViewController = SKStoreProductViewController()
        m_cSKStoreProductViewController.delegate = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BG-2")!)
        self.m_bSwitch = false
        
        let music = Bundle.main.path(forResource: "Test", ofType: "mp3.webarchive")
               do {
                   audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: music! ))
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
                   try AVAudioSession.sharedInstance().setActive(true)
               }
               catch{
                   print(error)
               }
 }
    
    
    @IBAction func onFeedbackbtn_Click(_ sender: Any) {
        OrientationManager.landscapeSupported = true
         let value = UIInterfaceOrientation.portrait.rawValue
         UIDevice.current.setValue(value, forKey: "orientation")
        
        self.m_cSKStoreProductViewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: 586447913)], completionBlock: nil)
        self.m_cSKStoreProductViewController.modalPresentationStyle = .fullScreen
        present(self.m_cSKStoreProductViewController, animated: true, completion: nil)
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
       
        OrientationManager.landscapeSupported = true
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        
        UIDevice.current.setValue(value, forKey: "orientation")
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
   
    @IBAction func btnclose_onclick(_ sender: Any)
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onLogout_Click(_ sender: Any) {
       self.dismiss(animated: false, completion: nil)
        
        guard let lcComplitinBlock = self.complition else {
            return
        }
        
        lcComplitinBlock()
    }
    
    @IBAction func onProfile_Click(_ sender: Any) {
        let lcProfileVC = self.storyboard?.instantiateViewController(identifier: "ProfileVC") as! ProfileVC
        lcProfileVC.view.clipsToBounds = true
        lcProfileVC.modalPresentationStyle = .fullScreen
        self.present(lcProfileVC, animated: true, completion: nil)
    }
    
    @IBAction func OnSwitchbtn_Click(_ sender: Any) {
        self.m_bSwitch = !self.m_bSwitch
        self.m_cSwiftchbtn.setImage(self.m_bSwitch ? UIImage(named: "switch-on") : UIImage(named: "switch-off"), for: .normal)
        if self.m_bSwitch
        {
            audioPlayer.play()
        }else{
            audioPlayer.stop()
        }
    }
    
    
}
