import '../libs.dart';

Widget radioContainer(
  BuildContext context, {
  required dynamic maleValue,
  required dynamic femaleValue,
  required void Function(dynamic) femaleOnChanged,
  required void Function(dynamic) maleOnChanged,
}) {
  return Container(
    margin: const EdgeInsets.fromLTRB(10, 3, 10, 0),
    height: MediaQuery.of(context).size.height * 0.07,
    decoration: BoxDecoration(
      color: kSecondaryColor,
      border: Border.all(
        color: kPrimaryColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Icon(
          Icons.transgender,
          color: kPrimaryColor,
        ),
        const SizedBox(
          width: 10,
        ),
        const Text(
          'GENDER',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Radio(
          focusColor: kPrimaryColor,
          activeColor: kPrimaryColor,
          value: maleValue,
          groupValue: gender,
          onChanged: maleOnChanged,
        ),
        const Text(
          'Male',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Radio(
          focusColor: kPrimaryColor,
          activeColor: kPrimaryColor,
          value: femaleValue,
          groupValue: gender,
          onChanged: femaleOnChanged,
        ),
        const Text(
          'Female',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}

Widget studentContainer(
  BuildContext context, {
  String titleText = '',
  required Function()? onTap,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          color: kPrimaryColor,
        ),
        child: Center(
          child: Text(
            titleText,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
        ),
      ),
    ),
  );
}
