//
//  AsyncMethodProcessor.swift
//  Runner
//
//  Created by CimZzz on 2020/3/15.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

open class AsyncMethodProcessor : BaseMethodProcessor {
    private var childProcessorList = [AsyncProcessor].init()
    
    fileprivate func getAsyncProcessor(arguments: [NSObject]?) -> AsyncProcessor? {
        var processor: AsyncProcessor? = nil
        for existProcessor in childProcessorList {
            if(existProcessor.matchArguments(arguments)) {
                processor = existProcessor
                break
            }
        }

        return processor
    }
    
    fileprivate func deleteAsyncProcessor(processor: AsyncProcessor) {
        if let idx = childProcessorList.firstIndex(of: processor) {
            childProcessorList.remove(at: idx)
        }
    }

    open func asyncHandle(_ result: @escaping FlutterResult, _ arguments: [NSObject]? = nil, _ callback: @escaping (AsyncResultCallback) -> Void) {
        var processor = getAsyncProcessor(arguments: arguments)
        var isNewProcessor = false
        
        if(processor == nil) {
            isNewProcessor = true
            let newProcessor = AsyncProcessor(arguments: arguments)
            processor = newProcessor
            childProcessorList.append(newProcessor)
        }

        processor?.resultList.append(result)
        
        if(isNewProcessor) {
            let asyncCallback = AsyncResultCallback(methodProcessor: self, processor: processor!)
            callback(asyncCallback)
        }
    }
}

open class AsyncResultCallback: NSObject {
    private let methodProcessor: AsyncMethodProcessor
    private let processor: AsyncProcessor
    
    private var isCompleted = false
    /**
     * 0 - 成功
     * 1 - 失败
     * 2 - 未实现
     */
    private var completedMode = 0
    private var params: Any? = nil
    private var strParams1: String = ""
    private var strParams2: String? = nil
    
    fileprivate init(methodProcessor: AsyncMethodProcessor, processor: AsyncProcessor) {
        self.methodProcessor = methodProcessor
        self.processor = processor
        super.init()
    }
    
    open func doSuccess(data: Any?) {
        if(isCompleted) {
            return
        }
        isCompleted = true
        completedMode = 0
        params = data
        DispatchQueue.main.async {
            self.perform()
        }
    }

    open func doError(errorCode: String, errorMessage: String?, errorDetail: Any?) {
        if(isCompleted) {
            return
        }
        isCompleted = true
        completedMode = 1
        params = errorDetail
        strParams1 = errorCode
        strParams2 = errorMessage
        DispatchQueue.main.async {
            self.perform()
        }
    }


    open func doNotImplemented() {
        if(isCompleted) {
            return
        }
        isCompleted = true
        completedMode = 2
        DispatchQueue.main.async {
            self.perform()
        }
    }

    open func perform() {
        switch(completedMode) {
        case 0:
            processor.doSuccess(data: params)
            break
        case 1:
            processor.doError(errorCode: strParams1, errorMessage: strParams2, errorDetail: params)
            break
        case 2:
            processor.doNotImplemented()
            break
        default:
            break
        }
        
        methodProcessor.deleteAsyncProcessor(processor: processor)
    }
}

private class AsyncProcessor : NSObject {
    let arguments: [NSObject]?
    var resultList = [FlutterResult].init()
    
    init(arguments: [NSObject]?) {
        self.arguments = arguments
        super.init()
    }
    
    func matchArguments(_ args: [NSObject]?) -> Bool {
        if(arguments == nil && args == nil) {
            return true
        }

        if(arguments == nil || args == nil) {
            return false
        }
        
        if let selfArgs = self.arguments, let paramsArgs = args {
            if(selfArgs.count != paramsArgs.count) {
                return false
            }

            let count = selfArgs.count
            var i = 0;
            while(i < count) {
                if(selfArgs[i] != paramsArgs[i]) {
                    return false
                }
                i += 1
            }
            
            return true
        }
        
        return false
    }
    
    func doSuccess(data: Any?) {
        resultList.forEach {
            it in
            it(data)
        }
    }

    func doError(errorCode: String, errorMessage: String?, errorDetail: Any?) {
        resultList.forEach {
            it in
            it(FlutterError(code: errorCode, message: errorMessage, details: errorDetail))
        }
    }

    func doNotImplemented() {
        resultList.forEach {
            it in
            it(FlutterMethodNotImplemented)
        }
    }
}
