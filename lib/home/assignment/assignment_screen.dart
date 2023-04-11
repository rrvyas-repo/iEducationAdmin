// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:admin_app/database/network/network_api.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:share_plus/share_plus.dart';

import '../../libs.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({Key? key}) : super(key: key);
  static const route = 'assignment';
  @override
  State<AssignmentScreen> createState() => AssignmentScreenState();
}

class AssignmentScreenState extends State<AssignmentScreen> {
  bool isLoading = false;

  Future<void> getData() async {
    isLoading = true;
    await AssignmentApi.fetchData();
    isLoading = false;
    setState(() {});
  }

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    getData();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  List indexs = [0, 0];
  bool isRowView = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, title: 'Assignment'),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : AssignmentApi.assignmentDataList.isEmpty
              ? Center(
                  child: Lottie.asset('assets/icons/Circle.json'),
                )
              : NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (notification) {
                    notification.disallowIndicator();
                    return true;
                  },
                  child: animation(
                    context,
                    seconds: 1000,
                    verticalOffset: -100,
                    child: ListView.builder(
                      itemCount: AssignmentApi.assignmentDataList.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) => Dismissible(
                        key: Key(
                          AssignmentApi.assignmentDataList[index].key
                              .toString(),
                        ),
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
                                    await AssignmentApi.deleteData(
                                      key: AssignmentApi
                                          .assignmentDataList[index].key
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
                          onTap: () {
                            indexs.removeAt(0);
                            indexs.insert(1, index);
                            setState(() {
                              AssignmentApi.assignmentDataList[indexs[0]]
                                  .isShowButton = false;
                              AssignmentApi.assignmentDataList[index]
                                  .isShowButton = AssignmentApi
                                          .assignmentDataList[index]
                                          .isShowButton ==
                                      false
                                  ? true
                                  : false;
                            });
                          },
                          child: Card(
                            color: kSecondaryColor,
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.695,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AssignmentApi
                                                .assignmentDataList[index]
                                                .subjectName,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                          Text(
                                            AssignmentApi
                                                .assignmentDataList[index]
                                                .noOfAssignment,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            '${AssignmentApi.assignmentDataList[index].stream} ${AssignmentApi.assignmentDataList[index].semester}',
                                          ),
                                          Text(
                                            '${AssignmentApi.assignmentDataList[index].date}  ${AssignmentApi.assignmentDataList[index].time}',
                                          ),
                                          Text(
                                              "${AssignmentApi.assignmentDataList[index].fileSize} MB"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  AssignmentApi.assignmentDataList[index]
                                          .isShowButton
                                      ? animation(
                                          context,
                                          seconds: 400,
                                          verticalOffset: 50,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Divider(
                                                color: kPrimaryColor,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      final List<Directory>?
                                                          downloadsDir =
                                                          await getExternalStorageDirectories();
                                                      await FlutterDownloader
                                                          .enqueue(
                                                        saveInPublicStorage:
                                                            true,
                                                        url: AssignmentApi
                                                            .assignmentDataList[
                                                                index]
                                                            .fileName,
                                                        headers: {},
                                                        savedDir:
                                                            downloadsDir![0]
                                                                .path,
                                                        showNotification: true,
                                                        openFileFromNotification:
                                                            true,
                                                      );
                                                    },
                                                    child: Text(
                                                      'Download',
                                                      style: TextStyle(
                                                          color: kPrimaryColor),
                                                    ),
                                                  ),
                                                  Lottie.asset(
                                                    'assets/icons/download.json',
                                                    fit: BoxFit.cover,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.037,
                                                  ),
                                                  SizedBox(
                                                    height: 0.05.sh,
                                                    child: VerticalDivider(
                                                      color: kPrimaryColor,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      viewPdfs(
                                                        context,
                                                        pdfUrl: AssignmentApi
                                                            .assignmentDataList[
                                                                index]
                                                            .fileName,
                                                        title:
                                                            '${AssignmentApi.assignmentDataList[index].subjectName} (${AssignmentApi.assignmentDataList[index].semester})',
                                                      );
                                                    },
                                                    child: Text(
                                                      'View',
                                                      style: TextStyle(
                                                          color: kPrimaryColor),
                                                    ),
                                                  ),
                                                  Lottie.asset(
                                                    'assets/icons/eye.json',
                                                    fit: BoxFit.scaleDown,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.027,
                                                  ),
                                                  SizedBox(
                                                    height: 0.05.sh,
                                                    child: VerticalDivider(
                                                      color: kPrimaryColor,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      String longUrl =
                                                          AssignmentApi
                                                              .assignmentDataList[
                                                                  index]
                                                              .fileName;
                                                      String shortUrl =
                                                          await NetworkApi
                                                              .getShortLink(
                                                        longUrl,
                                                      );
                                                      await Share.share(
                                                        shortUrl,
                                                      );
                                                    },
                                                    child: Text(
                                                      'Share',
                                                      style: TextStyle(
                                                          color: kPrimaryColor),
                                                    ),
                                                  ),
                                                  Lottie.asset(
                                                    'assets/icons/share.json',
                                                    fit: BoxFit.scaleDown,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.017,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
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
              .moveToAddAssignmentScreen()
              .whenComplete(() async {
            await getData();
            setState(() {});
          });
        },
      ),
    );
  }
}
