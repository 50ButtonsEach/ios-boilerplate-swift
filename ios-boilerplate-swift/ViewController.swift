//
//  ViewController.swift
//  ios-boilerplate-swift
//
//  Created by Anton Meier on 16/10/15.
//  Copyright © 2015 Anton Meier. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SCLFlicManagerDelegate, SCLFlicButtonDelegate {
    
    var manager: SCLFlicManager!
    var button: SCLFlicButton!
    
    // TODO: Please use your own credentials before AppStore submission. They can be created at our developer portal.
    let SCL_APP_ID: String = "cfe4b5bb-ba39-4e51-808a-f9dcaad86341"
    let SCL_APP_SECRET: String = "bf6b88da-3c46-46be-bfdb-b3135819183a"
    
    @IBOutlet var indicator: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (self.manager == nil) {
            NSLog("Initing manager..");
            // TODO: If you want background execution you must change the flags accordingly. Dont forget to add Bluetooth Background mode in your project settings as well.
            self.manager = SCLFlicManager(delegate: self, appID: SCL_APP_ID, appSecret: SCL_APP_SECRET, backgroundExecution: false, andRestoreState: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func grabButton() {
        NSLog("Grabbing a flic..")
        self.manager?.requestButtonFromFlicAppWithCallback("ios-boilerplate-swift://button")
    }
    
    @IBAction func connectFlic() {
        self.button?.connect()
    }
    
    @IBAction func disconnectFlic() {
        self.button?.disconnect()
    }
    
    func handleOpenURL(url: NSURL) -> Bool {
        // If we have already grabbed a Flic then we need to remove it before generating a new one since this demo project is not set up ta support multiple Flics.
        if (self.button != nil) { self.manager?.forgetButton(button) }
        self.button = self.manager?.generateButtonFromURL(url)
        if ( self.button == nil ) { NSLog("A Flic object coult not be created..") }
        self.button?.delegate = self
        // TODO: Here would be a good place to select the Flic mode. self.button?.mode = ...
        //       Consider choosing your prefered triggerBehavior as well (Click / hold is default)
        self.button?.connect() // We do not have to connect immediately, but for now we do that
        return true
    }
    
    // --- SCLFlicManagerDelegate menthods ---
    
    func flicManager(manager: SCLFlicManager, didChangeBluetoothState state: SCLFlicManagerBluetoothState) {
        // TODO: Handle bluetooth state changes.
        NSLog("FlicManager did change state..")
    }
    
    // --- SCLFlicButtonDelegate methods ---
    
    func flicButtonDidConnect(button: SCLFlicButton) {
        NSLog("Flic is connected")
    }
    
    func flicButtonIsReady(button: SCLFlicButton) {
        NSLog("Flic is ready")
    }
    
    func flicButton(button: SCLFlicButton, didDisconnectWithError error: NSError?) {
        NSLog("Flic disconnected")
    }
    
    func flicButton(button: SCLFlicButton, didFailToConnectWithError error: NSError?) {
        NSLog("Did fail to connect Flic")
    }
    
    func flicButton(button: SCLFlicButton, didReceiveButtonDown queued: Bool, age: Int) {
        self.indicator.backgroundColor = UIColor.init(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0)
    }
    
    func flicButton(button: SCLFlicButton, didReceiveButtonUp queued: Bool, age: Int) {
        self.indicator.backgroundColor = UIColor.init(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    }
    
    func flicButton(button: SCLFlicButton, didReceiveButtonClick queued: Bool, age: Int) {
        NSLog("Button click..")
    }

}

