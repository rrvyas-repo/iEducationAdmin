import '../../libs.dart';

Widget searching(
  BuildContext context, {
  TextEditingController? controller,
  required List<DropdownMenuItem<Object>>? items,
  Object? value,
  void Function(Object?)? onChanged,
}) {
  return Row(
    children: [
      Expanded(
        child: TextField(
          controller: controller,
          cursorHeight: 24,
          cursorColor: kPrimaryColor,
          style: TextStyle(
            fontSize: 16.sp,
            color: kPrimaryColor,
            fontWeight: FontWeight.w800,
          ),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: kPrimaryColor,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: kPrimaryColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: kPrimaryColor,
              ),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          buttonStyleData: ButtonStyleData(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.3,
            padding: const EdgeInsets.only(left: 10, right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: kPrimaryColor,
              ),
              // color: kSecondaryColor,
            ),
          ),
          iconStyleData: IconStyleData(
            iconEnabledColor: kPrimaryColor,
            iconDisabledColor: kPrimaryColor,
          ),
          items: items,
          value: value,
          onChanged: onChanged,
          dropdownStyleData: DropdownStyleData(
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
    ],
  );
}
