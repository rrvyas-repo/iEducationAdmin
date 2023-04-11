import 'package:intl/intl.dart';
import '../../libs.dart';

class UpdateTimeTable extends StatefulWidget {
  final Map<String, dynamic> args;

  const UpdateTimeTable({Key? key, required this.args}) : super(key: key);
  static const route = 'updateTimeTable';

  @override
  State<UpdateTimeTable> createState() => _UpdateTimeTableState();
}

class _UpdateTimeTableState extends State<UpdateTimeTable> {
  GlobalKey<FormState> updateTimeTable = GlobalKey<FormState>();
  String? selectedSemesters;
  String? selectedStreams;
  String selectedOldDate = '';
  List<TimeTable>? showTimeTable;
  List<String> semester = [
    'SEM - 1',
    'SEM - 2',
    'SEM - 3',
    'SEM - 4',
    'SEM - 5',
    'SEM - 6',
  ];

  List<String> stream = ['BCA', 'BBA', 'BCOM'];
  bool loading = false;
  late TimeTable timeTableData;
  String? dayOfWeek;
  @override
  void initState() {
    super.initState();
    timeTableData = TimeTable.fromJson(widget.args);
    txtLectureName.text = timeTableData.lectureName;
    txtLectureDate.text = timeTableData.lectureDate;
    txtLectureStartTime.text = timeTableData.lectureStartTime;
    txtLectureEndTime.text = timeTableData.lectureEndTime;
    selectedStreams = timeTableData.stream;
    selectedSemesters = timeTableData.semester;
    selectedOldDate = timeTableData.lectureDate;
  }

  clearController() {
    txtLectureName.text = '';
    txtLectureDate.text = '';
    txtLectureStartTime.text = '';
    txtLectureEndTime.text = '';
    selectedSemesters = null;
    selectedStreams = null;
    selectedOldDate = '';
  }

  @override
  void dispose() {
    txtLectureName.clear();
    txtLectureDate.clear();
    txtLectureStartTime.clear();
    txtLectureEndTime.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, title: 'Update Time Table'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Form(
              key: updateTimeTable,
              child: ListView(
                children: [
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
                    value: selectedStreams,
                    onChanged: (value) {
                      setState(() {
                        selectedStreams = value as String;
                      });
                    },
                  ),
                  labelText(text: "Select Semester"),
                  dropDownButton(
                    context,
                    hintText: 'Select Semester',
                    item: semester
                        .map((semester) => DropdownMenuItem<String>(
                              value: semester,
                              child: Text(
                                semester,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedSemesters,
                    onChanged: (value) {
                      setState(
                        () {
                          selectedSemesters = value as String;
                        },
                      );
                    },
                  ),
                  labelText(text: "Lecture Name"),
                  textFormField(
                    txtController: txtLectureName,
                    validator: (value) =>
                        value!.isEmpty ? "Enter Lecture Name" : null,
                    hintText: "Lecture Name",
                    prefixIcon: Icons.library_books,
                  ),
                  labelText(text: "Lecture Date"),
                  textFormField(
                      readOnly: true,
                      txtController: txtLectureDate,
                      validator: (value) {
                        if (value!.isEmpty || value.isEmpty) {
                          return 'Choose Date';
                        }
                        return null;
                      },
                      prefixIcon: Icons.calendar_today_outlined,
                      suffixIcon: Icons.calendar_month,
                      hintText: "Lecture Date",
                      onPressed: () async {
                        debugPrint("in on tap  ==> ");

                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2030),
                        );
                        if (newDate == null) return;
                        String date1 =
                            "${newDate.day}-${newDate.month}-${newDate.year}";
                        txtLectureDate.text = date1;
                        setState(() {});
                      }),
                  labelText(text: "Lecture  Start Time"),
                  textFormField(
                    readOnly: true,
                    txtController: txtLectureStartTime,
                    validator: (value) {
                      if (value!.isEmpty || value.isEmpty) {
                        return 'Choose Date';
                      }
                      return null;
                    },
                    prefixIcon: Icons.schedule,
                    suffixIcon: Icons.av_timer,
                    hintText: "Lecture Start Time",
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );
                      if (pickedTime != null) {
                        if (!mounted) return;
                        DateTime parsedTime = DateFormat.jm()
                            .parse(pickedTime.format(context).toString());
                        String formattedTime =
                            DateFormat('hh:mm aa').format(parsedTime);
                        setState(() {
                          txtLectureStartTime.text = formattedTime;
                        });
                      }
                    },
                  ),
                  labelText(text: "Lecture End Time"),
                  textFormField(
                    readOnly: true,
                    txtController: txtLectureEndTime,
                    validator: (value) {
                      if (value!.isEmpty || value.isEmpty) {
                        return 'Choose Date';
                      }
                      return null;
                    },
                    hintText: 'Lecture End Time',
                    prefixIcon: Icons.schedule,
                    suffixIcon: Icons.av_timer,
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );
                      if (pickedTime != null) {
                        if (!mounted) return;

                        DateTime parsedTime = DateFormat.jm()
                            .parse(pickedTime.format(context).toString());
                        String formattedTime =
                            DateFormat('hh:mm aa').format(parsedTime);
                        setState(() {
                          txtLectureEndTime.text = formattedTime;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Positioned(
                child: loading ? processIndicator(context) : const SizedBox())
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: materialButton(
          context,
          buttonText: 'Update',
          onPressed: () async {
            if (updateTimeTable.currentState!.validate()) {
              if (selectedStreams != null) {
                if (selectedSemesters != null) {
                  loading = true;
                  TimeTable tbl = TimeTable(
                    key: timeTableData.key,
                    stream: selectedStreams!,
                    semester: selectedSemesters!,
                    lectureName: txtLectureName.text,
                    lectureDate: txtLectureDate.text,
                    lectureStartTime: txtLectureStartTime.text,
                    lectureEndTime: txtLectureEndTime.text,
                  );
                  await TimeTableApi.updateData(
                    obj: tbl,
                    oldDate: selectedOldDate,
                    child: txtLectureDate.text,
                    // key: widget.tb.key.toString(),
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                  setState(() {});
                  loading = false;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text("Update Time Table"),
                    backgroundColor: Colors.green,
                    margin: EdgeInsets.all(20),
                    behavior: SnackBarBehavior.floating,
                  ));
                  clearController();
                  setState(() {});
                } else {
                  loading = false;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please Select Semester "),
                    backgroundColor: Colors.red,
                    margin: EdgeInsets.all(20),
                    behavior: SnackBarBehavior.floating,
                  ));
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
            }
          },
        ),
      ),
    );
  }
}
