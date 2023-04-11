import '../libs.dart';

class AppNavigation {
  static final AppNavigation shared = AppNavigation();

  goNextFromSplash() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool('userID') == true) {
      await NavigationUtilities.pushReplacementNamed(HomeScreen.route,
          type: RouteType.up);
    } else {
      await NavigationUtilities.pushReplacementNamed(LoginScreen.route,
          type: RouteType.right);
    }
  }


// **** Student ****
  void movetoStudent() {
    NavigationUtilities.pushNamed(StudentsFieldScreen.route);
  }

  void movetoAddStudent() {
    NavigationUtilities.pushNamed(AddStudentDetails.route, type: RouteType.up);
  }

  Future moveToStudentList(Map<String, dynamic> args) async {
    await NavigationUtilities.pushNamed(StudentListScreen.route,
        type: RouteType.up, args: args);
  }

  Future moveToStudentProfile(Map<String, dynamic> args) async {
    await NavigationUtilities.pushNamed(StudentProfileScreen.route,
        type: RouteType.up, args: args);
  }

  Future moveToUpdateStudent(Map<String, dynamic> args) async {
    await NavigationUtilities.pushNamed(UpdateStudent.route, args: args);
  }

// **** Time Table ****
  void movetoTimeTableScreen() {
    NavigationUtilities.pushNamed(TimeTableScreen.route);
  }

  Future movetoAddTimeTableScreen() async {
    await NavigationUtilities.pushNamed(AddTimeTable.route, type: RouteType.up);
  }

  Future moveToUpdateTimeTableScreen(Map<String, dynamic> args) async {
    NavigationUtilities.pushNamed(UpdateTimeTable.route, args: args);
  }

// **** Staff List ****
  void movetoStaffList() {
    NavigationUtilities.pushNamed(StaffListScreen.route);
  }

  Future moveToAddStaffList() async {
    await NavigationUtilities.pushNamed(AddStaffDetailsScreen.route,
        type: RouteType.up);
  }

  Future moveToStaffProfile(Map<String, dynamic> args) async {
    await NavigationUtilities.pushNamed(StaffProfileScreen.route,
        type: RouteType.up, args: args);
  }

  Future moveToUpdateStaffList(Map<String, dynamic> args) async {
    await NavigationUtilities.pushNamed(UpdateStaffScreen.route, args: args);
  }

// **** Notice ****
  void moveToNoticeScreen() {
    NavigationUtilities.pushNamed(NoticeScreen.route);
  }

  void moveToCulturalFestivalScreen() {
    NavigationUtilities.pushNamed(CulturalFestivalNotice.route);
  }

  void moveToCollegeActivityScreen() {
    NavigationUtilities.pushNamed(CollegeActivityNotice.route);
  }

  void moveToSportsScreen() {
    NavigationUtilities.pushNamed(SportsNoticeScreen.route);
  }

  void moveToCompatitiveExamScreen() {
    NavigationUtilities.pushNamed(CompetitiveExamNotice.route);
  }

  void moveToJobVacancyScreen() {
    NavigationUtilities.pushNamed(JobVacancyNotice.route);
  }

  void moveToGeneralScreen() {
    NavigationUtilities.pushNamed(GeneralNotice.route);
  }

// **** Add Notice ****

  Future moveToAddCulturalFestivalScreen() async {
    await NavigationUtilities.pushNamed(AddCulturalFestival.route,
        type: RouteType.up);
  }

  Future moveToAddCollegeActivityScreen() async {
    await NavigationUtilities.pushNamed(AddCollegeActivityNotice.route,
        type: RouteType.up);
  }

  Future moveToAddSportsScreen() async {
    await NavigationUtilities.pushNamed(AddSportsNotice.route,
        type: RouteType.up);
  }

  Future moveToAddCompatitiveExamScreen() async {
    await NavigationUtilities.pushNamed(AddCompetitiveExamNotice.route,
        type: RouteType.up);
  }

  Future moveToAddJobVacancyScreen() async {
    await NavigationUtilities.pushNamed(AddJobVacancyNotice.route,
        type: RouteType.up);
  }

  Future moveToAddGeneralScreen() async {
    await NavigationUtilities.pushNamed(AddGeneralNotice.route,
        type: RouteType.up);
  }

// **** Update Notice ****

  Future moveToUpdateCulturalFestivalScreen(Map<String, dynamic> args) async {
    await NavigationUtilities.pushNamed(UpdateCultureFestival.route,
        args: args);
  }

  Future moveToUpdateCollegeActivityScreen(Map<String, dynamic> args) async {
    await NavigationUtilities.pushNamed(UpdateCollegeActivity.route,
        args: args);
  }

  Future moveToUpdateSportsScreen(Map<String, dynamic> args) async {
    await NavigationUtilities.pushNamed(UpdateSportNotice.route, args: args);
  }

  Future moveToUpdateCompatitiveExamScreen(Map<String, dynamic> args) async {
    await NavigationUtilities.pushNamed(UpdateCompetitiveExam.route,
        args: args);
  }

  Future moveToUpdateJobVacancyScreen(Map<String, dynamic> args) async {
    await NavigationUtilities.pushNamed(UpdateJobVacancyNotice.route,
        args: args);
  }

  Future moveToUpdateGeneralScreen(Map<String, dynamic> args) async {
    await NavigationUtilities.pushNamed(UpdateGeneralNotice.route, args: args);
  }

// **** Materials ********

  void moveToMaterialsScreen() {
    NavigationUtilities.pushNamed(MaterialScreen.route);
  }

  Future moveToAddMaterialScreen() async {
    await NavigationUtilities.pushNamed(AddMaterialScreen.route,
        type: RouteType.up);
  }

// **** Materials ********

  void moveToAssignmentScreen() {
    NavigationUtilities.pushNamed(AssignmentScreen.route);
  }

  Future moveToAddAssignmentScreen() async {
    await NavigationUtilities.pushNamed(AddAssignmentScreen.route,
        type: RouteType.up);
  }

// **** Course ********

  void moveToCourseScreen() {
    NavigationUtilities.pushNamed(CourseScreen.route);
  }

  Future moveToAddCourseScreen() async {
    await NavigationUtilities.pushNamed(AddCourseScreen.route,
        type: RouteType.up);
  }

// **** Result ********

  void moveToResultScreen() {
    NavigationUtilities.pushNamed(ResultScreen.route);
  }

  Future moveToAddResultScreen() async {
    await NavigationUtilities.pushNamed(AddResultScreen.route,
        type: RouteType.up);
  }

  // void moveToLogin({bool isPopAndSwitch = true, bool isLogOut = false}) {
  // print('Go to Appnavigation And code their For Move To Next screen');
  //   if (isLogOut) {
  //     Navigator.of(NavigationUtilities.key.currentState!.overlay!.context)
  //         .pushNamedAndRemoveUntil(
  //       OtpLoginScreen.route,
  //       (Route<dynamic> route) => false,
  //     );
  //   } else {
  //     NavigationUtilities.pushReplacementNamed(OtpLoginScreen.route);
  //   }
  // }
}
