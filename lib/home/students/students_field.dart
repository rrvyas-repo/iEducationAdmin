import '../../libs.dart';

class StudentsFieldScreen extends StatefulWidget {
  const StudentsFieldScreen({Key? key}) : super(key: key);
  static const String route = 'studentsField';
  @override
  State<StudentsFieldScreen> createState() => _StudentsFieldScreenState();
}

class _StudentsFieldScreenState extends State<StudentsFieldScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, title: 'Student'),
      body: Column(
        children: [
          animation(
            context,
            seconds: 1000,
            verticalOffset: -50,
            child: studentContainer(
              context,
              titleText: 'Bachelor of Computer Application',
              onTap: () async {
                StudentDataApi.keys = "BCA";
                await StudentDataApi.fetchData();
                if (!mounted) return;
                AppNavigation.shared.moveToStudentList(
                    {'stream': 'BCA Student List', 'key': StudentDataApi.keys});
              },
            ),
          ),
          animation(
            context,
            seconds: 666,
            verticalOffset: -50,
            child: studentContainer(
              context,
              titleText: "Bachelor of Commerce",
              onTap: () async {
                StudentDataApi.keys = "BCOM";
                await StudentDataApi.fetchData();
                if (!mounted) return;
                AppNavigation.shared.moveToStudentList({
                  'stream': 'BCOM Student List',
                  'key': StudentDataApi.keys
                });
              },
            ),
          ),
          animation(
            context,
            seconds: 400,
            verticalOffset: -50,
            child: studentContainer(
              context,
              titleText: "Bachelor of Business Administration",
              onTap: () async {
                StudentDataApi.keys = "BBA";
                await StudentDataApi.fetchData();
                if (!mounted) return;
                AppNavigation.shared.moveToStudentList(
                    {'stream': 'BBA Student List', 'key': StudentDataApi.keys});
              },
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton(
        context,
        onPressed: () {
          AppNavigation.shared.movetoAddStudent();
          setState(() {});
        },
      ),
    );
  }
}
