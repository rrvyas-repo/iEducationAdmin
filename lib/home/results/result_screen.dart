// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:admin_app/database/network/network_api.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:share_plus/share_plus.dart';

import '../../libs.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);
  static const route = 'resultScreen';

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isLoading = false;

  Future<void> getData() async {
    isLoading = true;
    await ResultApi.fetchData();
    isLoading = false;
    setState(() {});
  }

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    getData();
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
      appBar: appbar(context, title: 'Result'),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : ResultApi.resultDataList.isEmpty
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
                      itemCount: ResultApi.resultDataList.length,
                      itemBuilder: (context, index) => Dismissible(
                        key: Key(
                          ResultApi.resultDataList[index].key.toString(),
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
                                    await ResultApi.deleteData(
                                      key: ResultApi.resultDataList[index].key
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
                              ResultApi.resultDataList[index].isShowButton,
                          onTap: () {
                            indexs.removeAt(0);
                            indexs.insert(1, index);
                            setState(() {
                              ResultApi.resultDataList[indexs[0]].isShowButton =
                                  false;
                              ResultApi.resultDataList[index].isShowButton =
                                  ResultApi.resultDataList[index]
                                              .isShowButton ==
                                          false
                                      ? true
                                      : false;
                            });
                          },
                          subjectName: ResultApi.resultDataList[index].examType,
                          stream:
                              '${ResultApi.resultDataList[index].stream} ${ResultApi.resultDataList[index].semester}',
                          dateTime:
                              '${ResultApi.resultDataList[index].date}  ${ResultApi.resultDataList[index].time}',
                          fileSize: ResultApi.resultDataList[index].fileSize,
                          downloadOnTap: () async {
                            final List<Directory>? downloadsDir =
                                await getExternalStorageDirectories();
                            await FlutterDownloader.enqueue(
                              saveInPublicStorage: true,
                              url: ResultApi.resultDataList[index].fileName,
                              headers: {},
                              savedDir: downloadsDir![0].path,
                              showNotification: true,
                              openFileFromNotification: true,
                            );
                          },
                          viewPdfOnTap: () {
                            viewPdfs(
                              context,
                              pdfUrl: ResultApi.resultDataList[index].fileName,
                              title:
                                  '${ResultApi.resultDataList[index].examType} (${ResultApi.resultDataList[index].semester})',
                            );
                          },
                          sharePdfOnTap: () async {
                            String longUrl =
                                ResultApi.resultDataList[index].fileName;
                            String shortUrl =
                                await NetworkApi.getShortLink(longUrl);
                            await Share.share(
                              shortUrl,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
      floatingActionButton: floatingActionButton(
        context,
        onPressed: () async {
          await AppNavigation.shared
              .moveToAddResultScreen()
              .whenComplete(() async {
            await getData();
            setState(() {});
          });
        },
      ),
    );
  }
}
