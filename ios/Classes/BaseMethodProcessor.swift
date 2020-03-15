//
//  BaseMethodProcessor.swift
//  Runner
//
//  Created by CimZzz on 2020/3/15.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//
open class BaseMethodProcessor : NSObject {
    open func getMethodName() -> String {
        return ""
    }

    open func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
}
