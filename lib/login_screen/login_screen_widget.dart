import '../libs.dart';

Widget textField({
  String lableText = '',
  TextEditingController? controller,
  IconData? prefixIcon,
  IconData? suffixIcon,
  bool obscureText = false,
  void Function()? onPressed,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 5,
    child: Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                lableText,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          TextFormField(
            obscureText: obscureText,
            controller: controller,
            cursorHeight: 30,
            cursorColor: kPrimaryColor,
            style: TextStyle(
              fontSize: 18.sp,
              color: kPrimaryColor,
              fontWeight: FontWeight.w800,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                prefixIcon,
                color: kPrimaryColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  suffixIcon,
                  color: kPrimaryColor,
                ),
                onPressed: onPressed,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
