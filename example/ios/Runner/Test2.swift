//
//  Test2.swift
//  Runner
//
//  Created by CimZzz on 2020/3/15.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//
import Flutter
import UIKit
import funky_base

public class TestPlugin2 : AsyncMethodProcessor {
    
    public override func getMethodName() -> String {
        return "test2"
    }
    
    public override func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("handleMethodCall")
        asyncHandle(result) { (callback) in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
                print("do callback")
                callback.doSuccess(data: "test 2 success")
            }
        }
    }
}

