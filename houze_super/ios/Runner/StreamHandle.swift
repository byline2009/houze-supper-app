//
//  StreamHandle.swift
//  Runner
//
//  Created by Dan Hon on 10/9/20.
//

import UIKit
import Flutter

class StreamHandle: FlutterStreamHandler {
    
    var eventSink: FlutterEventSink?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    func excuteEventSink(data: String) {
        if (eventSink != nil) {
            eventSink!(data)
        }
    }
}
