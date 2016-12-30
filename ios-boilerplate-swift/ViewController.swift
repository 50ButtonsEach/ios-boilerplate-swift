//
//  ViewController.swift
//  ios-boilerplate-swift
//
//  Created by Anton Meier on 16/10/15.
//  Copyright © 2015 Anton Meier. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SCLFlicManagerDelegate, SCLFlicButtonDelegate {
    
    // TODO: Please use your own credentials before AppStore submission. They can be created at our developer portal.
    let SCL_APP_ID: String = "cfe4b5bb-ba39-4e51-808a-f9dcaad86341"
    let SCL_APP_SECRET: String = "bf6b88da-3c46-46be-bfdb-b3135819183a"
    
    @IBOutlet var indicator: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // TODO: If you want background execution you must opt in here. Dont forget to add Bluetooth Background mode in your project settings as well.
        SCLFlicManager.configure(with: self, defaultButtonDelegate: self, appID: SCL_APP_ID, appSecret: SCL_APP_SECRET, backgroundExecution: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func grabButton() {
        print("Grabbing a flic..")
        SCLFlicManager.shared()?.grabFlicFromFlicApp(withCallbackUrlScheme: "ios-boilerplate-swift")
    }
    
    @IBAction func connectFlic() {
        for (_, value) in (SCLFlicManager.shared()?.knownButtons())! {
            print("Connecting button..")
            value.connect()
        }
    }
    
    @IBAction func disconnectFlic() {
        for (_, value) in (SCLFlicManager.shared()?.knownButtons())! {
            print("Disconnecting button..")
            value.disconnect()
        }
    }
    
    // --- SCLFlicManagerDelegate menthods ---
    
    func flicManager(_ manager: SCLFlicManager, didGrab button: SCLFlicButton?, withError error: Error?) {
        if (error != nil) {
            print("Error: \(error!._domain) - \(error!._code)")
            return
        }
        // TODO: Here would be a good place to set the Flic latency in case you need lower latency
        //       Consider choosing your prefered triggerBehavior as well (Click / hold is default)
    }
    
    func flicManager(_ manager: SCLFlicManager, didChange state: SCLFlicManagerBluetoothState) {
        // TODO: Handle bluetooth state changes.
        print("Did change bluetooth state: \(state.rawValue)")
    }
    
    func flicManagerDidRestoreState(_ manager: SCLFlicManager) {
        print("Did restore state")
    }
    
    // --- SCLFlicButtonDelegate methods ---
    
    func flicButtonDidConnect(_ button: SCLFlicButton) {
        print("Flic is connected")
    }
    
    func flicButtonIsReady(_ button: SCLFlicButton) {
        print("Flic is ready")
    }
    
    func flicButton(_ button: SCLFlicButton, didDisconnectWithError error: Error?) {
        print("Flic disconnected")
    }
    
    func flicButton(_ button: SCLFlicButton, didFailToConnectWithError error: Error?) {
        print("Did fail to connect Flic")
        if (error != nil) {
            if (error!._code == SCLFlicError.buttonIsPrivate.rawValue) {
                SCLFlicManager.shared()?.forget(button)
            }
        }
    }
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonDown queued: Bool, age: Int) {
        print("Button down..")
        self.indicator.backgroundColor = button.color
    }
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonUp queued: Bool, age: Int) {
        self.indicator.backgroundColor = UIColor.init(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    }
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonClick queued: Bool, age: Int) {
        print("Flic was clicked..")
    }

}

