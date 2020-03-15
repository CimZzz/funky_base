package com.virtualightning.funky_base

import android.content.Context
import android.os.Handler
import io.flutter.plugin.common.MethodChannel
import java.util.*

typealias AsyncCallback = (AsyncResultCallback) -> Unit

/**
 *  Anchor : Create by CimZzz
 *  Time : 2020/03/15 09:04:13
 *  Project : funky_base
 *  Since Version : 1.0.0
 *
 *  异步方法处理元
 *  用来处理异步方法
 */
abstract class AsyncMethodProcessor(methodName: String, context: Context? = null) : BaseMethodProcessor(methodName, context) {
	private val childProcessorList = LinkedList<AsyncProcessor>()
	internal lateinit var handler: Handler

	private fun getAsyncProcessor(arguments: List<Any>?) : AsyncProcessor? {
		var processor: AsyncProcessor? = null
		for(existProcessor in childProcessorList) {
			if(existProcessor.matchArguments(arguments)) {
				processor = existProcessor
				break
			}
		}

		return processor
	}

	internal fun deleteAsyncProcessor(processor: AsyncProcessor) {
		childProcessorList.remove(processor)
	}

	/**
	 * 执行异步处理
	 * 注意在 AsyncCallback 回调执行在主线程，如果需要使用子线程，请在回调中自行处理
	 */
	fun asyncHandle(result: MethodChannel.Result, arguments: List<Any>? = null, callback: AsyncCallback) {
		var processor = getAsyncProcessor(arguments)
		var isNewProcessor = false
		if(processor == null) {
			isNewProcessor = true
			processor = AsyncProcessor(arguments)
			childProcessorList.add(processor)
		}

		processor.addResult(result)

		if(isNewProcessor) {
			val resultCallback = AsyncResultCallback(this, processor)
			callback(resultCallback)
		}
	}
}

class AsyncResultCallback internal constructor(
	private val asyncMethodProcessor: AsyncMethodProcessor,
	private val asyncProcessor: AsyncProcessor
) {
	private var isCompleted = false
	/**
	 * 0 - 成功
	 * 1 - 失败
	 * 2 - 未实现
	 */
	private var completedMode = 0
	private var params: Any? = null
	private var strParams1: String = ""
	private var strParams2: String? = null


	fun doSuccess(data: Any?) {
		if(isCompleted) {
			return
		}
		isCompleted = true
		completedMode = 0
		params = data
		asyncMethodProcessor.handler.obtainMessage(FunkyBasePlugin.ASYNC_COMPLETED, this).sendToTarget()
	}

	fun doError(errorCode: String, errorMessage: String?, errorDetail: Any?) {
		if(isCompleted) {
			return
		}
		isCompleted = true
		completedMode = 1
		params = errorDetail
		strParams1 = errorCode
		strParams2 = errorMessage
		asyncMethodProcessor.handler.obtainMessage(FunkyBasePlugin.ASYNC_COMPLETED, this).sendToTarget()
	}


	fun doNotImplemented() {
		if(isCompleted) {
			return
		}
		isCompleted = true
		completedMode = 2
		asyncMethodProcessor.handler.obtainMessage(FunkyBasePlugin.ASYNC_COMPLETED, this).sendToTarget()
	}

	internal fun perform() {
		when(completedMode) {
			0 -> {
				asyncProcessor.doSuccess(params)
			}
			1 -> {
				asyncProcessor.doError(strParams1, strParams2, params)
			}
			2 -> {
				asyncProcessor.doNotImplemented()
			}
		}
		asyncMethodProcessor.deleteAsyncProcessor(asyncProcessor)
	}
}

/**
 *  Anchor : Create by CimZzz
 *  Time : 2020/03/15 09:08:39
 *  Project : funky_base
 *  Since Version : 1.0.0
 *
 *  异步方法处理子元
 */
internal class AsyncProcessor(private val arguments: List<Any>?) {
	private val resultList = LinkedList<MethodChannel.Result>()

	fun addResult(result : MethodChannel.Result) {
		resultList.add(result)
	}

	fun matchArguments(args: List<Any>?) : Boolean {
		if(arguments == null && args == null) {
			return true
		}

		if(arguments == null || args == null) {
			return false
		}

		if(arguments.size != args.size) {
			return false
		}

		val count = arguments.size
		for(i in 0 until count) {
			if(arguments[i] != args[i]) {
				return false
			}
		}

		return true
	}

	fun doSuccess(data: Any?) {
		resultList.forEach {
			try {
				it.success(data)
			}
			catch (e: Throwable) {
				e.printStackTrace()
			}
		}
	}

	fun doError(errorCode: String, errorMessage: String?, errorDetail: Any?) {
		resultList.forEach {
			try {
				it.error(errorCode, errorMessage, errorDetail)
			}
			catch (e: Throwable) {

			}
		}
	}

	fun doNotImplemented() {
		resultList.forEach {
			try {
				it.notImplemented()
			}
			catch (e: Throwable) {

			}
		}
	}
}