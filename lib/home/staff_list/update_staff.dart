// ignore_for_file: use_build_context_synchronously

import '../../libs.dart';

class UpdateStaffScreen extends StatefulWidget {
  final Map<String, dynamic> args;

  const UpdateStaffScreen({Key? key, required this.args}) : super(key: key);
  static const route = 'updateStaffScreen';

  @override
  State<UpdateStaffScreen> createState() => _UpdateStaffScreenState();
}

class _UpdateStaffScreenState extends State<UpdateStaffScreen> {
  GlobalKey<FormState> updateStaff = GlobalKey<FormState>();

  late StaffList showStaffData;

  @override
  void initState() {
    super.initState();
    StaffList staffList = StaffListApi.staffDataList[widget.args['index']];
    showStaffData = StaffList.fromJson(staffList.toJson());
    txtFnameStaffControl.text = showStaffData.name;
    txtDegreeStaffControl.text = showStaffData.degree;
    txtPostStaffControl.text = showStaffData.post;
    txtEmailStaffControl.text = showStaffData.email;
    txtPhoneNoStaffControl.text = showStaffData.phoneNo;
    txtSubjectStaffControl.text = showStaffData.subject;
    txtExperienceStaffControl.text = showStaffData.experience;
  }

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
      appBar: appbar(context, title: 'Update Staff'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  notification.disallowIndicator();
                  return true;
                },
                child: Form(
                  key: updateStaff,
                  child: SingleChildScrollView(
                    child: Column(
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
                                  : NetworkImage(
                                      showStaffData.image.toString(),
                                    ),
                            ),
                          ),
                        ),
                        sizedBox,
                        labelText(text: "Enter Name"),
                        sTextFormField(
                          hintText: "Full Name",
                          txtController: txtFnameStaffControl,
                          validator: (value) =>
                              value!.isEmpty ? "Name Required" : null,
                        ),
                        labelText(text: 'Enter Degree'),
                        sTextFormField(
                          txtController: txtDegreeStaffControl,
                          validator: (value) =>
                              value!.isEmpty ? "Degree Required" : null,
                          hintText: 'Degree',
                        ),
                        labelText(text: 'Enter Post'),
                        sTextFormField(
                          txtController: txtPostStaffControl,
                          validator: (value) =>
                              value!.isEmpty ? "Post Required" : null,
                          hintText: 'Post',
                        ),
                        labelText(text: 'Enter Email'),
                        sTextFormField(
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
                          hintText: 'Email',
                        ),
                        labelText(text: 'Enter Phone No.'),
                        sTextFormField(
                          txtController: txtPhoneNoStaffControl,
                          validator: (value) =>
                              value!.isEmpty ? "Phone No. required" : null,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          hintText: 'Phone No',
                        ),
                        labelText(text: 'Enter Subject'),
                        sTextFormField(
                          txtController: txtSubjectStaffControl,
                          validator: (value) =>
                              value!.isEmpty ? "Subject required" : null,
                          hintText: 'Subject',
                        ),
                        labelText(text: 'Enter Experience'),
                        sTextFormField(
                          txtController: txtExperienceStaffControl,
                          validator: (value) =>
                              value!.isEmpty ? "Experience required" : null,
                          hintText: 'Experience',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  child: loading ? processIndicator(context) : const SizedBox())
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: materialButton(
          context,
          buttonText: 'Update',
          onPressed: () async {
            if (updateStaff.currentState!.validate()) {
              if (showStaffData.image.isNotEmpty) {
                if (fileimage != null) {
                  var snapshot = await firebaseStorage
                      .ref()
                      .child('Staff_Images/img_${DateTime.now()}')
                      .putFile(fileimage!);
                  imageUrl = await snapshot.ref.getDownloadURL();
                }
                StaffList obj = StaffList(
                  key: showStaffData.key,
                  name: txtFnameStaffControl.text,
                  email: txtEmailStaffControl.text,
                  degree: txtDegreeStaffControl.text,
                  post: txtPostStaffControl.text,
                  phoneNo: txtPhoneNoStaffControl.text,
                  subject: txtSubjectStaffControl.text,
                  experience: txtExperienceStaffControl.text,
                  image: imageUrl ?? showStaffData.image,
                );
                await StaffListApi.updateData(
                  obj: obj,
                );
                Navigator.pop(context);
                setState(() {});
                loading = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text("Update Staff Data"),
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
