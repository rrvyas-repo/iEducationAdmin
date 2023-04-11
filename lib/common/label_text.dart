import '../libs.dart';

Widget labelText({String text = ''}) {
  return Padding(
    padding: const EdgeInsets.only(top: 15, left: 15),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
