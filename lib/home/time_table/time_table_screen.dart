// ignore_for_file: use_build_context_synchronously

import '../../libs.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({Key? key}) : super(key: key);
  static const route = 'timeTableScreen';
  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  bool loading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    loading = true;
    await TimeTableApi.fetchData();
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, title: 'TimeTable'),
      body: SafeArea(
        child: loading
            ?  Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              )
            : TimeTableApi.timeTableDataList.isEmpty
                ? Center(
                    child: Lottie.asset(
                      'assets/icons/Circle.json',
                    ),
                  )
                : NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (notification) {
                      notification.disallowIndicator();
                      return true;
                    },
                    child: animation(
                      context,
                      seconds: 600,
                      horizontalOffset: 100,
                      child: ListView.builder(
                        itemCount: TimeTableApi.timeTableDataList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  color: kSecondaryColor,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  child: Text(
                                    TimeTableApi
                                        .timeTableDataList[index].lectureDate,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                kHalfSizedBox,
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: TimeTableApi
                                      .timeTableDataList[index].tb.length,
                                  itemBuilder: (context, index1) {
                                    return GestureDetector(
                                      onTap: () {
                                        AppNavigation.shared
                                            .moveToUpdateTimeTableScreen(
                                                TimeTableApi
                                                    .timeTableDataList[index]
                                                    .tb[index1]
                                                    .toJson())
                                            .whenComplete(() async {
                                          getData();
                                          setState(() {});
                                        });
                                      },
                                      child: Dismissible(
                                        key: Key(TimeTableApi
                                            .timeTableDataList[index]
                                            .tb[index1]
                                            .key
                                            .toString()),
                                        confirmDismiss: (direction) {
                                          return showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content: const Text(
                                                  'Sure You Want To Remove?'),
                                              actions: [
                                                MaterialButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                MaterialButton(
                                                  onPressed: () async {
                                                    await TimeTableApi
                                                        .deleteTimeTableData(
                                                      key: TimeTableApi
                                                          .timeTableDataList[
                                                              index]
                                                          .tb[index1]
                                                          .key
                                                          .toString(),
                                                      child: TimeTableApi
                                                          .timeTableDataList[
                                                              index]
                                                          .lectureDate,
                                                    );
                                                    Navigator.pop(context);
                                                    getData();
                                                  },
                                                  child: const Text('Ok'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Card(
                                          elevation: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                TimeTableColumn(
                                                  title: "Subject Name",
                                                  value: TimeTableApi
                                                      .timeTableDataList[index]
                                                      .tb[index1]
                                                      .lectureName,
                                                ),
                                                TimeTableColumn(
                                                  title: "Stream",
                                                  value: TimeTableApi
                                                      .timeTableDataList[index]
                                                      .tb[index1]
                                                      .stream,
                                                ),
                                                TimeTableColumn(
                                                  title: "Semester",
                                                  value: TimeTableApi
                                                      .timeTableDataList[index]
                                                      .tb[index1]
                                                      .semester,
                                                ),
                                                TimeTableColumn(
                                                  title: "Lecture Start Time",
                                                  value: TimeTableApi
                                                      .timeTableDataList[index]
                                                      .tb[index1]
                                                      .lectureStartTime,
                                                ),
                                                TimeTableColumn(
                                                  title: "Lecture End Time",
                                                  value: TimeTableApi
                                                      .timeTableDataList[index]
                                                      .tb[index1]
                                                      .lectureEndTime,
                                                ),
                                                TimeTableColumn(
                                                  title: "Lecture Date",
                                                  value: TimeTableApi
                                                      .timeTableDataList[index]
                                                      .tb[index1]
                                                      .lectureDate,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
      ),
      floatingActionButton: floatingActionButton(
        context,
        onPressed: () {
          AppNavigation.shared.movetoAddTimeTableScreen().whenComplete(() {
            getData();
            setState(() {});
          });
        },
      ),
    );
  }
}
