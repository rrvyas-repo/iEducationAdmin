import '../../../libs.dart';

class UpdateCollegeActivity extends StatefulWidget {
  final Map<String, dynamic> args;
  const UpdateCollegeActivity({Key? key, required this.args}) : super(key: key);
  static const route = 'updateCollegeActivity';

  @override
  State<UpdateCollegeActivity> createState() => _UpdateCollegeActivityState();
}

class _UpdateCollegeActivityState extends State<UpdateCollegeActivity> {
  GlobalKey<FormState> updateCollegeActivity = GlobalKey<FormState>();

  File? fileimage;
  String? imageUrl;
  bool loading = false;
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

  @override
  void dispose() {
    clearData();
    super.dispose();
  }

  void clearData() {
    fileimage = null;
    txtCollegeActivityTitle.text = '';
    txtCollegeActivityDescription.text = '';
  }

  late CollegeActivity collegeActivityData;
  @override
  void initState() {
    collegeActivityData = CollegeActivity.fromJson(widget.args);
    txtCollegeActivityTitle.text = collegeActivityData.title;
    txtCollegeActivityDescription.text = collegeActivityData.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, title: "Update College Activity"),
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: updateCollegeActivity,
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
                                  : NetworkImage(
                                      collegeActivityData.image,
                                    ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      labelText(text: "Enter Title"),
                      sTextFormField(
                        txtController: txtCollegeActivityTitle,
                        validator: (value) =>
                            value!.isEmpty ? "Please Enter Title" : null,
                        hintText: "Enter Title",
                      ),
                      labelText(text: "Enter Description"),
                      sTextFormField(
                        txtController: txtCollegeActivityDescription,
                        validator: (value) =>
                            value!.isEmpty ? "Enter Description" : null,
                        hintText: "Please Enter Description",
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
          buttonText: 'Update',
          onPressed: () async {
            if (updateCollegeActivity.currentState!.validate()) {
              if (collegeActivityData.image.isNotEmpty) {
                if (fileimage != null) {
                  loading = true;
                  setState(() {});
                  var snapshot = await firebaseStorage
                      .ref()
                      .child('CollegeActivity_Images/img_${DateTime.now()}')
                      .putFile(fileimage!);
                  imageUrl = await snapshot.ref.getDownloadURL();
                }
                CollegeActivity obj = CollegeActivity(
                  key: collegeActivityData.key,
                  title: txtCollegeActivityTitle.text,
                  description: txtCollegeActivityTitle.text,
                  image: imageUrl ?? collegeActivityData.image,
                );
                await CollegeActivityApi.updateData(
                  obj: obj,
                );
                if (!mounted) return;
                Navigator.pop(context);
                setState(() {});
                loading = false;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text("Updated Notice"),
                  backgroundColor: Colors.green,
                  margin: EdgeInsets.all(20),
                  behavior: SnackBarBehavior.floating,
                ));
                clearData();
                setState(() {});
              } else {
                loading = false;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please Select Image"),
                  backgroundColor: Colors.red,
                  margin: EdgeInsets.all(20),
                  behavior: SnackBarBehavior.floating,
                ));
              }
            }
          },
        ),
      ),
    );
  }
}
