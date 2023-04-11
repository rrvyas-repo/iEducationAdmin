// ignore_for_file: use_build_context_synchronously

import '../../../libs.dart';

class GeneralNotice extends StatefulWidget {
  const GeneralNotice({Key? key}) : super(key: key);
  static const route = 'general';

  @override
  State<GeneralNotice> createState() => _GeneralNoticeState();
}

class _GeneralNoticeState extends State<GeneralNotice> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool isLoading = false;

  Future<void> getData() async {
    isLoading = true;
    await GeneralApi.fetchData();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, title: 'General'),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : GeneralApi.generalDataList.isEmpty
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
                      itemCount: GeneralApi.generalDataList.length,
                      itemBuilder: (context, index) => Dismissible(
                        key: Key(GeneralApi.generalDataList[index].toString()),
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
                                    await GeneralApi.deleteData(
                                      key: GeneralApi.generalDataList[index].key
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
                                .moveToUpdateGeneralScreen(
                                    GeneralApi.generalDataList[index].toJson())
                                .whenComplete(() async {
                              await getData();
                              setState(() {});
                            });
                          },
                          child: noticeDetailsCard(
                            context,
                            imageUrl: GeneralApi.generalDataList[index].image,
                            title: GeneralApi.generalDataList[index].title,
                            description:
                                GeneralApi.generalDataList[index].description,
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
              .moveToAddGeneralScreen()
              .whenComplete(() async {
            await getData();
            setState(() {});
          });
        },
      ),
    );
  }
}
