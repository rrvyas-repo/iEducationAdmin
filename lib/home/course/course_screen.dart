// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:admin_app/database/network/network_api.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../../libs.dart';
import 'package:share_plus/share_plus.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);
  static const route = 'courseScreen';
  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  bool isLoading = false;

  Future<void> getData() async {
    isLoading = true;
    await CourseApi.fetchData();
    isLoading = false;
    setState(() {});
  }

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, title: 'Course'),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : CourseApi.courseDataList.isEmpty
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
                      itemCount: CourseApi.courseDataList.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(
                            CourseApi.courseDataList[index].key.toString(),
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
                                      await CourseApi.deleteData(
                                        key: CourseApi.courseDataList[index].key
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
                          child: materialCard(
                            context,
                            isRowView:
                                CourseApi.courseDataList[index].isShowButton,
                            onTap: () {
                              indexs.removeAt(0);
                              indexs.insert(1, index);
                              setState(() {
                                CourseApi.courseDataList[indexs[0]]
                                    .isShowButton = false;
                                CourseApi.courseDataList[index].isShowButton =
                                    CourseApi.courseDataList[index]
                                                .isShowButton ==
                                            false
                                        ? true
                                        : false;
                              });
                            },
                            subjectName:
                                CourseApi.courseDataList[index].subjectName,
                            stream:
                                '${CourseApi.courseDataList[index].stream} ${CourseApi.courseDataList[index].semester}',
                            dateTime:
                                '${CourseApi.courseDataList[index].date}  ${CourseApi.courseDataList[index].time}',
                            fileSize: CourseApi.courseDataList[index].fileSize,
                            downloadOnTap: () async {
                              final List<Directory>? downloadsDir =
                                  await getExternalStorageDirectories();
                              await FlutterDownloader.enqueue(
                                saveInPublicStorage: true,
                                url: CourseApi.courseDataList[index].fileName,
                                headers: {},
                                savedDir: downloadsDir![0].path,
                                showNotification: true,
                                openFileFromNotification: true,
                              );
                            },
                            viewPdfOnTap: () {
                              viewPdfs(
                                context,
                                pdfUrl:
                                    CourseApi.courseDataList[index].fileName,
                                title:
                                    '${CourseApi.courseDataList[index].subjectName} (${CourseApi.courseDataList[index].semester})',
                              );
                            },
                            sharePdfOnTap: () async {
                              String longUrl =
                                  CourseApi.courseDataList[index].fileName;
                              String shortUrl =
                                  await NetworkApi.getShortLink(longUrl);
                              await Share.share(
                                shortUrl,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
      floatingActionButton: floatingActionButton(
        context,
        onPressed: () async {
          await AppNavigation.shared
              .moveToAddCourseScreen()
              .whenComplete(() async {
            await getData();
            setState(() {});
          });
        },
      ),
    );
  }
}
