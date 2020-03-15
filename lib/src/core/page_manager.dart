
import 'package:flutter/material.dart';
import 'package:tea/tea.dart';


/// 页面管理类
///
/// 用于导航页面的类
class PageManager {
	/// 单例模式
	static PageManager _instance;
	
	final List<State> _statsList = [];
	State get _topState {
		if(_statsList.isEmpty) {
			return null;
		}
		int lastIdx = _statsList.length - 1;
		State topState = _statsList[lastIdx];
		while(topState != null) {
			if(!topState.mounted || topState.context == null) {
				_statsList.removeLast();
			}
			else {
				return topState;
			}
			
			lastIdx --;
			if(lastIdx < 0) {
				return null;
			}
			
			topState = _statsList[lastIdx];
		}
		
		return null;
	}
	
	PageManager._();
	
	factory PageManager.getInstance() {
		return _instance ??= PageManager._();
	}
	
	void _proxyRun(void runner(BuildContext context)) {
		final topState = _topState;
		if(topState != null) {
			runner(topState.context);
		}
	}
	
	void registerState(State state) {
		_statsList.add(state);
	}
	
	void unregisterState(State state) {
		_statsList.remove(state);
	}
	
	void pushTo(WidgetBuilder builder, { String pagePath, Object arguments }) {
		_proxyRun((context) {
			Navigator.push(context, MaterialPageRoute(
				builder: builder,
				settings: RouteSettings(
					name: pagePath,
					arguments: arguments
				)
			));
		});
	}
	
	void pushToPath(String pagePath, { Object arguments }) {
		_proxyRun((context) {
			Navigator.pushNamed(context, pagePath, arguments: arguments);
		});
	}
	
	void replaceFirstTo(WidgetBuilder builder, { String pagePath, Object arguments }) {
		_proxyRun((context) {
			Navigator.pushReplacement(context, MaterialPageRoute(
				builder: builder,
				settings: RouteSettings(
					name: pagePath,
					arguments: arguments
				)
			));
		});
	}
	
	void replaceFirstToPath(String pagePath, { Object arguments }) {
		_proxyRun((context) {
			Navigator.pushReplacementNamed(context, pagePath, arguments: arguments);
		});
	}
	
	void popup() {
		_proxyRun((context) {
			Navigator.pop(context);
		});
	}
	
	void popUntilPath(String pagePath) {
		_proxyRun((context) {
			Navigator.popUntil(context, (route) {
				return route.settings.name == pagePath;
			});
		});
	}
	
	void popWithPath(String pagePath) {
		_proxyRun((context) {
			bool isFound = false;
			Navigator.popUntil(context, (route) {
				if(isFound) {
					return route.settings.name != pagePath;
				}
				else {
					bool result = route.settings.name == pagePath;
					if(result) {
						isFound = true;
						return false;
					}
					else {
						return false;
					}
				}
			});
		});
	}
}