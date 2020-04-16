import 'package:broadcast_manager/broadcast_manager.dart';
import 'package:flutter/material.dart';
import 'package:funky_base/src/base/exceptions.dart';
import 'package:funky_base/src/core/page_manager.dart';
import 'package:taskpipeline/taskpipeline.dart';

/// 页面基类
abstract class BasePage extends StatefulWidget {
	BasePage(this.pageName);
	
	/// 页面 Name
	final String pageName;
	
	@override
	BasePageState createState();
}

/// 页面基类状态
/// 可自定义 PageInterface
abstract class BasePageWithInterfaceState<T extends BasePage, E extends PageInterface>
	extends State<T> {
	E _interface;
	
	E get pageInterface => _interface;
	
	/// 重载初始化方法
	@override
	void initState() {
		super.initState();
		final pageInterface = createPageInterface();
		if (pageInterface is! E) {
			throw PageInterfaceNotMatchException(E);
		}
		else {
			_interface = pageInterface;
		}
		onInit();
	}
	
	/// 重载回收方法
	@override
	void dispose() {
		_interface._destroy();
		onDestroy();
		super.dispose();
	}
	
	/// 重载构造 Widget 方法
	@override
	Widget build(BuildContext context) {
		final pageRootWidget = onBuildUI(context);
		if (pageRootWidget is! Scaffold) {
			throw const WidgetNotScaffoldException();
		}
		
		return PageInterfaceQuery._(pageInterface, pageRootWidget);
	}
	
	/// 初始化回调方法
	void onInit() {
	
	}
	
	/// 销毁回调方法
	void onDestroy() {
	
	}
	
	/// 构造 PageInterface 回调
	PageInterface createPageInterface() => PageInterface._(this, PageBundle());
	
	/// 构造UI方法
	Widget onBuildUI(BuildContext context);
}

/// 页面基类状态
/// 无需自定义 PageInterface
abstract class BasePageState<T extends BasePage>
	extends BasePageWithInterfaceState<T, PageInterface> {
}

/// 用于获取 PageInterface 的遗传组件
class PageInterfaceQuery extends InheritedWidget {
	
	PageInterfaceQuery._(PageInterface interface, Widget child)
		: _interface = interface,
			super(child: child);
	
	final PageInterface _interface;
	
	@override
	bool updateShouldNotify(InheritedWidget oldWidget) {
		return oldWidget is PageInterfaceQuery &&
			oldWidget._interface == _interface;
	}
	
	/// 找到页面的 PageInterface
	static T find<T extends PageInterface>(BuildContext context) {
		PageInterfaceQuery widget = context.inheritFromWidgetOfExactType(
			PageInterfaceQuery);
		if (widget != null && widget._interface is T) {
			return widget._interface;
		}
		
		return null;
	}
	
	/// 找到并执行页面的 PageInterface
	static void withRun<T extends PageInterface>(BuildContext context,
		void runner(T)) {
		final interface = find<T>(context);
		if (interface != null) {
			runner(interface);
		}
	}
	
}

/// 页面数据集合
class PageBundle {
	Map<String, dynamic> _bundle;
	
	void saveData(String key, dynamic data) {
		_bundle ??= {};
		_bundle[key] = data;
	}
	
	T getData<T>(String key) {
		if(_bundle != null) {
			final data = _bundle[key];
			if(data != null && data is T) {
				return data;
			}
		}
		
		return null;
	}
}

/// 页面接口类
/// 封装了关于页面的操作
class PageInterface<T extends State> {
	PageInterface._(T state, PageBundle pageBundle) : _state = state {
		PageManager.getInstance().registerState(state);
	}
	
	T _state;
	final TaskPipeline taskPipeline = TaskPipeline();
	
	BroadcastManager _broadcastManager;
	BroadcastManager get broadcastManager => _broadcastManager ??= BroadcastManager();
	
	PageBundle _pageBundle;
	PageBundle get pageBundle => _pageBundle ??= PageBundle();
	
	void _destroy() {
		PageManager.getInstance().unregisterState(_state);
		taskPipeline.destroy();
		_state = null;
	}
	
	/// 代理执行
	/// 只有在 state 不为空并且处于挂载状态下才会执行回调
	void proxyRun(void runner(T state)) {
		if (_state != null && _state.mounted) {
			runner(_state);
		}
	}
	
	/// 添加页面
	void pushPage(BasePage page, {Object arguments}) {
		proxyRun((context) {
			PageManager.getInstance().pushTo((context) => page,
				pagePath: page.pageName, arguments: arguments);
		});
	}
	
	/// 替换页面
	void replacePage(BasePage page, {Object arguments}) {
		proxyRun((context) {
			PageManager.getInstance().replaceFirstTo((context) => page,
				pagePath: page.pageName, arguments: arguments);
		});
	}
	
	/// 关闭页面
	void popup() {
		proxyRun((context) {
			PageManager.getInstance().popup();
		});
	}
	
	/// 关闭页面，直到到达某个页面
	void popupUntil(String pagePath) {
		proxyRun((context) {
			PageManager.getInstance().popUntilPath(pagePath);
		});
	}
	
	/// 关闭页面，直到某个页面关闭时停止
	void popWithPath(String pagePath) {
		proxyRun((context) {
			PageManager.getInstance().popWithPath(pagePath);
		});
	}
}