// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:admin_app/database/network/network_api.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:share_plus/share_plus.dart';

import '../../libs.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({Key? key}) : super(key: key);
  static const route = 'material';
  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  bool isLoading = false;

  Future<void> getData() async {
    isLoading = true;
    await MaterialApi.fetchData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, title: 'Materials'),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : MaterialApi.materialsDataList.isEmpty
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
                      itemCount: MaterialApi.materialsDataList.length,
                      itemBuilder: (context, index) => Dismissible(
                        key: Key(
                          MaterialApi.materialsDataList[index].key.toString(),
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
                                    await MaterialApi.deleteData(
                                      key: MaterialApi
                                          .materialsDataList[index].key
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
                              MaterialApi.materialsDataList[index].isShowButton,
                          onTap: () {
                            indexs.removeAt(0);
                            indexs.insert(1, index);
                            setState(() {
                              MaterialApi.materialsDataList[indexs[0]]
                                  .isShowButton = false;
                              MaterialApi.materialsDataList[index]
                                  .isShowButton = MaterialApi
                                          .materialsDataList[index]
                                          .isShowButton ==
                                      false
                                  ? true
                                  : false;
                            });
                          },
                          subjectName:
                              MaterialApi.materialsDataList[index].subjectName,
                          stream:
                              '${MaterialApi.materialsDataList[index].stream} ${MaterialApi.materialsDataList[index].semester}',
                          dateTime:
                              '${MaterialApi.materialsDataList[index].date}  ${MaterialApi.materialsDataList[index].time}',
                          fileSize:
                              MaterialApi.materialsDataList[index].fileSize,
                          downloadOnTap: () async {
                            final List<Directory>? downloadsDir =
                                await getExternalStorageDirectories();
                            await FlutterDownloader.enqueue(
                              saveInPublicStorage: true,
                              url:
                                  MaterialApi.materialsDataList[index].fileName,
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
                                  MaterialApi.materialsDataList[index].fileName,
                              title:
                                  '${MaterialApi.materialsDataList[index].subjectName} (${MaterialApi.materialsDataList[index].semester})',
                            );
                          },
                          sharePdfOnTap: () async {
                            String longUrl =
                                MaterialApi.materialsDataList[index].fileName;
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
              .moveToAddMaterialScreen()
              .whenComplete(() async {
            await getData();
            setState(() {});
          });
        },
      ),
    );
  }
}
