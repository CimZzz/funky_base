package com.virtualightning.funky_base.concreted

import android.content.Context
import com.virtualightning.funky_base.SyncMethodProcessor
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 *  Anchor : Create by CimZzz
 *  Time : 2020/03/16 17:14:36
 *  Project : android
 *  Since Version : Alpha
 */
class DataCacheProcessor(
	context: Context,
	spName: String,
	mode: Int = Context.MODE_PRIVATE) : SyncMethodProcessor("dataCache", context) {

	private val sharedPreferences = context.getSharedPreferences(spName, mode)

	override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
		val isSave = call.argument<Boolean>("isSave")
		if(isSave == null) {
			result.error("params not match", "params not match", null)
			return
		}
		if(isSave) {
			val key = call.argument<String>("key")
			val value = call.argument<Any>("value")
			if(key == null || value == null) {
				
			}
		}
		else {

		}
	}
}