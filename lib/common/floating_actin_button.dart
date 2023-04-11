import '../libs.dart';

Widget floatingActionButton(BuildContext context,
    {required void Function()? onPressed}) {
  return animation(
    context,
    seconds: 1000,
    verticalOffset: 100,
    child: FloatingActionButton(
      backgroundColor: kPrimaryColor,
      onPressed: onPressed,
      child: const Icon(Icons.add),
    ),
  );
}
