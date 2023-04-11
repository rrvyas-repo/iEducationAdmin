import '../../libs.dart';

class StaffProfileScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  const StaffProfileScreen({Key? key, required this.args}) : super(key: key);
  static const route = 'staffProfileScreen';

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {
  bool isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    debugPrint("in data  =========>");
    isLoading = true;
    await StaffListApi.fetchData();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(
        context,
        title: "Staff Profile",
        actionIcon: Icons.edit,
        onPressed: () async {
          await AppNavigation.shared.moveToUpdateStaffList(
              {'index': widget.args['index']}).whenComplete(() async {
            await StaffListApi.fetchData();
            setState(() {});
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return true;
          },
          child: isLoading
              ?  Center(
                  child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ))
              : animation(
                  context,
                  seconds: 1000,
                  verticalOffset: 0.1,
                  child: ListView(
                    children: [
                      Center(
                        child: cachedNetworkImage(
                            imageUrl: StaffListApi
                                .staffDataList[widget.args['index']].image),
                      ),
                      sizedBox,
                      StaffProfileWidgetScreen(
                          title: "Name",
                          value: StaffListApi
                              .staffDataList[widget.args['index']].name),
                      StaffProfileWidgetScreen(
                          title: "Email ID",
                          value: StaffListApi
                              .staffDataList[widget.args['index']].email),
                      StaffProfileWidgetScreen(
                          title: "Contact No",
                          value: StaffListApi
                              .staffDataList[widget.args['index']].phoneNo),
                      StaffProfileWidgetScreen(
                          title: "Post",
                          value: StaffListApi
                              .staffDataList[widget.args['index']].post),
                      StaffProfileWidgetScreen(
                          title: "Subject",
                          value: StaffListApi
                              .staffDataList[widget.args['index']].subject),
                      StaffProfileWidgetScreen(
                          title: "Experience",
                          value: StaffListApi
                              .staffDataList[widget.args['index']].experience),
                      StaffProfileWidgetScreen(
                          title: "Degree",
                          value: StaffListApi
                              .staffDataList[widget.args['index']].degree),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
