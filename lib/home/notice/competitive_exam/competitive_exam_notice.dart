// ignore_for_file: use_build_context_synchronously

import '../../../libs.dart';

class CompetitiveExamNotice extends StatefulWidget {
  const CompetitiveExamNotice({Key? key}) : super(key: key);
  static const route = 'competitiveExam';

  @override
  State<CompetitiveExamNotice> createState() => CompetitiveExamNoticeState();
}

class CompetitiveExamNoticeState extends State<CompetitiveExamNotice> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool isLoading = false;

  Future<void> getData() async {
    isLoading = true;
    await CompetitiveExamApi.fetchData();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, title: 'Compatitive Exam'),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : CompetitiveExamApi.competitiveExamDataList.isEmpty
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
                          CompetitiveExamApi.competitiveExamDataList.length,
                      itemBuilder: (context, index) => Dismissible(
                        key: Key(CompetitiveExamApi
                            .competitiveExamDataList[index]
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
                                    await CompetitiveExamApi.deleteData(
                                      key: CompetitiveExamApi
                                          .competitiveExamDataList[index].key
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
                                .moveToUpdateCompatitiveExamScreen(
                                    CompetitiveExamApi
                                        .competitiveExamDataList[index]
                                        .toJson())
                                .whenComplete(() async {
                              await getData();
                              setState(() {});
                            });
                          },
                          child: noticeDetailsCard(
                            context,
                            imageUrl: CompetitiveExamApi
                                .competitiveExamDataList[index].image,
                            title: CompetitiveExamApi
                                .competitiveExamDataList[index].title,
                            description: CompetitiveExamApi
                                .competitiveExamDataList[index].description,
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
              .moveToAddCompatitiveExamScreen()
              .whenComplete(() async {
            await getData();
            setState(() {});
          });
        },
      ),
    );
  }
}
