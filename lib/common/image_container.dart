import '../libs.dart';

Widget imageContainer(
  BuildContext context, {
  required ImageProvider<Object> image,
}) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.28,
    width: MediaQuery.of(context).size.height * 0.24,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: kPrimaryColor),
      image: DecorationImage(
        image: image,
        fit: BoxFit.cover,
      ),
    ),
  );
}
