// ignore_for_file: use_build_context_synchronously

import 'package:intl/intl.dart';

import '../../libs.dart';

class AddStudentDetails extends StatefulWidget {
  const AddStudentDetails({Key? key}) : super(key: key);
  static const route = 'addStudentDetails';

  @override
  State<AddStudentDetails> createState() => AddStudentDetailsState();
}

class AddStudentDetailsState extends State<AddStudentDetails> {
  GlobalKey<FormState> addStudent = GlobalKey<FormState>();

  String? selectedStream;
  String? selectedSemester;
  String? selectedBloodGroup;
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

  List<String> stream = ['BCOM', 'BBA', 'BCA'];

  List<String> semester = [
    'SEM - 1',
    'SEM - 2',
    'SEM - 3',
    'SEM - 4',
    'SEM - 5',
    'SEM - 6',
  ];

  List<String> bloodGroup = ['A+', 'O+', 'B+', 'AB+', 'A-', 'O-', 'B-', 'AB-'];

  bool loading = false;

  clearController() {
    txtStudentFnameController.clear();
    txtStudentMNameController.clear();
    txtStudentLnameController.clear();
    txtStudentEmailController.clear();
    txtStudentPhoneNoController.clear();
    txtStudentBirthDateController.clear();
    txtStudentAddressController.clear();
    txtStudentPinCodeController.clear();
    txtStudentEnrollmentControl.clear();
    txtStudentSpidController.clear();
    txtStudentCasteController.clear();
    gender = '';
    selectedStream = null;
    selectedSemester = null;
    selectedBloodGroup = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, title: 'Add Student Details'),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: addStudent,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  notification.disallowIndicator();
                  return true;
                },
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
                                : const AssetImage(
                                    'assets/icons/select_photo.jpg',
                                  ),
                          ),
                        ),
                      ),
                      sizedBox,
                      labelText(text: 'First Name'),
                      textFormField(
                        txtController: txtStudentFnameController,
                        prefixIcon: Icons.person,
                        hintText: 'First Name',
                        validator: (value) => value!.isEmpty
                            ? " Please Enter First Name"
                            : null,
                      ),
                      labelText(text: 'Middle Name'),
                      textFormField(
                        txtController: txtStudentMNameController,
                        prefixIcon: Icons.person,
                        hintText: 'Middle Name',
                        validator: (value) => value!.isEmpty
                            ? " Please Enter Middle Name"
                            : null,
                      ),
                      labelText(text: 'Last Name'),
                      textFormField(
                        txtController: txtStudentLnameController,
                        prefixIcon: Icons.person,
                        hintText: 'Last Name',
                        validator: (value) =>
                            value!.isEmpty ? "Please Enter Last Name" : null,
                      ),
                      labelText(text: 'Email'),
                      textFormField(
                        txtController: txtStudentEmailController,
                        prefixIcon: Icons.email,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          RegExp regExp = RegExp(emailPattern);
                          if (value == null || value.isEmpty) {
                            return "Please email address";
                          } else if (!regExp.hasMatch(value)) {
                            return "Please enter valid email address";
                          } else {
                            return null;
                          }
                        },
                      ),
                      labelText(text: 'Phone No.'),
                      textFormField(
                        txtController: txtStudentPhoneNoController,
                        prefixIcon: Icons.phone,
                        hintText: 'Enter Phone No.',
                        keyboardType: TextInputType.phone,
                        validator: (value) => value!.isEmpty
                            ? "Please Enter valid mobile no"
                            : null,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      labelText(text: 'Date of Birth'),
                      textFormField(
                        txtController: txtStudentBirthDateController,
                        readOnly: true,
                        prefixIcon: Icons.date_range,
                        suffixIcon: Icons.calendar_month,
                        hintText: 'Select Date of Birth',
                        validator: (value) {
                          if (value!.isEmpty || value.isEmpty) {
                            return 'Please select date of birth';
                          }
                          return null;
                        },
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2030));
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            setState(() {
                              txtStudentBirthDateController.text =
                                  formattedDate;
                            });
                          }
                        },
                      ),
                      labelText(text: 'Gender'),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 3, 10, 0),
                        height: MediaQuery.of(context).size.height * 0.07,
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          border: Border.all(
                            color: kPrimaryColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                             Icon(
                              Icons.transgender,
                              color: kPrimaryColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'GENDER',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            Radio(
                              focusColor: kPrimaryColor,
                              activeColor: kPrimaryColor,
                              value: male,
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = male.toString();
                                });
                              },
                            ),
                            const Text(
                              'Male',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            Radio(
                              focusColor: kPrimaryColor,
                              activeColor: kPrimaryColor,
                              value: female,
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = female.toString();
                                });
                              },
                            ),
                            const Text(
                              'Female',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      labelText(text: 'Caste'),
                      textFormField(
                        txtController: txtStudentCasteController,
                        hintText: 'Enter Caste',
                        validator: (value) =>
                            value!.isEmpty ? "Please Enter caste" : null,
                      ),
                      labelText(text: 'Blood Group'),
                      dropDownButton(
                        context,
                        hintText: 'Select Blood Group',
                        item: bloodGroup
                            .map(
                              (bloodGroup) => DropdownMenuItem<String>(
                                value: bloodGroup,
                                child: Text(
                                  bloodGroup,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        value: selectedBloodGroup,
                        onChanged: (value) {
                          setState(() {
                            selectedBloodGroup = value as String;
                          });
                        },
                      ),
                      labelText(text: 'Address'),
                      textFormField(
                        txtController: txtStudentAddressController,
                        prefixIcon: Icons.home,
                        hintText: 'Enter Address',
                        validator: (value) =>
                            value!.isEmpty ? "Please Enter Address" : null,
                      ),
                      labelText(text: 'Pincode No.'),
                      textFormField(
                        txtController: txtStudentPinCodeController,
                        prefixIcon: Icons.pin_outlined,
                        hintText: 'Enter Pincode No.',
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty
                            ? "Please Enter valid Pincode no"
                            : null,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                      ),
                      labelText(text: 'Select Stream'),
                      dropDownButton(
                        context,
                        hintText: 'Select Stream',
                        item: stream
                            .map(
                              (stream) => DropdownMenuItem<String>(
                                value: stream,
                                child: Text(
                                  stream,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        value: selectedStream,
                        onChanged: (value) {
                          setState(() {
                            selectedStream = value as String;
                          });
                        },
                      ),
                      labelText(text: 'Select Semester'),
                      dropDownButton(
                        context,
                        hintText: 'Select Semester',
                        item: semester
                            .map(
                              (semester) => DropdownMenuItem<String>(
                                value: semester,
                                child: Text(
                                  semester,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        value: selectedSemester,
                        onChanged: (value) {
                          setState(() {
                            selectedSemester = value as String;
                          });
                        },
                      ),
                      labelText(text: 'Enrollment No.'),
                      textFormField(
                        txtController: txtStudentEnrollmentControl,
                        prefixIcon: Icons.format_list_numbered_rtl_outlined,
                        keyboardType: TextInputType.number,
                        hintText: 'Enter Enrollment No.',
                        validator: (value) => value!.isEmpty
                            ? "Please Enter valid Enrollment no"
                            : null,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(14),
                        ],
                      ),
                      labelText(text: 'SPID No.'),
                      textFormField(
                        txtController: txtStudentSpidController,
                        prefixIcon: Icons.format_list_numbered_rounded,
                        keyboardType: TextInputType.number,
                        hintText: 'Enter SPID No.',
                        validator: (value) => value!.isEmpty
                            ? "Please Enter valid SPID no"
                            : null,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
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
            if (addStudent.currentState!.validate()) {
              if (fileimage != null) {
                if (selectedStream != null) {
                  if (selectedSemester != null) {
                    if (selectedBloodGroup != null) {
                      loading = true;
                      setState(() {});
                      var snapshot = await firebaseStorage
                          .ref()
                          .child("Student_images/img_${DateTime.now()}")
                          .putFile(fileimage!);
                      imageUrl = await snapshot.ref.getDownloadURL();
                      Student obj = Student(
                        key: int.parse(
                            DateTime.now().millisecondsSinceEpoch.toString()),
                        fName: txtStudentFnameController.text,
                        mName: txtStudentMNameController.text,
                        lName: txtStudentLnameController.text,
                        caste: txtStudentCasteController.text,
                        image: imageUrl ?? "",
                        email: txtStudentEmailController.text,
                        phoneNo: txtStudentPhoneNoController.text,
                        dob: txtStudentBirthDateController.text,
                        gender: gender,
                        stream: selectedStream.toString(),
                        semester: selectedSemester.toString(),
                        address: txtStudentAddressController.text,
                        pincode: txtStudentPinCodeController.text,
                        enrollNo: txtStudentEnrollmentControl.text,
                        spidNo: txtStudentSpidController.text,
                        bloodGroup: selectedBloodGroup.toString(),
                      );
                      await StudentDataApi.studentAddData(obj: obj);
                      Navigator.pop(context);
                      loading = false;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text("Successfully Add Student Data"),
                        backgroundColor: Colors.green,
                        margin: EdgeInsets.all(20),
                        behavior: SnackBarBehavior.floating,
                      ));
                      clearController();
                      setState(() {});
                    } else {
                      loading = false;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please Select Blood Group"),
                        backgroundColor: Colors.red,
                        margin: EdgeInsets.all(20),
                        behavior: SnackBarBehavior.floating,
                      ));
                    }
                  } else {
                    loading = false;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please Select Semester"),
                      backgroundColor: Colors.red,
                      margin: EdgeInsets.all(20),
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                } else {
                  loading = false;

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please Select Stream"),
                    backgroundColor: Colors.red,
                    margin: EdgeInsets.all(20),
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              } else {
                loading = false;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please Enter Image"),
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


   // radioContainer(context,
                      //     maleValue: male,
                      //     femaleOnChanged: (value) {
                      //       setState(() {
                      //         gender = male.toString();
                      //       });
                      //     },
                      //     femaleValue: female,
                      //     maleOnChanged: (value) {
                      //       setState(() {
                      //         gender = female.toString();
                      //       });
                      //     }),