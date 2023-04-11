// ignore_for_file: use_build_context_synchronously

import '../../libs.dart';

class AddStaffDetailsScreen extends StatefulWidget {
  const AddStaffDetailsScreen({Key? key}) : super(key: key);
  static const route = 'addStaffDetailsScreen';

  @override
  State<AddStaffDetailsScreen> createState() => _AddStaffDetailsScreenState();
}

class _AddStaffDetailsScreenState extends State<AddStaffDetailsScreen> {
  GlobalKey<FormState> addStaff = GlobalKey<FormState>();

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
    txtFnameStaffControl.text = '';
    txtEmailStaffControl.text = '';
    txtDegreeStaffControl.text = '';
    txtPostStaffControl.text = '';
    txtPhoneNoStaffControl.text = '';
    txtSubjectStaffControl.text = '';
    txtExperienceStaffControl.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Details"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: addStaff,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  notification.disallowIndicator();
                  return true;
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                            onTap: () {
                              pickImageFromFile();
                              setState(() {});
                            },
                            child: imageContainer(
                              context,
                              image: fileimage != null
                                  ? FileImage(fileimage!) as ImageProvider
                                  : const AssetImage(
                                      'assets/icons/select_photo.jpg'),
                            )),
                      ),
                      sizedBox,
                      labelText(text: 'Enter Name'),
                      sTextFormField(
                        hintText: "Enter Name",
                        txtController: txtFnameStaffControl,
                        validator: (value) =>
                            value!.isEmpty ? "Enter First Name" : null,
                      ),
                      labelText(text: 'Enter Degree'),
                      sTextFormField(
                          txtController: txtDegreeStaffControl,
                          validator: (value) =>
                              value!.isEmpty ? "Enter Degree" : null,
                          hintText: "Degree"),
                      labelText(text: 'Enter Post'),
                      sTextFormField(
                        hintText: "Post",
                        txtController: txtPostStaffControl,
                        validator: (value) =>
                            value!.isEmpty ? "Enter Post" : null,
                      ),
                      labelText(text: 'Enter Email'),
                      sTextFormField(
                        hintText: "Email",
                        txtController: txtEmailStaffControl,
                        validator: (value) {
                          RegExp regExp = RegExp(emailPattern);
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          } else if (!regExp.hasMatch(value)) {
                            return "Please enter valid email address";
                          } else {
                            return null;
                          }
                        },
                      ),
                      labelText(text: 'Enter Phone No.'),
                      sTextFormField(
                        hintText: "Phone No.",
                        keyboardType: TextInputType.number,
                        txtController: txtPhoneNoStaffControl,
                        validator: (value) =>
                            value!.isEmpty ? "Enter Phone Number" : null,
                      ),
                      labelText(text: 'Enter Subject'),
                      sTextFormField(
                        hintText: "Subject",
                        txtController: txtSubjectStaffControl,
                        validator: (value) =>
                            value!.isEmpty ? "Enter Subject" : null,
                      ),
                      labelText(text: 'Enter Experience'),
                      sTextFormField(
                        txtController: txtExperienceStaffControl,
                        hintText: "Experience",
                        validator: (value) =>
                            value!.isEmpty ? "Enter Experience" : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              child: loading ? processIndicator(context) : const SizedBox())
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: materialButton(
          context,
          buttonText: 'Submit',
          onPressed: () async {
            if (addStaff.currentState!.validate()) {
              if (fileimage != null) {
                loading = true;
                setState(() {});
                var snapshot = await firebaseStorage
                    .ref()
                    .child('staff_images/img_${DateTime.now()}')
                    .putFile(fileimage!);
                imageUrl = await snapshot.ref.getDownloadURL();
                StaffList obj = StaffList(
                    key: int.parse(
                        DateTime.now().millisecondsSinceEpoch.toString()),
                    name: txtFnameStaffControl.text,
                    email: txtEmailStaffControl.text,
                    degree: txtDegreeStaffControl.text,
                    post: txtPostStaffControl.text,
                    phoneNo: txtPhoneNoStaffControl.text,
                    subject: txtSubjectStaffControl.text,
                    experience: txtExperienceStaffControl.text,
                    image: imageUrl ?? '');
                await StaffListApi.staffListAddData(obj: obj);
                Navigator.pop(context);
                loading = false;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text("Successfully Add Staff Data"),
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
