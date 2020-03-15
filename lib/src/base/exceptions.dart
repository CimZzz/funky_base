
abstract class _BaseException {
    const _BaseException(this.message);
	final String message;
}

class WidgetNotScaffoldException extends _BaseException {
    const WidgetNotScaffoldException() : super('Page root widget must be Scaffold!');
}

class PageInterfaceNotMatchException extends _BaseException {
	const PageInterfaceNotMatchException(Type type) : super('Page interface must match type parameters! $type');
}