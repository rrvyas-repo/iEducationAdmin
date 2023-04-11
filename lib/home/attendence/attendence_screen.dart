import 'package:admin_app/home/attendence/bba_attendence.dart';
import 'package:admin_app/home/attendence/bca_attendence.dart';
import 'package:admin_app/home/attendence/bcom_attendence.dart';

import '../../libs.dart';

class AttendenceScreen extends StatefulWidget {
  const AttendenceScreen({Key? key}) : super(key: key);

  @override
  State<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends State<AttendenceScreen>
    with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Attendence',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: animation(
            context,
            seconds: 500,
            horizontalOffset: 100,
            child: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImage(
                    data: DateTime.now().toString(),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(10),
                    version: QrVersions.auto,
                    size: 250.0,
                  ),
                ],
              ),
            ),
            color: Colors.white,
            icon: const Icon(Icons.qr_code_2_outlined),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 2.5,
          indicatorColor: Colors.white,
          tabs: const [
            Text(
              'BCA',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'BBA',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'BCOM',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          BCAAttendenceScreen(),
          BBAAttendenceScreen(),
          BCOMAttendenceScreen(),
        ],
      ),
    );
  }
}
