// ignore_for_file: use_build_context_synchronously

import '../../../libs.dart';

class JobVacancyNotice extends StatefulWidget {
  const JobVacancyNotice({Key? key}) : super(key: key);
  static const route = 'jobVacancy';

  @override
  State<JobVacancyNotice> createState() => _JobVacancyNoticeState();
}

class _JobVacancyNoticeState extends State<JobVacancyNotice> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool isLoading = false;

  Future<void> getData() async {
    isLoading = true;
    await JobVacancyApi.fetchData();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, title: 'Jov Vacancy'),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : JobVacancyApi.jobVacancyDataList.isEmpty
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
                      itemCount: JobVacancyApi.jobVacancyDataList.length,
                      itemBuilder: (context, index) => Dismissible(
                        key: Key(JobVacancyApi.jobVacancyDataList[index]
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
                                    await JobVacancyApi.deleteData(
                                      key: JobVacancyApi
                                          .jobVacancyDataList[index].key
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
                                .moveToUpdateJobVacancyScreen(JobVacancyApi
                                    .jobVacancyDataList[index]
                                    .toJson())
                                .whenComplete(() async {
                              await getData();
                              setState(() {});
                            });
                          },
                          child: noticeDetailsCard(
                            context,
                            imageUrl:
                                JobVacancyApi.jobVacancyDataList[index].image,
                            title:
                                JobVacancyApi.jobVacancyDataList[index].title,
                            description: JobVacancyApi
                                .jobVacancyDataList[index].description,
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
              .moveToAddJobVacancyScreen()
              .whenComplete(() async {
            await getData();
            setState(() {});
          });
        },
      ),
    );
  }
}
