import 'package:admin_app/home/attendence/attendence_widget.dart';
import 'package:admin_app/libs.dart';

class BCAAttendenceScreen extends StatefulWidget {
  const BCAAttendenceScreen({super.key});

  @override
  State<BCAAttendenceScreen> createState() => _BCAAttendenceScreenState();
}

class _BCAAttendenceScreenState extends State<BCAAttendenceScreen> {
  TextEditingController searchController = TextEditingController();
  String? selectedSemSemester = 'All';

  final List<String> semester = [
    'All',
    'SEM - 1',
    'SEM - 2',
    'SEM - 3',
    'SEM - 4',
    'SEM - 5',
    'SEM - 6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              searching(
                context,
                controller: searchController,
                items: semester
                    .map(
                      (semester) => DropdownMenuItem<String>(
                        value: semester,
                        child: Text(
                          semester,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                value: selectedSemSemester,
                onChanged: (value) {
                  setState(() {
                    selectedSemSemester = value as String;
                  });
                },
              ),

              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     SizedBox(
              //       height: MediaQuery.of(context).size.height * 0.15,
              //     ),
              //     Lottie.asset('assets/icons/Circle.json'),
              //   ],
              // ),
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (notification) {
                    notification.disallowIndicator();
                    return true;
                  },
                  child: animation(
                    context,
                    seconds: 500,
                    verticalOffset: 100,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Card(
                          color: kSecondaryColor,
                          elevation: 3,
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kPrimaryColor,
                                // borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            title: const Text(
                              'Student Name',
                            ),
                            subtitle: const Text(
                              'Semester',
                            ),
                            trailing: const Text('99%'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
