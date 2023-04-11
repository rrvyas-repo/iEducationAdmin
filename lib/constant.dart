import 'package:hexcolor/hexcolor.dart';

import '../../libs.dart';

// const Color kPrimaryColor = Color(0xFF345FB4);
// const Color kSecondaryColor = Color(0xFFF0F5FF);
Color kPrimaryColor = HexColor('#5b3e90');
Color kSecondaryColor = HexColor('#efecf4');
const Color kTextBlackColor = Color(0xFF313131);
const Color kTextWhiteColor = Color(0xFFFFFFFF);
const Color kContainerColor = Color(0xFF777777);
const Color kOtherColor = Color(0xFFF4F6F7);
const Color kTextLighterColor = Color(0xFFA5A5A5);
const Color kErrorBorderColor = Color(0xFFE74C3C);

const kDefaultPadding = 20.0;

const sizedBox = SizedBox(
  height: kDefaultPadding,
);

const kWidthSizedBox = SizedBox(
  width: kDefaultPadding,
);

const kHalfSizedBox = SizedBox(
  height: kDefaultPadding / 2,
);

const kHalfWidthSizedBox = SizedBox(
  width: kDefaultPadding / 2,
);

const kTopBorderRadius = BorderRadius.only(
  topRight: Radius.circular(kDefaultPadding),
  topLeft: Radius.circular(kDefaultPadding),
);

const kBottomSheetShape =
    RoundedRectangleBorder(borderRadius: kTopBorderRadius);

final kElevatButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: kPrimaryColor,
  fixedSize: const Size(80, 40),
);

const kTextContentPadding = EdgeInsets.all(12);

const String mobilePattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

const String emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

String gender = "Gender", male = "Male", female = "Female";
