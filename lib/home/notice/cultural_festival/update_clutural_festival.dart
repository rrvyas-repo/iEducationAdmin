import '../../../libs.dart';

class UpdateCultureFestival extends StatefulWidget {
  final Map<String, dynamic> args;
  const UpdateCultureFestival({Key? key, required this.args}) : super(key: key);
  static const route = 'updateCultureFestival';

  @override
  State<UpdateCultureFestival> createState() => _UpdateCultureFestivalState();
}

class _UpdateCultureFestivalState extends State<UpdateCultureFestival> {
  GlobalKey<FormState> updateCultureNotice = GlobalKey<FormState>();

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
    txtCultureTitle.text = '';
    txtCultureDescription.text = '';
  }

  late CulturalFestival culturalFestivalData;
  @override
  void initState() {
    culturalFestivalData = CulturalFestival.fromJson(widget.args);
    txtCultureTitle.text = culturalFestivalData.title;
    txtCultureDescription.text = culturalFestivalData.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, title: "Update cultural Festival"),
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: updateCultureNotice,
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
                                      culturalFestivalData.image,
                                    ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      labelText(text: "Enter Title"),
                      sTextFormField(
                        txtController: txtCultureTitle,
                        validator: (value) =>
                            value!.isEmpty ? "Please Enter Title" : null,
                        hintText: "Plase Enter Title",
                      ),
                      labelText(text: "Enter Description"),
                      sTextFormField(
                        txtController: txtCultureDescription,
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
            if (updateCultureNotice.currentState!.validate()) {
              if (culturalFestivalData.image.isNotEmpty) {
                if (fileimage != null) {
                  loading = true;
                  setState(() {});
                  var snapshot = await firebaseStorage
                      .ref()
                      .child('CulturalFestival_Images/img_${DateTime.now()}')
                      .putFile(fileimage!);
                  imageUrl = await snapshot.ref.getDownloadURL();
                }
                CulturalFestival obj = CulturalFestival(
                  key: culturalFestivalData.key,
                  title: txtCultureTitle.text,
                  description: txtCultureDescription.text,
                  image: imageUrl ?? culturalFestivalData.image,
                );
                await CulturalFestivalApi.updateData(
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
