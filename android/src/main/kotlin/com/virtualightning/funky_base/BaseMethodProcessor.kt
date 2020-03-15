package com.virtualightning.funky_base

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference

/**
 *  Anchor : Create by CimZzz
 *  Time : 2020/03/15 08:49:26
 *  Project : funky_base
 *  Since Version : 1.0.0
 *
 *  方法处理元
 *  可以为 FunkyPlugin 扩展处理方法
 */
abstract class BaseMethodProcessor(val methodName: String, context: Context? = null) {
	private val contextRef: WeakReference<Context>? = if(context == null) null else WeakReference(context)

	abstract fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result)

	fun getContext(): Context? = contextRef?.get()
}