import '../../libs.dart';

class SlideRoute extends PageRouteBuilder {
  final Widget enterPage;
  final AxisDirection direction;
  static AnimationController? animationController;
  SlideRoute({required this.enterPage, this.direction = AxisDirection.left})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            getBeginOffset() {
              switch (direction) {
                case AxisDirection.up:
                  return const Offset(0, 1);
                case AxisDirection.down:
                  return const Offset(0, -1);
                case AxisDirection.left:
                  return const Offset(1, 0);
                case AxisDirection.right:
                  return const Offset(-1, 0);
              }
            }

            return Stack(
              children: <Widget>[
                SlideTransition(
                  position: Tween<Offset>(
                    begin: getBeginOffset(),
                    end: Offset.zero,
                  ).animate(animation),
                  child: enterPage,
                )
              ],
            );
          },
        );
}
