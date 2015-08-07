//
//  InterfaceController.swift
//  SensorLinkApp WatchKit Extension
//
//  Created by TanakaTakenori on 2015/08/07.
//  Copyright (c) 2015年 TanakaTakenori. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var sensorValue_1: WKInterfaceLabel!
    @IBOutlet weak var sensorValue_2: WKInterfaceLabel!
    @IBOutlet weak var measureTime: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        setSensorValue_1(10.00)
        setSensorValue_2(25.00)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    // 電流値の表示更新
    func setSensorValue_1(val:Float?) {
        sensorValue_1.setText("電流値　" +
            (NSString(format:"%.2f",val!) as String) + "mA")
    }
    // 温度値の表示更新
    func setSensorValue_2(val:Float?) {
        sensorValue_2.setText("温度値　" +
            (NSString(format:"%.2f",val!) as String) + "℃")
    }
}
