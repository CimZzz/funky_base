import 'package:tea/tea.dart';

class _TeaBag<T> extends TeaBag<T> {
	_TeaBag(this.dataSource);
	
	final GlobalDataSource<T> dataSource;
	
	@override
	Future<T> boilWater() {
		return dataSource.onFetchData();
	}
	
	@override
	TeaCup<T> dirtyTea(e, StackTrace stackTrace) {
		final errorData = dataSource.onErrorData(e, stackTrace);
		if (errorData != null) {
			return TeaCup(isQualified: true, tea: errorData);
		}
		return super.dirtyTea(e, stackTrace);
	}
	
	@override
	void tryStop() {
		dataSource.onInterrupt();
	}
}

/// 全局数据源
/// 如果在应用中存在一些数据时全局共享的话，可以使用该类来进行数据获取与管理
abstract class GlobalDataSource<T> {
	TeaPot<T> _teaPot;
	
	Future<T> fetchData({bool forceRetry = false}) {
		_teaPot ??= Tea.prepareTea(_TeaBag(this));
		return _teaPot.drink(remake: forceRetry).then((TeaCup<T> teaCup) {
			if (teaCup.isQualified) {
				return teaCup.tea;
			}
			return null;
		});
	}
	
	Future<T> onFetchData() {
		return null;
	}
	
	T onErrorData(dynamic e, StackTrace stackTrace) {
		return null;
	}
	
	void onInterrupt() {
	
	}
}