// ignore_for_file: use_build_context_synchronously

import '../../libs.dart';

class StudentListScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  const StudentListScreen({Key? key, required this.args}) : super(key: key);
  static const String route = 'StudentList';

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  String? selectedSemSemester = 'All';

  final List<String> semester = [
    'All',
    'SEM - 1',
    'SEM - 2',
    'SEM - 3',
    'SEM - 4',
    'SEM - 5',
    'SEM - 6',
  ];

  @override
  void initState() {
    StudentDataApi.studSemData.clear();
    StudentDataApi.studSemData.addAll(StudentDataApi.studentDataList);
    super.initState();
  }

  getData() async {
    StudentDataApi.studentDataList = await StudentDataApi.fetchData();
    await StudentDataApi.sortingData(selectedSemSemester!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, title: widget.args['stream']),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
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
              value: selectedSemSemester,
              onChanged: (value) {
                setState(() {
                  selectedSemSemester = value as String;
                  StudentDataApi.sortingData(selectedSemSemester!);
                });
              },
            ),
            StudentDataApi.studSemData.isEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      Lottie.asset('assets/icons/Circle.json'),
                    ],
                  )
                : Expanded(
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (notification) {
                        notification.disallowIndicator();
                        return true;
                      },
                      child: animation(
                        context,
                        seconds: 500,
                        verticalOffset: 100,
                        child: ListView.builder(
                          itemCount: StudentDataApi.studSemData.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(
                                  StudentDataApi.studSemData[index].toString()),
                              confirmDismiss: (direction) {
                                return showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: const Text(
                                      'Sure You Want To Remove?',
                                    ),
                                    actions: [
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      MaterialButton(
                                        onPressed: () async {
                                          await StudentDataApi.deleteStdData(
                                            key: StudentDataApi
                                                .studSemData[index].key
                                                .toString(),
                                            child: StudentDataApi
                                                .studSemData[index].stream,
                                          );
                                          Navigator.pop(context);
                                          await getData();
                                          await StudentDataApi.sortingData(
                                              selectedSemSemester!);
                                        },
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  ),
                                  barrierDismissible: false,
                                );
                              },
                              child: GestureDetector(
                                onTap: (() async {
                                  await AppNavigation.shared
                                      .moveToStudentProfile({
                                    'data': StudentDataApi.studSemData[index]
                                        .toJson(),
                                    'index': index,
                                    'key': widget.args['key'],
                                    'sem': selectedSemSemester,
                                  });
                                  setState(() {});
                                }),
                                child: Card(
                                  elevation: 5,
                                  child: ListTile(
                                    leading: CachedNetworkImage(
                                      imageUrl: StudentDataApi
                                          .studSemData[index].image
                                          .toString(),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 50,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(
                                        color: kPrimaryColor,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    title: Text(
                                      '${StudentDataApi.studSemData[index].fName} ${StudentDataApi.studSemData[index].mName} ${StudentDataApi.studSemData[index].lName}',
                                    ),
                                    subtitle: Text(
                                      StudentDataApi
                                          .studSemData[index].semester,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
