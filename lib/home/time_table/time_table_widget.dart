import '../../libs.dart';

class TimeTableColumn extends StatelessWidget {
  const TimeTableColumn({Key? key, required this.title, required this.value})
      : super(key: key);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.002,
        ),
        Text(value, style: Theme.of(context).textTheme.titleSmall),
        const Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
