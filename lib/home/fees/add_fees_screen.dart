import '../../libs.dart';

class AddFeesScreen extends StatefulWidget {
  const AddFeesScreen({Key? key}) : super(key: key);

  @override
  State<AddFeesScreen> createState() => _AddFeesScreenState();
}

class _AddFeesScreenState extends State<AddFeesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Fees"),
      ),
    );
  }
}
