import '../libs.dart';

Widget processIndicator(BuildContext context) {
  return Container(
    alignment: Alignment.center,
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: Colors.white30.withOpacity(0.7),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: kPrimaryColor,
          backgroundColor: Colors.white.withOpacity(0.3),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
        Text(
          'Please Wait...',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
        )
      ],
    ),
  );
}
