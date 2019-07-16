//
//  JKAlertManager.swift
//  JKAlertManager
//
//  Created by JackLee on 2019/7/15.
//

import Foundation

@objcMembers class JKAlertConfig: NSObject {
    /// this is the type of alert
    public var alertType:NSInteger = 0
    /// the show priority of the alert
    public var priority:NSInteger = 0
    /// the params of the alert about the content
    public var params:NSDictionary = [:]
}

typealias JKAlertConfigBlock = (_ alert:JKAlertConfig) ->Void


@objcMembers class JKAlertManager: NSObject {
    static let shareInstance = JKAlertManager()
    
    public var currentAlertConfigBlock:JKAlertConfigBlock?
    
    private var hasShowedAlert:Bool = false
    
    private lazy var lock:NSLock = {
        let tmpLock:NSLock = NSLock.init()
        return tmpLock
    }()
    
    private lazy var alerts:Array<JKAlertConfig> = {
        let tmpAlerts:[JKAlertConfig] = []
        return tmpAlerts
    }()
    
    public class func addAlert(alert:JKAlertConfig) -> Void{
      JKAlertManager.shareInstance.lock.lock()
        JKAlertManager.shareInstance.alerts.append(alert)
        JKAlertManager.shareInstance.alerts.sort(by: { (_ alert1:JKAlertConfig, _ alert2:JKAlertConfig) -> Bool in
            return alert1.priority > alert2.priority
        })
      JKAlertManager.shareInstance.lock.unlock()
    }
    
    public class func removeAlert() -> Void{
        JKAlertManager.shareInstance.lock.lock()
        if JKAlertManager.shareInstance.alerts.count > 0 {
          JKAlertManager.shareInstance.alerts.removeFirst()
          JKAlertManager.shareInstance.hasShowedAlert = false
        }
        JKAlertManager.shareInstance.lock.unlock()
    }
    
    public class func removeAllAlerts() -> Void{
        JKAlertManager.shareInstance.lock.lock()
        JKAlertManager.shareInstance.alerts.removeAll()
        JKAlertManager.shareInstance.hasShowedAlert = false
        JKAlertManager.shareInstance.lock.unlock()
    }
    
    public class func alertCount() -> NSInteger{
        return JKAlertManager.shareInstance.alerts.count;
    }
    
    public class func firstAlertConfig() -> JKAlertConfig?{
        return JKAlertManager.shareInstance.alerts.first
    }
    
    public class func showAlert() -> Void{
        if JKAlertManager.shareInstance.hasShowedAlert == false {
            let alertConfig:JKAlertConfig? = JKAlertManager.firstAlertConfig()
            if alertConfig != nil {
                if let currentAlertConfigBlock = JKAlertManager.shareInstance.currentAlertConfigBlock{
                    currentAlertConfigBlock(alertConfig!)
                }
            
            }
          
        }
    }
}
