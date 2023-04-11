// ignore_for_file: use_build_context_synchronously

import '../../../libs.dart';

class CollegeActivityNotice extends StatefulWidget {
  const CollegeActivityNotice({Key? key}) : super(key: key);
  static const route = 'collegeActivity';
  @override
  State<CollegeActivityNotice> createState() => _CollegeActivityNoticeState();
}

class _CollegeActivityNoticeState extends State<CollegeActivityNotice> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool isLoading = false;

  Future<void> getData() async {
    isLoading = true;
    await CollegeActivityApi.fetchData();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, title: 'College Activity'),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : CollegeActivityApi.collegeActivityDataList.isEmpty
              ? Center(child: Lottie.asset('assets/icons/Circle.json'))
              : NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (notification) {
                    notification.disallowIndicator();
                    return true;
                  },
                  child: animation(
                    context,
                    seconds: 1000,
                    verticalOffset: 0.1,
                    child: ListView.builder(
                      itemCount:
                          CollegeActivityApi.collegeActivityDataList.length,
                      itemBuilder: (context, index) => Dismissible(
                        key: Key(CollegeActivityApi
                            .collegeActivityDataList[index]
                            .toString()),
                        confirmDismiss: (direction) {
                          return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: const Text('Sure You Want To Remove?'),
                              actions: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    await CollegeActivityApi.deleteData(
                                      key: CollegeActivityApi
                                          .collegeActivityDataList[index].key
                                          .toString(),
                                    );
                                    Navigator.pop(context);
                                    await getData();
                                  },
                                  child: const Text('Ok'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: GestureDetector(
                          onTap: () async {
                            await AppNavigation.shared
                                .moveToUpdateCollegeActivityScreen(
                                    CollegeActivityApi
                                        .collegeActivityDataList[index]
                                        .toJson())
                                .whenComplete(() async {
                              await getData();
                              setState(() {});
                            });
                          },
                          child: noticeDetailsCard(
                            context,
                            imageUrl: CollegeActivityApi
                                .collegeActivityDataList[index].image,
                            title: CollegeActivityApi
                                .collegeActivityDataList[index].title,
                            description: CollegeActivityApi
                                .collegeActivityDataList[index].description,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
      floatingActionButton: floatingActionButton(
        context,
        onPressed: () async {
          await AppNavigation.shared
              .moveToAddCollegeActivityScreen()
              .whenComplete(() async {
            await getData();
            setState(() {});
          });
        },
      ),
    );
  }
}
