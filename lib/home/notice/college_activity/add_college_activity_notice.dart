import '../../../libs.dart';

class AddCollegeActivityNotice extends StatefulWidget {
  const AddCollegeActivityNotice({Key? key}) : super(key: key);
  static const route = 'addCollegeActivity';

  @override
  State<AddCollegeActivityNotice> createState() =>
      _AddCollegeActivityNoticeState();
}

class _AddCollegeActivityNoticeState extends State<AddCollegeActivityNotice> {
  GlobalKey<FormState> addCollegeActivity = GlobalKey<FormState>();
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
    txtCollegeActivityTitle.text = '';
    txtCollegeActivityDescription.text = '';
  }

  @override
  void dispose() {
    txtCollegeActivityTitle.clear();
    txtCollegeActivityDescription.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, title: 'Add College Activity'),
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: addCollegeActivity,
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
                        txtController: txtCollegeActivityTitle,
                        validator: (value) =>
                            value!.isEmpty ? "Enter Title" : null,
                        hintText: "Enter Title",
                      ),
                      //sizedBox,
                      labelText(text: "Enter Description"),
                      sTextFormField(
                        txtController: txtCollegeActivityDescription,
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
            if (addCollegeActivity.currentState!.validate()) {
              if (fileimage != null) {
                loading = true;
                setState(() {});
                var snapshot = await firebaseStorage
                    .ref()
                    .child('collegeActivity_images/img_${DateTime.now()}')
                    .putFile(fileimage!);
                imageUrl = await snapshot.ref.getDownloadURL();
                CollegeActivity obj = CollegeActivity(
                    key: int.parse(
                        DateTime.now().millisecondsSinceEpoch.toString()),
                    title: txtCollegeActivityTitle.text,
                    description: txtCollegeActivityDescription.text,
                    image: imageUrl ?? '');
                await CollegeActivityApi.collegeActivityAddData(obj: obj);
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
