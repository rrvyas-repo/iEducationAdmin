import '../../../libs.dart';

class AddCompetitiveExamNotice extends StatefulWidget {
  const AddCompetitiveExamNotice({Key? key}) : super(key: key);
  static const route = 'addCompetitiveExam';

  @override
  State<AddCompetitiveExamNotice> createState() =>
      _AddCompetitiveExamNoticeState();
}

class _AddCompetitiveExamNoticeState extends State<AddCompetitiveExamNotice> {
  GlobalKey<FormState> addCompetitiveExam = GlobalKey<FormState>();

  File? fileimage;
  String? imageUrl;

  final firebaseStorage = FirebaseStorage.instance;

  pickImageFromFile() async {
    ImagePicker pickImage = ImagePicker();
    XFile? image1 = await pickImage.pickImage(source: ImageSource.gallery);
    if (image1 == null) {
      return;
    } else {
      fileimage = File(image1.path);
    }
    setState(() {});
  }

  bool loading = false;

  void clearData() {
    fileimage = null;
    txtCompetitiveExamTitle.text = '';
    txtCompetitiveExamDescription.text = '';
  }

  @override
  void dispose() {
    txtCompetitiveExamTitle.clear();
    txtCompetitiveExamDescription.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, title: 'Add Competitive Exam'),
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: addCompetitiveExam,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  notification.disallowIndicator();
                  return true;
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelText(text: "Select Photo"),
                      GestureDetector(
                        onTap: () {
                          pickImageFromFile();
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 3, 10, 0),
                          height: MediaQuery.of(context).size.height * 0.26,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kPrimaryColor),
                            image: DecorationImage(
                              image: fileimage != null
                                  ? FileImage(fileimage!) as ImageProvider
                                  : const AssetImage(
                                      'assets/icons/select_photo.jpg',
                                    ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      sizedBox,
                      labelText(text: "Enter Title"),
                      sTextFormField(
                        txtController: txtCompetitiveExamTitle,
                        validator: (value) =>
                            value!.isEmpty ? "Enter Title" : null,
                        hintText: "Enter Title",
                      ),
                      //sizedBox,
                      labelText(text: "Enter Description"),
                      sTextFormField(
                        txtController: txtCompetitiveExamDescription,
                        validator: (value) =>
                            value!.isEmpty ? "Enter Description" : null,
                        hintText: "Enter Description",
                        maxLines: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              child: loading ? processIndicator(context) : const SizedBox(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: materialButton(
          context,
          buttonText: 'Submit',
          onPressed: () async {
            if (addCompetitiveExam.currentState!.validate()) {
              if (fileimage != null) {
                loading = true;
                setState(() {});
                var snapshot = await firebaseStorage
                    .ref()
                    .child('competitiveExam_images/img_${DateTime.now()}')
                    .putFile(fileimage!);
                imageUrl = await snapshot.ref.getDownloadURL();
                CompetitiveExam obj = CompetitiveExam(
                    key: int.parse(
                        DateTime.now().millisecondsSinceEpoch.toString()),
                    title: txtCompetitiveExamTitle.text,
                    description: txtCompetitiveExamDescription.text,
                    image: imageUrl ?? '');
                await CompetitiveExamApi.competitiveExamAddData(obj: obj);
                if (!mounted) return;
                Navigator.pop(context);
                loading = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text("Successfully Add Notice"),
                    backgroundColor: Colors.green,
                    margin: EdgeInsets.all(20),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                clearData();
                setState(() {});
              } else {
                loading = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please Select Image"),
                    backgroundColor: Colors.red,
                    margin: EdgeInsets.all(20),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
