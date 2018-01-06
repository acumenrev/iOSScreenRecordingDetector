//
//  ScreenRecordingDetector.swift
//  iOSScreenRecordingDetector
//
//  Created by admin on 1/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ScreenRecordingDetector: NSObject {
    private let kScreenRecordingDetectorTimeInterval : TimeInterval = 1.0
    let kScreenRecordingDetectorRecordingStatusChangedNotification = "kScreenRecordingDetectorRecordingStatusChangedNotification"

    private var timer : Timer? = nil
    private var lastRecordingState : Bool = false

    static let sharedInstance : ScreenRecordingDetector = {
        ScreenRecordingDetector()
    }()

    private override init() {
        super.init()
        self.lastRecordingState = false
        self.timer = nil
    }

    static func triggerDetectorTimer() {
        let detector = ScreenRecordingDetector.sharedInstance
        if detector.timer != nil {
            stopDetectorTimer()
        }

        detector.timer = Timer.scheduledTimer(timeInterval: detector.kScreenRecordingDetectorTimeInterval, target: detector, selector: #selector(detector.checkCurrentRecordingStatus(_:)), userInfo: nil, repeats: true)
    }

    static func stopDetectorTimer() {
        let detector = ScreenRecordingDetector.sharedInstance
        if detector.timer != nil {
            detector.timer?.invalidate()
            detector.timer = nil
        }
    }

    @objc private func checkCurrentRecordingStatus(_ timer : Timer?) {
        let isRecording = self.isRecording;
        if isRecording != self.lastRecordingState {
            NotificationCenter.default.post(name: Notification.Name.init(kScreenRecordingDetectorRecordingStatusChangedNotification), object: nil)
        }
        self.lastRecordingState = isRecording ?? false
    }



    var isRecording : Bool! {
        get {

            for screen in UIScreen.screens {
                if screen.responds(to: #selector(getter: screen.isCaptured)) {
                    if (screen.perform(#selector(getter: screen.isCaptured)) != nil) {
                        // screen capture is active
                        return true
                    } else if screen.mirrored != nil {
                        // mirroring is active
                        return true
                    }
                } else {
                    // iOS version below 11
                    if screen.mirrored != nil {
                        return true
                    }
                }
            }

            return false
        }
    }


}
