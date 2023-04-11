import '../../libs.dart';

class FeesScreen extends StatelessWidget {
  const FeesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, title: 'Fees'),

      body: animation(
        context,
        seconds: 1000,
        verticalOffset: 0.1,
        child: Center(
          child: Lottie.asset('assets/icons/Circle.json'),
        ),
      ),
      // body: ListView(
      //   padding: const EdgeInsets.all(15),
      //   physics: const BouncingScrollPhysics(),
      //   children: [
      //     FeeStudentField(
      //         title: "Bachelor of Computer Application", onPress: () {

      //     }),
      //     sizedBox,
      //     FeeStudentField(title: "Bachelor of Commerce", onPress: () {}),
      //     sizedBox,
      //     FeeStudentField(
      //         title: "Bachelor of Business Administration", onPress: () {}),
      //   ],
      // ),
      floatingActionButton: floatingActionButton(
        context,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddFeesScreen()));
        },
      ),
    );
  }
}

class FeeStudentField extends StatelessWidget {
  const FeeStudentField({Key? key, required this.title, required this.onPress})
      : super(key: key);

  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(kDefaultPadding),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kTextWhiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
