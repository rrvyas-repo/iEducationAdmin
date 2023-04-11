import '../../libs.dart';

class StudentProfileWidgetScreen extends StatelessWidget {
  const StudentProfileWidgetScreen(
      {Key? key, required this.title, required this.value})
      : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: kTextBlackColor, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(value, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.13,
              child: const Divider(
                thickness: 1.0,
              ),
            ),
          ],
        ),
        const Icon(
          Icons.lock_outline,
          size: 10,
        ),
      ],
    );
  }
}
