// ignore_for_file: use_build_context_synchronously

import '../../../libs.dart';

class SportsNoticeScreen extends StatefulWidget {
  const SportsNoticeScreen({Key? key}) : super(key: key);
  static const route = 'sports';

  @override
  State<SportsNoticeScreen> createState() => _SportsNoticeScreenState();
}

class _SportsNoticeScreenState extends State<SportsNoticeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool isLoading = false;

  Future<void> getData() async {
    isLoading = true;
    await SportsApi.fetchData();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, title: 'Sport Activity'),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : SportsApi.sportsDataList.isEmpty
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
                      itemCount: SportsApi.sportsDataList.length,
                      itemBuilder: (context, index) => Dismissible(
                        key:
                            Key(SportsApi.sportsDataList[index].key.toString()),
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
                                    await SportsApi.deleteData(
                                      key: SportsApi.sportsDataList[index].key
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
                                .moveToUpdateSportsScreen(
                                    SportsApi.sportsDataList[index].toJson())
                                .whenComplete(() async {
                              await getData();
                              setState(() {});
                            });
                          },
                          child: noticeDetailsCard(
                            context,
                            imageUrl: SportsApi.sportsDataList[index].image,
                            title: SportsApi.sportsDataList[index].title,
                            description:
                                SportsApi.sportsDataList[index].description,
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
              .moveToAddSportsScreen()
              .whenComplete(() async {
            await getData();
            setState(() {});
          });
        },
      ),
    );
  }
}
