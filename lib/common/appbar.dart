import '../libs.dart';

PreferredSizeWidget appbar(
  BuildContext context, {
  String title = '',
  Function()? onPressed,
  IconData? actionIcon,
}) {
  return AppBar(
    centerTitle: true,
    title: animation(
      context,
      seconds: 500,
      horizontalOffset: 100,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    ),
    elevation: 0,
    backgroundColor: kPrimaryColor,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: animation(
        context,
        seconds: 500,
        horizontalOffset: 100,
        child: const Icon(
          Icons.arrow_back_ios,
        ),
      ),
    ),
    actions: [
      animation(
        context,
        seconds: 500,
        horizontalOffset: 100,
        child: IconButton(
          onPressed: onPressed,
          color: Colors.white,
          icon: Icon(actionIcon),
        ),
      ),
    ],
  );
}
