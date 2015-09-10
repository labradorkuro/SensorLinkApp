//
//  ViewController.swift
//  SensorLinkApp
//
//  Created by TanakaTakenori on 2015/08/07.
//  Copyright (c) 2015年 TanakaTakenori. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var measureDate: UILabel!
    @IBOutlet weak var measureTime: UILabel!
    @IBOutlet weak var ampValue: UILabel!
    @IBOutlet weak var tempValue: UILabel!
    
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // サーバへデータをリクエスト
        sendRequest()
        // タイマー設定。30秒ごとにサーバへデータをリクエストして表示を更新する
        timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "sendRequest", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func requestSend(sender: UIButton) {
        sendRequest()
    }
    
    // サーバーへデータを要求する
    func sendRequest() {
        var startDate : String
        
        // 現在日時
        let today = NSDate()
        // 日付フォーマット設定
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.timeStyle = .MediumStyle
        dateFormatter.dateStyle = .MediumStyle
        startDate = dateFormatter.stringFromDate(today)
        //startDate = (startDate as NSString).substringWithRange(NSRange(location: 0, length: 10))
        // 日付部分文字列取得
        let startIndex = startDate.startIndex;
        startDate = startDate.substringToIndex(startIndex.advancedBy(10))
        startDate = startDate.stringByReplacingOccurrencesOfString("/", withString: "", range: nil)
        // NSURLConnectionでWebAPIを呼び出す
        let myUrl = NSURL(string: "http://157.7.222.217/trend_get?startdate=" + startDate + "&enddate=" + startDate + "&interval=1")
        let req = NSURLRequest(URL: myUrl!)
        //let connection = NSURLConnection(request: req, delegate: self, startImmediately: false)
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: self.fetchResponse)
        
    }
    // WebAPIの呼び出しresponse処理
    func fetchResponse(res:NSURLResponse?, data:NSData?, error:NSError?) {
        var date = "2015/09/01"
        var time = "12:00:00"
        var amp = "15.0"
        var temp = "21.5"
        if data != nil {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! Dictionary<String,AnyObject>
            if let last_trend: Dictionary = json["last_trend"] as? Dictionary<String,AnyObject> {
                date = last_trend["date"] as! String
                time = last_trend["time"] as! String
                if let values: Array = last_trend["value"] as? Array<String> {
                    amp = values[0] 
                    temp = values[1]
                }
            }
            
        }
        catch {
            
        }
        let dataDef : NSUserDefaults = NSUserDefaults(suiteName: "group.com.niigata-sl.com.SensorLinkApp")!

        dataDef.setObject(date, forKey: "measureDate")
        dataDef.setObject(time, forKey: "measureTime")
        dataDef.setObject(amp, forKey: "ampValue")
        dataDef.setObject(temp, forKey: "tempValue")
        
        updateDateLabel(dataDef.stringForKey("measureDate")!)
        updateTimeLabel(dataDef.stringForKey("measureTime")!)
        updateAmpLabel(dataDef.floatForKey("ampValue"))
        updateTempLabel(dataDef.floatForKey("tempValue"))
        }
    }
    func updateDateLabel(val:NSString) {
        measureDate.text =  "計測日付　" + (val as String)
    }
    func updateTimeLabel(val:NSString) {
        measureTime.text =  "計測時間　" + (val as String)
    }

    func updateAmpLabel(val:Float) {
        ampValue.text = "電流値 " + (NSString(format:"%.2f",val) as String) + "mA"
    }
    func updateTempLabel(val:Float) {
        tempValue.text = "温度値 " + (NSString(format:"%.2f",val) as String) + "℃"
    }
}

