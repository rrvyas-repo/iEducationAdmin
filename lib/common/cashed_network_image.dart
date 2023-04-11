import '../libs.dart';

Widget cachedNetworkImage({
  required String imageUrl,
}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    imageBuilder: (context, imageProvider) => Container(
      height: MediaQuery.of(context).size.height * 0.28,
      width: MediaQuery.of(context).size.height * 0.24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.fill,
        ),
      ),
    ),
    placeholder: (context, url) => CircularProgressIndicator(
      color: kPrimaryColor,
    ),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}
