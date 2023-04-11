import '../../../libs.dart';

class UpdateJobVacancyNotice extends StatefulWidget {
  final Map<String, dynamic> args;

  const UpdateJobVacancyNotice({Key? key, required this.args})
      : super(key: key);
  static const route = 'updateJobVacancyNotice';

  @override
  State<UpdateJobVacancyNotice> createState() => _UpdateJobVacancyNoticeState();
}

class _UpdateJobVacancyNoticeState extends State<UpdateJobVacancyNotice> {
  GlobalKey<FormState> updateJobVacancy = GlobalKey<FormState>();
  bool loading = false;

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

  @override
  void dispose() {
    clearData();
    super.dispose();
  }

  void clearData() {
    fileimage = null;
    txtJobVacancyTitle.text = '';
    txtJobVacancyDescription.text = '';
  }

  late JobVacancy jobVacancyData;
  @override
  void initState() {
    jobVacancyData = JobVacancy.fromJson(widget.args);
    txtJobVacancyTitle.text = jobVacancyData.title;
    txtJobVacancyDescription.text = jobVacancyData.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, title: "Update Job Vacancy"),
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: updateJobVacancy,
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
                                      jobVacancyData.image,
                                    ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      labelText(text: "Enter Title"),
                      sTextFormField(
                        txtController: txtJobVacancyTitle,
                        validator: (value) =>
                            value!.isEmpty ? "Please Enter Title" : null,
                        hintText: "Enter Title",
                      ),
                      labelText(text: "Enter Description"),
                      sTextFormField(
                        txtController: txtJobVacancyDescription,
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
            if (updateJobVacancy.currentState!.validate()) {
              if (jobVacancyData.image.isNotEmpty) {
                if (fileimage != null) {
                  loading = true;
                  setState(() {});
                  var snapshot = await firebaseStorage
                      .ref()
                      .child('JobVacancy_Images/img_${DateTime.now()}')
                      .putFile(fileimage!);
                  imageUrl = await snapshot.ref.getDownloadURL();
                }
                JobVacancy obj = JobVacancy(
                  key: jobVacancyData.key,
                  title: txtJobVacancyTitle.text,
                  description: txtJobVacancyDescription.text,
                  image: imageUrl ?? jobVacancyData.image,
                );
                await JobVacancyApi.updateData(
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
