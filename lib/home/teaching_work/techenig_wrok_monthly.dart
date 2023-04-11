import '../../libs.dart';

class MonthlyTeachingWork extends StatefulWidget {
  const MonthlyTeachingWork({Key? key}) : super(key: key);

  @override
  State<MonthlyTeachingWork> createState() => _MonthlyTeachingWorkState();
}

class _MonthlyTeachingWorkState extends State<MonthlyTeachingWork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monthly Teaching Work"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WorkDateCard(lecture: "2", lDate: "1/2/2023", onPress: () {}),
                WorkDateCard(lecture: "3", lDate: "2/2/2023", onPress: () {}),
                WorkDateCard(lecture: "1", lDate: "3/2/2023", onPress: () {}),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WorkDateCard extends StatelessWidget {
  const WorkDateCard(
      {Key? key,
      required this.lecture,
      required this.lDate,
      required this.onPress})
      : super(key: key);
  final String lecture;
  final String lDate;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.12,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              lecture,
              style: const TextStyle(
                color: kOtherColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              lDate,
              // ignore: prefer_const_constructors
              style: TextStyle(
                color: kOtherColor,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
