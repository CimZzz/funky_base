package com.virtualightning.funky_base_example

import androidx.annotation.NonNull;
import com.virtualightning.funky_base.AsyncMethodProcessor
import com.virtualightning.funky_base.FunkyBasePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        GeneratedPluginRegistrant.registerWith(flutterEngine)
        val plugin = FunkyBasePlugin()
        plugin.addMethodProcess(object: AsyncMethodProcessor("test", this) {
            override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
                asyncHandle(result, listOf(call.arguments)) {
                    Thread {
                        Thread.sleep(5000)
                        it.doSuccess("completed")
                    }.start()
                }
            }
        })
        flutterEngine.plugins.add(plugin)
    }
}
