//
//  ViewController.swift
//  iOSScreenRecordingDetector
//
//  Created by admin on 1/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {




    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.handlingScreenRecordingStatusChanged(_:)), name: Notification.Name.init(ScreenRecordingDetector.sharedInstance.kScreenRecordingDetectorRecordingStatusChangedNotification), object: nil)

        ScreenRecordingDetector.triggerDetectorTimer()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func handlingScreenRecordingStatusChanged(_ notification : Notification) {
        print("isRecording: \(ScreenRecordingDetector.sharedInstance.isRecording)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

