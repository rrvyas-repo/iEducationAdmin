// ignore_for_file: use_build_context_synchronously

import '../../libs.dart';

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({Key? key}) : super(key: key);
  static const route = 'staffListScreen';

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool isLoading = false;

  Future<void> getData() async {
    isLoading = true;
    await StaffListApi.fetchData();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, title: 'Staff List'),
      body: isLoading
          ?  Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : StaffListApi.staffDataList.isEmpty
              ? Center(
                  child: Lottie.asset('assets/icons/Circle.json'),
                )
              : NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (notification) {
                    notification.disallowIndicator();
                    return true;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: animation(
                      context,
                      seconds: 1000,
                      verticalOffset: -50,
                      child: ListView.builder(
                        itemCount: StaffListApi.staffDataList.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(
                                StaffListApi.staffDataList[index].toString()),
                            confirmDismiss: (direction) {
                              return showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: const Text(
                                    'Sure You Want To Remove?',
                                  ),
                                  actions: [
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        await StaffListApi.deleteData(
                                          key: StaffListApi
                                              .staffDataList[index].key
                                              .toString(),
                                        );
                                        Navigator.pop(context);
                                        await getData();
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                ),
                                barrierDismissible: false,
                              );
                            },
                            child: GestureDetector(
                              onTap: (() async {
                                await AppNavigation.shared
                                    .moveToStaffProfile({'index': index});
                              }),
                              child: Card(
                                elevation: 5,
                                child: ListTile(
                                  leading: CachedNetworkImage(
                                    imageUrl: StaffListApi
                                        .staffDataList[index].image
                                        .toString(),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 50,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                         CircularProgressIndicator(
                                      color: kPrimaryColor,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  title: Text(
                                    StaffListApi.staffDataList[index].name,
                                  ),
                                  subtitle: Text(
                                    StaffListApi.staffDataList[index].degree,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
      floatingActionButton: floatingActionButton(
        context,
        onPressed: () async {
          await AppNavigation.shared
              .moveToAddStaffList()
              .whenComplete(() async {
            await getData();
            setState(() {});
          });
        },
      ),
    );
  }
}
