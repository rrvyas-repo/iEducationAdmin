import '../libs.dart';

Widget dropDownButton(
  BuildContext context, {
  String hintText = '',
  required List<DropdownMenuItem<Object>>? item,
  Object? value,
  void Function(Object?)? onChanged,
  String? Function(dynamic value)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
    child: DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: [
            Icon(
              Icons.list,
              size: 24,
              color: kPrimaryColor,
            ),
            const SizedBox(
              width: 13,
            ),
            Expanded(
              child: Text(
                hintText,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        buttonStyleData: ButtonStyleData(
          height: MediaQuery.of(context).size.height * 0.07,
          width: MediaQuery.of(context).size.width / 1,
          padding: const EdgeInsets.only(left: 10, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: kPrimaryColor,
            ),
            color: kSecondaryColor,
          ),
        ),
        iconStyleData: IconStyleData(
          iconEnabledColor: kPrimaryColor,
          iconDisabledColor: kPrimaryColor,
        ),
        items: item,
        value: value,
        onChanged: onChanged,
        dropdownStyleData: DropdownStyleData(
          padding: const EdgeInsets.only(left: 14, right: 14),
          // maxHeight: 288,
          scrollPadding: null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
      ),
    ),
  );
}
