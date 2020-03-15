//
//  Test.swift
//  Runner
//
//  Created by CimZzz on 2020/3/15.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//
import Flutter
import UIKit
import funky_base

public class TestPlugin : SyncMethodProcessor {
    
    public override func getMethodName() -> String {
        return "test"
    }
    
    public override func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("test success")
    }
}
