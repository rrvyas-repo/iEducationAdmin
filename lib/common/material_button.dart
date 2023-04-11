import '../libs.dart';

Widget materialButton(
  BuildContext context, {
  Function()? onPressed,
  String buttonText = '',
}) {
  return MaterialButton(
    onPressed: onPressed,
    minWidth: MediaQuery.of(context).size.width * 0.5,
    height: MediaQuery.of(context).size.height * 0.065,
    color: kPrimaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      buttonText,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );
}
