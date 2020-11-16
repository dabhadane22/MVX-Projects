//
//  Alert.swift
//  Perfecto
//
//  Created by Prem Sahni on 24/10/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import Foundation
import UIKit

class Alert
{
    static let shared : Alert = Alert()
    private init() {}
     var blurEffectView = UIVisualEffectView()
    var message = UILabel()

    
    func basicalert(vc: UIViewController,title: String,msg: String){
        let alertcontroller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
//        let Ok = UIAlertAction(title: "OK", style: .default) { (action) in
//            print("ok")
//        }
        
        alertcontroller.addAction(ok)
        vc.present(alertcontroller, animated: true, completion: nil)
    }
    func dismissAlert(vc: UIViewController){
        vc.dismiss(animated: true, completion: nil)
    }
    
    func checkIfAlertViewHasPresented() -> UIAlertController? {
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            if topController is UIAlertController {
                return (topController as! UIAlertController)
            } else {
                return nil
            }
        }
        return nil
    }
    
    func ActionAlert(vc: UIViewController,title: String,msg: String,buttontitle: String,button2title: String,ActionCompletion: @escaping () -> (),Action2Completion: @escaping () -> ()){
        if (checkIfAlertViewHasPresented() != nil) {

        } else {
 
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindow.Level.alert + 1
            alertWindow.backgroundColor = UIColor.clear

            let alertcontroller = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let titleFont = [NSAttributedString.Key.font: UIFont(name: "ArialHebrew-Bold", size: 18.0)!]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: "ArialHebrew-Bold", size: 15.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: msg, attributes: messageFont)
            
            alertcontroller.setValue(titleAttrString, forKey: "attributedTitle")
            alertcontroller.setValue(messageAttrString, forKey: "attributedMessage")

            alertcontroller.view.backgroundColor = UIColor.clear
        
            let button2 = UIAlertAction(title: button2title, style: .cancel) { (action) in
                Action2Completion()
            }
            //let button1 = UIAlertAction(title: buttontitle, style: .default, image:  imageLiteral(resourceName: "like.png").withRenderingMode(.alwaysOriginal)) { (action) in
                //ActionCompletion()
            let button1 = UIAlertAction(title: buttontitle, style: .default) { (action) in
                ActionCompletion()
              
            }
           // button1.setValue(#imageLiteral(resourceName: "like.png"), forKey: "image")
            alertcontroller.addAction(button1)
            alertcontroller.addAction(button2)
            alertWindow.makeKeyAndVisible()
            vc.present(alertcontroller, animated: true, completion: nil)
        }
           //vc.present(alertcontroller, animated: true, completion: nil)
    }
    
    func RejectReason(vc: UIViewController,title: String,msg: String,ActionCompletion: @escaping () -> ()){
        let alertcontroller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertcontroller.addTextField { (textfield: UITextField) in
            textfield.placeholder = "Remark"
            textfield.delegate = vc as? UITextFieldDelegate
            textfield.clearButtonMode = .whileEditing
            textfield.frame.size.height = 50
            textfield.backgroundColor = UIColor.clear
            textfield.borderStyle = .none
            DispatchQueue.main.async {
                
            }
        }
        alertcontroller.addTextField { (textfield: UITextField) in
            textfield.placeholder = "Action Plan"
            textfield.delegate = vc as? UITextFieldDelegate
            textfield.clearButtonMode = .whileEditing
            textfield.frame.size.height = 50
            textfield.backgroundColor = UIColor.clear
            textfield.borderStyle = .none
            DispatchQueue.main.async {
                
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let Send = UIAlertAction(title: "Send", style: .destructive) { (action) in
            let first = alertcontroller.textFields![0] as UITextField
            let Second = alertcontroller.textFields![1] as UITextField
            if (first.text?.isEmpty)! && (Second.text?.isEmpty)! {
               // vc.view.showToast("Empty Remark & Action Plan \n Compulsory If Status is Reject Write Remark & Action Plan", position: .bottom, popTime: 3, dismissOnTap: false)
            } else if (first.text?.isEmpty)!{
               // vc.view.showToast("Empty Remark \n Compulsory If Status is Reject Write Remark", position: .bottom, popTime: 3, dismissOnTap: false)
            } else if (Second.text?.isEmpty)!{
              //  vc.view.showToast("Empty Action Plan \n Compulsory If Status is Reject Write Action Plan", position: .bottom, popTime: 3, dismissOnTap: false)
            } else {
                ActionCompletion()
            }
        }
        alertcontroller.addAction(Send)
        alertcontroller.addAction(cancel)
        vc.present(alertcontroller, animated: true, completion: nil)
    }
    func choose(vc: UIViewController,title1: String,title2: String,ActionCompletion: @escaping () -> (),Action2Completion: @escaping () -> ()){
        let alertcontroller = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let button1 = UIAlertAction(title: title1, style: .default) { (action) in
            ActionCompletion()
        }
        let button2 = UIAlertAction(title: title2, style: .default) { (action) in
            Action2Completion()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertcontroller.addAction(button1)
        alertcontroller.addAction(button2)
        alertcontroller.addAction(cancel)
        vc.present(alertcontroller, animated: true, completion: nil)
    }
    
   
    
    func ShowLoaderView(view: UIView,Message: String){
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        print(view.frame)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: blurEffectView.contentView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: blurEffectView.contentView.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        
        message.text = Message
        message.translatesAutoresizingMaskIntoConstraints = false
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = 0
        message.textAlignment = .center
        message.font = UIFont.boldSystemFont(ofSize: 18)
        message.textColor = UIColor.white
        blurEffectView.contentView.addSubview(message)
        
        message.leftAnchor.constraint(equalTo: blurEffectView.contentView.leftAnchor, constant: 30).isActive = true
        message.rightAnchor.constraint(equalTo: blurEffectView.contentView.rightAnchor, constant: -30).isActive = true
        message.topAnchor.constraint(equalTo: activityIndicator.topAnchor, constant: 50).isActive = true
    }
    func RemoveLoaderView(){
        DispatchQueue.main.async {
            self.blurEffectView.removeFromSuperview()
        }
    }
   
}

extension UIAlertAction {
    convenience init(title: String?, style: UIAlertAction.Style, image: UIImage, handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: title, style: style, handler: handler)
        self.actionImage = image
    }
    var actionImage: UIImage {
        get {
            return self.value(forKey: "image") as? UIImage ?? UIImage()
        }
        set(image) {
            self.setValue(image, forKey: "image")
        }
    }
}

extension UIView{
    
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor)
    {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 500, height: 500))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        self.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}






