// ignore_for_file: use_build_context_synchronously

import '../../../libs.dart';

class CulturalFestivalNotice extends StatefulWidget {
  const CulturalFestivalNotice({Key? key}) : super(key: key);
  static const route = 'culturalFestival';
  @override
  State<CulturalFestivalNotice> createState() => _CulturalFestivalNoticeState();
}

class _CulturalFestivalNoticeState extends State<CulturalFestivalNotice> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool isLoading = false;

  Future<void> getData() async {
    isLoading = true;
    await CulturalFestivalApi.fetchData();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, title: 'Cultural Festival'),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : CulturalFestivalApi.culturalFestivalDataList.isEmpty
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
                          CulturalFestivalApi.culturalFestivalDataList.length,
                      itemBuilder: (context, index) => Dismissible(
                        key: Key(CulturalFestivalApi
                            .culturalFestivalDataList[index]
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
                                    await CulturalFestivalApi.deleteData(
                                      key: CulturalFestivalApi
                                          .culturalFestivalDataList[index].key
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
                                .moveToUpdateCulturalFestivalScreen(
                                    CulturalFestivalApi
                                        .culturalFestivalDataList[index]
                                        .toJson())
                                .whenComplete(() async {
                              await getData();
                              setState(() {});
                            });
                          },
                          child: noticeDetailsCard(
                            context,
                            imageUrl: CulturalFestivalApi
                                .culturalFestivalDataList[index].image,
                            title: CulturalFestivalApi
                                .culturalFestivalDataList[index].title,
                            description: CulturalFestivalApi
                                .culturalFestivalDataList[index].description,
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
              .moveToAddCulturalFestivalScreen()
              .whenComplete(() async {
            await getData();
            setState(() {});
          });
        },
      ),
    );
  }
}
