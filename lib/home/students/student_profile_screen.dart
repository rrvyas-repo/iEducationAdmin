// ignore_for_file: unnecessary_null_comparison

import 'package:url_launcher/url_launcher.dart';

import '../../libs.dart';

class StudentProfileScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  const StudentProfileScreen({Key? key, required this.args}) : super(key: key);
  static const String route = 'StudentProfile';

  @override
  State<StudentProfileScreen> createState() => StudentProfileScreenState();
}

class StudentProfileScreenState extends State<StudentProfileScreen> {
  bool isLoading = false;

  Student? studProfile;
  @override
  void initState() {
    convertTomodel();

    super.initState();
  }

  void convertTomodel() {
    studProfile;
    studProfile = Student.fromJson(widget.args['data']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(
        context,
        title: 'Student Profile',
        onPressed: () async {
          await AppNavigation.shared
              .moveToUpdateStudent(studProfile!.toJson())
              .whenComplete(() async {
            studProfile = null;
            StudentDataApi.keys = widget.args['key'];
            await StudentDataApi.fetchData();
            await StudentDataApi.sortingData(widget.args['sem']);
            studProfile = StudentDataApi.studSemData[widget.args['index']];
            setState(() {});
          });
        },
        actionIcon: Icons.edit,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              child: animation(
                context,
                seconds: 1000,
                verticalOffset: 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: cachedNetworkImage(
                          imageUrl: studProfile!.image.toString()),
                    ),
                    sizedBox,
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Center(
                        child: Text(
                          '${studProfile!.fName} ${studProfile!.mName} ${studProfile!.lName}',
                          style: const TextStyle(fontSize: 23),
                        ),
                      ),
                    ),
                    sizedBox,
                    sizedBox,
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.065,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child:  Divider(
                        color: kPrimaryColor,
                        thickness: 2,
                      ),
                    ),
                    sizedBox,
                    GestureDetector(
                      onTap: () async {
                        await launchUrl(
                            Uri.parse("mailto:${studProfile!.email}"));
                      },
                      child: ProfileDetailColumn(
                        title: 'Email Id',
                        value: studProfile!.email,
                        icon: Icons.email,
                        iconSize: 20,
                        iconColor: kPrimaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await launchUrl(
                            Uri.parse("tel:${'+91'}${studProfile!.phoneNo}"));
                      },
                      child: ProfileDetailColumn(
                        title: 'Phone No',
                        value: studProfile!.phoneNo,
                        icon: Icons.phone,
                        iconSize: 20,
                        iconColor: kPrimaryColor,
                      ),
                    ),
                    ProfileDetailColumn(
                        title: 'Date of Birth', value: studProfile!.dob),
                    ProfileDetailColumn(
                        title: 'Gender', value: studProfile!.gender),
                    ProfileDetailColumn(
                        title: 'Address', value: studProfile!.address),
                    ProfileDetailColumn(
                        title: 'Pincode', value: studProfile!.pincode),
                    ProfileDetailColumn(
                        title: 'Blood Group', value: studProfile!.bloodGroup),
                    ProfileDetailColumn(
                        title: 'Caste', value: studProfile!.caste),
                    sizedBox,
                    Text(
                      'Educational Information',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.065,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child:  Divider(
                        color: kPrimaryColor,
                        thickness: 2,
                      ),
                    ),
                    ProfileDetailColumn(
                        title: 'Stream', value: studProfile!.stream),
                    ProfileDetailColumn(
                        title: 'Semester', value: studProfile!.semester),
                    ProfileDetailColumn(
                        title: 'Enrollment No', value: studProfile!.enrollNo),
                    ProfileDetailColumn(
                        title: 'SPID No', value: studProfile!.spidNo),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