/*
 
 func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
 let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
 deviceTokenString = token
 print(deviceToken)
 }
 func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
 print("i am not available in simulator \(error)")
 }
 
 UNUserNotificationCenter.current().delegate = self
 application.registerForRemoteNotifications()
 UNUserNotificationCenter.current().cleanRepeatingNotifications()
 UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -500.0, vertical: 0.0), for: .default)
 
 setCategories()
 
 
 extension AppDelegate:  UNUserNotificationCenterDelegate{
 
 func setCategories(){
 let clearRepeatAction = UNNotificationAction(
 identifier: "clear.repeat.action",
 title: "Stop Repeat",
 options: [])
 let remindaction = UNNotificationAction(
 identifier: "remindLater",
 title: "Remind me later",
 options: [])
 let Category = UNNotificationCategory(
 identifier: "medicine.reminder.category",
 actions: [clearRepeatAction,remindaction],
 intentIdentifiers: [],
 options: [])
 UNUserNotificationCenter.current().setNotificationCategories([Category])
 }
 
 
 func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
 completionHandler([.alert,.sound])
 
 }
 
 func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
 if UIApplication.shared.applicationState == .background{
 print("bg")
 }
 UNUserNotificationCenter.current().cleanRepeatingNotifications()
 print("Did recieve response: \(response.actionIdentifier)")
 if response.actionIdentifier == "clear.repeat.action"{
 UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [response.notification.request.identifier])
 
 }
 if response.actionIdentifier == "remindLater" {
 UNUserNotificationCenter.current().getDeliveredNotifications { (receivedNotifications) in
 for notification in receivedNotifications {
 let content = notification.request.content
 let newDate = Date(timeInterval: 60, since: Date())
 self.scheduleNotification(at: newDate, title: content.title, body: content.body, withCompletionHandler: {
 completionHandler()
 })
 }
 }
 }
 completionHandler()
 }
 func scheduleNotification(at date: Date,title: String,body: String,withCompletionHandler: @escaping() -> ()) {
 let calendar = Calendar(identifier: .gregorian)
 let components = calendar.dateComponents(in: .current, from: date)
 let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
 
 let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
 
 let content = UNMutableNotificationContent()
 content.title = title
 content.body = body
 content.sound = UNNotificationSound.default
 content.categoryIdentifier = "medicine.reminder.category"
 
 let request = UNNotificationRequest(identifier: date.description, content: content, trigger: trigger)
 
 UNUserNotificationCenter.current().delegate = self
 UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
 UNUserNotificationCenter.current().add(request) {(error) in
 if let error = error {
 print("Uh oh! We had an error: \(error)")
 }
 }
 }
 
 }
 
 
 

 
 extension UNUserNotificationCenter{
    func cleanRepeatingNotifications(){
        //cleans notification with a userinfo key endDate
        //which have expired.
        var cleanStatus = "Cleaning...."
        getPendingNotificationRequests {
            (requests) in
            for request in requests{
                if let endDate = request.content.userInfo["endDate"]{
                    if Date() >= (endDate as! Date){
                        cleanStatus += "Cleaned request"
                        let center = UNUserNotificationCenter.current()
                        center.removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    } else {
                        cleanStatus += "No Cleaning"
                    }
                    print(cleanStatus)
                }
            }
        }
    }
    
    
}*/
