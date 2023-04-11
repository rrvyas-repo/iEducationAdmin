import '../../libs.dart';

Widget studentTextFormField({
  TextEditingController? textController,
  IconData? icon,
  String hintText = '',
  bool readOnly = false,
  TextInputType? keyboardType = TextInputType.text,
  String? Function(String?)? validator,
  bool obscureText = false,
  void Function()? onPressed,
  void Function(String)? onChanged,
  int? maxLines = 1,
  List<dynamic>? inputFormatters,
}) {
  return TextFormField(
    validator: validator,
    keyboardType: keyboardType,
    controller: textController,
    obscureText: obscureText,
    readOnly: readOnly,
    maxLines: maxLines,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(10),
      border: const OutlineInputBorder(),
      prefixIcon: Icon(
        icon,
        color: kPrimaryColor,
      ),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
    ),
  );
}
