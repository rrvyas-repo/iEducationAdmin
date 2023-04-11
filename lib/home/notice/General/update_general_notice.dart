import '../../../libs.dart';

class UpdateGeneralNotice extends StatefulWidget {
  final Map<String, dynamic> args;

  const UpdateGeneralNotice({Key? key, required this.args}) : super(key: key);
  static const route = 'updateGeneralNotice';

  @override
  State<UpdateGeneralNotice> createState() => _UpdateGeneralNoticeState();
}

class _UpdateGeneralNoticeState extends State<UpdateGeneralNotice> {
  GlobalKey<FormState> updateGeneral = GlobalKey<FormState>();
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
    txtGeneralTitle.text = '';
    txtGeneralDescription.text = '';
  }

  late General generalData;
  @override
  void initState() {
    generalData = General.fromJson(widget.args);
    txtGeneralTitle.text = generalData.title;
    txtGeneralDescription.text = generalData.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, title: "Update General Notice"),
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: updateGeneral,
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
                                      generalData.image,
                                    ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      labelText(text: "Enter Title"),
                      sTextFormField(
                        txtController: txtGeneralTitle,
                        validator: (value) =>
                            value!.isEmpty ? "Please Enter Title" : null,
                        hintText: "Enter Title",
                      ),
                      labelText(text: "Enter Description"),
                      sTextFormField(
                        txtController: txtGeneralDescription,
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
            if (updateGeneral.currentState!.validate()) {
              if (generalData.image.isNotEmpty) {
                if (fileimage != null) {
                  loading = true;
                  setState(() {});
                  var snapshot = await firebaseStorage
                      .ref()
                      .child('General_Images/img_${DateTime.now()}')
                      .putFile(fileimage!);
                  imageUrl = await snapshot.ref.getDownloadURL();
                }
                General obj = General(
                  key: generalData.key,
                  title: txtGeneralTitle.text,
                  description: txtGeneralDescription.text,
                  image: imageUrl ?? generalData.image,
                );
                await GeneralApi.updateData(
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
