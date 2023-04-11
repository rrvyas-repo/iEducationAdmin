import 'package:http/http.dart' as http;
import '../../libs.dart';

class PdfViewerPage extends StatefulWidget {
  final String? url;
  final void Function(int?, int?)? onPageChanged;
  const PdfViewerPage({super.key, this.url, this.onPageChanged});

  @override
  PdfViewerPageState createState() => PdfViewerPageState();
}

class PdfViewerPageState extends State<PdfViewerPage> {
  late File pFile;
  int currentPage = 0;
  bool isLoading = false;
  Future<void> loadNetwork() async {
    isLoading = true;
    var url = widget.url;
    final response = await http.get(Uri.parse(url!));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    pFile = file;
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    loadNetwork();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: PDFView(
              filePath: pFile.path,
              onPageChanged: widget.onPageChanged,
            ),
          );
  }
}
