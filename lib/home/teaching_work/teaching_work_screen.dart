import '../../libs.dart';

class TeachingWorkScreen extends StatelessWidget {
  const TeachingWorkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, title: 'Teaching Work'),
      body: animation(
        context,
        seconds: 500,
        horizontalOffset: 0.1,
        child: Center(
          child: Lottie.asset('assets/icons/Circle.json'),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: kPrimaryColor,
      //   onPressed: () {},
      //   label: Text("Add"),
      //   icon: Icon(Icons.add),
      // ),
      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Column(
      //     children: [
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           WorkMonthCard(
      //               date: "12",
      //               month: "Jan",
      //               onPress: () {

      //                 Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) => const MonthlyTeachingWork()));
      //               }),
      //           WorkMonthCard(date: "10", month: "Feb", onPress: () {}),
      //           WorkMonthCard(date: "11", month: "Mar", onPress: () {}),
      //         ],
      //       ),
      //     ],
      //   ),
      // )
    );
  }
}

class WorkMonthCard extends StatelessWidget {
  const WorkMonthCard(
      {Key? key,
      required this.date,
      required this.month,
      required this.onPress})
      : super(key: key);

  final String date;
  final String month;
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
              date,
              style: const TextStyle(
                color: kOtherColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              month,
              style: const TextStyle(
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
