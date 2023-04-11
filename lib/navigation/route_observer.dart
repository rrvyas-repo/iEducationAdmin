import '../../libs.dart';

final routeObserver = _AppRouteObserver();

class _AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  // static final Logger log = Logger("RouteObserver");

  void _onRouteChanged(PageRoute<dynamic> route) {
    final routeName = route.settings.name;

    // log.info("on route changed: $routeName");

    if (routeName != null) {
//      analytics.setCurrentScreen(screenName: routeName);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    if (route is PageRoute && previousRoute is PageRoute) {
      _onRouteChanged(previousRoute);
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    if (route is PageRoute) {
      _onRouteChanged(route);
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (newRoute is PageRoute) {
      _onRouteChanged(newRoute);
    }
  }
}
