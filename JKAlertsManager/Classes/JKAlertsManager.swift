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


@objcMembers class JKAlertsManager: NSObject {
    static let shareInstance = JKAlertsManager()
    
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
      JKAlertsManager.shareInstance.lock.lock()
        JKAlertsManager.shareInstance.alerts.append(alert)
        JKAlertsManager.shareInstance.alerts.sort(by: { (_ alert1:JKAlertConfig, _ alert2:JKAlertConfig) -> Bool in
            return alert1.priority > alert2.priority
        })
      JKAlertsManager.shareInstance.lock.unlock()
    }
    
    public class func removeAlert() -> Void{
        JKAlertsManager.shareInstance.lock.lock()
        if JKAlertsManager.shareInstance.alerts.count > 0 {
          JKAlertsManager.shareInstance.alerts.removeFirst()
          JKAlertsManager.shareInstance.hasShowedAlert = false
        }
        JKAlertsManager.shareInstance.lock.unlock()
    }
    
    public class func removeAllAlerts() -> Void{
        JKAlertsManager.shareInstance.lock.lock()
        JKAlertsManager.shareInstance.alerts.removeAll()
        JKAlertsManager.shareInstance.hasShowedAlert = false
        JKAlertsManager.shareInstance.lock.unlock()
    }
    
    public class func alertCount() -> NSInteger{
        return JKAlertsManager.shareInstance.alerts.count;
    }
    
    public class func firstAlertConfig() -> JKAlertConfig?{
        return JKAlertsManager.shareInstance.alerts.first
    }
    
    public class func showAlert() -> Void{
        if JKAlertsManager.shareInstance.hasShowedAlert == false {
            let alertConfig:JKAlertConfig? = JKAlertsManager.firstAlertConfig()
            if alertConfig != nil {
                if let currentAlertConfigBlock = JKAlertsManager.shareInstance.currentAlertConfigBlock{
                    currentAlertConfigBlock(alertConfig!)
                }
            
            }
          
        }
    }
}
