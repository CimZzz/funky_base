import 'package:flutter/material.dart';
import 'package:taskpipeline/taskpipeline.dart';
import 'page.dart';

/// UI 组件快速操作 PageInterface 混合
mixin PageInterfaceChildMixin<T extends StatefulWidget, E extends PageInterface> on
	State<T> {
	
	E _interface;
	
	E get pageInterface => _interface;
	
	@override
	@mustCallSuper
	void didChangeDependencies() {
		super.didChangeDependencies();
		final newInterface = PageInterfaceQuery.find(context);
		if (newInterface == _interface) {
			return;
		}
		
		if (_interface != null) {
			onDestroyWithPageInterface();
		}
		
		_interface = newInterface;
		if (_interface != null) {
			onInitWithPageInterface();
		}
	}
	
	@override
	@mustCallSuper
	void dispose() {
		super.dispose();
		if (_interface != null) {
			onDestroyWithPageInterface();
		}
	}
	
	/// PageInterface 变更，重新获取时触发回调
	@mustCallSuper
	void onInitWithPageInterface() {
	}
	
	/// PageInterface 销毁时回调
	@mustCallSuper
	void onDestroyWithPageInterface() {
		_interface.broadcastManager.unregisterObjectAllReceiver(this);
	}
}

/// TaskPipeline 混合
mixin TaskPipelineMixin<T extends StatefulWidget> on State<T> {
	TaskPipeline _taskPipeline;
	
	TaskPipeline get taskPipeline => _taskPipeline ??= TaskPipeline();
	
	@override
	void dispose() {
		super.dispose();
		_taskPipeline.destroy();
	}
}