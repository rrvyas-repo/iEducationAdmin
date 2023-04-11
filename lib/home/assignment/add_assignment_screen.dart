// ignore_for_file: use_build_context_synchronously

import 'package:intl/intl.dart';
import '../../libs.dart';

class AddAssignmentScreen extends StatefulWidget {
  const AddAssignmentScreen({Key? key}) : super(key: key);
  static const route = 'addAssignment';
  @override
  State<AddAssignmentScreen> createState() => AddAssignmentScreenState();
}

class AddAssignmentScreenState extends State<AddAssignmentScreen> {
  GlobalKey<FormState> addAssignment = GlobalKey<FormState>();
  bool loading = false;
  String? selectedSemester;
  String? selectedStream;
  String? selectedAssignmentIndex;
  List<String> semester = [
    'SEM - 1',
    'SEM - 2',
    'SEM - 3',
    'SEM - 4',
    'SEM - 5',
    'SEM - 6',
  ];

  List<String> stream = ['BCA', 'BBA', 'BCOM'];
  List<String> assignmentIndex = [
    'Assignment - 1',
    'Assignment - 2',
    'Assignment - 3',
    'Assignment - 4',
    'Assignment - 5',
  ];

  FilePickerResult? result;
  PlatformFile? file;
  double? size;
  String? pfdUrl;
  Uint8List? fileBytes;

  PlatformFile? pickedfile;
  UploadTask? uploadTask;
  double? fileSize;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) {
      return;
    }
    setState(() {
      pickedfile = result.files.first;
      fileSize = pickedfile!.size * 0.000001;
    });
  }

  late String urlDownload;

  Future uploadFile() async {
    final path = 'assignment_pdf/${pickedfile!.name}';
    final file = File(pickedfile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapShot = await uploadTask!.whenComplete(() {});

    urlDownload = await snapShot.ref.getDownloadURL();
  }

  clearData() {
    txtAssignmentSubject.clear();
    txtAssignmentDate.clear();
    txtAssignmentTime.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, title: 'Add Assignment'),
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
                  key: addAssignment,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelText(text: 'Select File'),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kPrimaryColor),
                          ),
                          child: Card(
                            color: kSecondaryColor,
                            elevation: 0,
                            borderOnForeground: true,
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                Icon(
                                  Icons.file_copy_outlined,
                                  color: kPrimaryColor,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                Expanded(
                                  child: pickedfile == null
                                      ? const Text(
                                          'Pick File',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : Text(
                                          pickedfile!.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    selectFile();
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.file_upload,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        labelText(text: 'Subject Name'),
                        textFormField(
                          txtController: txtAssignmentSubject,
                          validator: (value) =>
                              value!.isEmpty ? "Enter Subject" : null,
                          hintText: 'Subject Name',
                          prefixIcon: Icons.library_books_outlined,
                        ),
                        labelText(text: "Select No of Assignment"),
                        dropDownButton(
                          context,
                          hintText: 'Select No of Assignment',
                          item: assignmentIndex
                              .map(
                                (assignmentIndex) => DropdownMenuItem<String>(
                                  value: assignmentIndex,
                                  child: Text(
                                    assignmentIndex,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          value: selectedAssignmentIndex,
                          onChanged: (value) {
                            setState(() {
                              selectedAssignmentIndex = value as String;
                            });
                          },
                        ),
                        labelText(text: "Select Stream"),
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
                        labelText(text: "Select Semester"),
                        dropDownButton(
                          context,
                          hintText: "Select Semester",
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
                        labelText(text: "Select Date"),
                        textFormField(
                          readOnly: true,
                          txtController: txtAssignmentDate,
                          validator: (value) {
                            if (value!.isEmpty || value.isEmpty) {
                              return 'Choose Date';
                            }
                            return null;
                          },
                          hintText: "Select Date",
                          prefixIcon: Icons.calendar_today_outlined,
                          suffixIcon: Icons.calendar_month,
                          onPressed: (() async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2025),
                            );
                            if (newDate == null) return;
                            setState(() {
                              String date = DateFormat.yMd().format(newDate);
                              txtAssignmentDate.text = date;
                            });
                          }),
                        ),
                        labelText(text: 'Select Time'),
                        textFormField(
                          readOnly: true,
                          txtController: txtAssignmentTime,
                          validator: (value) {
                            if (value!.isEmpty || value.isEmpty) {
                              return 'Select Time';
                            }
                            return null;
                          },
                          hintText: 'Select Time',
                          prefixIcon: Icons.schedule,
                          suffixIcon: Icons.av_timer,
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );
                            if (pickedTime != null) {
                              DateTime parsedTime = DateFormat.jm()
                                  .parse(pickedTime.format(context).toString());
                              String formattedTime =
                                  DateFormat('hh:mm aa').format(parsedTime);
                              setState(() {
                                txtAssignmentTime.text = formattedTime;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                child: loading ? processIndicator(context) : const SizedBox(),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: materialButton(
          context,
          buttonText: 'Submit',
          onPressed: () async {
            if (addAssignment.currentState!.validate()) {
              if (pickedfile != null) {
                if (selectedStream != null) {
                  if (selectedSemester != null) {
                    if (selectedAssignmentIndex != null) {
                      loading = true;
                      setState(() {});
                      await uploadFile();
                      Assignment obj = Assignment(
                        key: int.parse(
                            DateTime.now().millisecondsSinceEpoch.toString()),
                        fileName: urlDownload,
                        fileSize: fileSize!.toStringAsFixed(2),
                        subjectName: txtAssignmentSubject.text,
                        stream: selectedStream.toString(),
                        semester: selectedSemester.toString(),
                        noOfAssignment: selectedAssignmentIndex.toString(),
                        date: txtAssignmentDate.text,
                        time: txtAssignmentTime.text,
                      );
                      await AssignmentApi.assignmentAddData(
                        obj: obj,
                      );
                      if (!mounted) return;
                      Navigator.pop(context);
                      loading = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text("Successfully Add Assignment Data"),
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
                          content: Text("Please Select No Of Assignment"),
                          backgroundColor: Colors.red,
                          margin: EdgeInsets.all(20),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  } else {
                    loading = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please Select Stream "),
                        backgroundColor: Colors.red,
                        margin: EdgeInsets.all(20),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } else {
                  loading = false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please Select Semester "),
                      backgroundColor: Colors.red,
                      margin: EdgeInsets.all(20),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } else {
                loading = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please Pick File"),
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
