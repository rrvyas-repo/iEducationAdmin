import '../../libs.dart';

class NavigationUtilities {
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static void push(Widget widget, {String? name}) {
    key.currentState!.push(MaterialPageRoute(
      builder: (context) => widget,
      settings: RouteSettings(name: name),
    ));
  }

  static Future<dynamic>? pushNamed(String route,
      {RouteType type = RouteType.left, Map<String, dynamic>? args}) {
    args ??= <String, dynamic>{};
    args["routeType"] = type;
    return key.currentState!.pushNamed(
      route,
      arguments: args,
    );
  }

  static Future<dynamic> pushRoute(String route,
      {RouteType type = RouteType.left, Map? args}) async {
    args ??= <String, dynamic>{};
    args["routeType"] = type;
    return await key.currentState!.pushNamed(
      route,
      arguments: args,
    );
  }

  static Future<dynamic>? pushReplacementNamed(String route,
      {RouteType type = RouteType.left, Map? args}) {
    args ??= <String, dynamic>{};
    args["routeType"] = type;
    return key.currentState!.pushReplacementNamed(
      route,
      arguments: args,
    );
  }

  static Future<dynamic>? pushNamedAndRemoveUntil(String route,
      {RouteType type = RouteType.left, Map? args}) {
    args ??= <String, dynamic>{};
    args["routeType"] = type;
    return key.currentState!.pushNamedAndRemoveUntil(
      route,
      ModalRoute.withName(HomeScreen.route),
      arguments: args,
    );
  }

  static RoutePredicate namePredicate(List<String> names) {
    return (route) =>
        !route.willHandlePopInternally &&
        route is ModalRoute &&
        (names.contains(route.settings.name));
  }
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final routeName = settings.name;
  final arguments = settings.arguments as Map<String, dynamic>? ?? {};
  final routeType =
      arguments["routeType"] as RouteType? ?? RouteType.defaultRoute;

  Widget? screen;

  switch (routeName) {
    case LoginScreen.route:
      screen = const LoginScreen();
      break;
    case HomeScreen.route:
      screen = const HomeScreen();
      break;

// **** Student ****
    case StudentsFieldScreen.route:
      screen = const StudentsFieldScreen();
      break;
    case StudentListScreen.route:
      screen = StudentListScreen(
        args: arguments,
      );
      break;
    case StudentProfileScreen.route:
      screen = StudentProfileScreen(
        args: arguments,
      );
      break;
    case AddStudentDetails.route:
      screen = const AddStudentDetails();
      break;
    case UpdateStudent.route:
      screen = UpdateStudent(
        args: arguments,
      );
      break;

// **** Time Table ****
    case TimeTableScreen.route:
      screen = const TimeTableScreen();
      break;
    case AddTimeTable.route:
      screen = const AddTimeTable();
      break;
    case UpdateTimeTable.route:
      screen = UpdateTimeTable(
        args: arguments,
      );
      break;

// **** Staff List ****
    case StaffListScreen.route:
      screen = const StaffListScreen();
      break;
    case AddStaffDetailsScreen.route:
      screen = const AddStaffDetailsScreen();
      break;
    case StaffProfileScreen.route:
      screen = StaffProfileScreen(
        args: arguments,
      );
      break;
    case UpdateStaffScreen.route:
      screen = UpdateStaffScreen(
        args: arguments,
      );
      break;

// **** Notice ****
    case NoticeScreen.route:
      screen = const NoticeScreen();
      break;

    case CulturalFestivalNotice.route:
      screen = const CulturalFestivalNotice();
      break;
    case CollegeActivityNotice.route:
      screen = const CollegeActivityNotice();
      break;
    case SportsNoticeScreen.route:
      screen = const SportsNoticeScreen();
      break;
    case CompetitiveExamNotice.route:
      screen = const CompetitiveExamNotice();
      break;
    case JobVacancyNotice.route:
      screen = const JobVacancyNotice();
      break;
    case GeneralNotice.route:
      screen = const GeneralNotice();
      break;

// **** Add Notice ****
    case AddCulturalFestival.route:
      screen = const AddCulturalFestival();
      break;
    case AddCollegeActivityNotice.route:
      screen = const AddCollegeActivityNotice();
      break;
    case AddSportsNotice.route:
      screen = const AddSportsNotice();
      break;
    case AddCompetitiveExamNotice.route:
      screen = const AddCompetitiveExamNotice();
      break;
    case AddJobVacancyNotice.route:
      screen = const AddJobVacancyNotice();
      break;
    case AddGeneralNotice.route:
      screen = const AddGeneralNotice();
      break;

// **** Update Notice ****
    case UpdateCultureFestival.route:
      screen = UpdateCultureFestival(
        args: arguments,
      );
      break;
    case UpdateCollegeActivity.route:
      screen = UpdateCollegeActivity(
        args: arguments,
      );
      break;
    case UpdateSportNotice.route:
      screen = UpdateSportNotice(
        args: arguments,
      );
      break;
    case UpdateCompetitiveExam.route:
      screen = UpdateCompetitiveExam(
        args: arguments,
      );
      break;
    case UpdateJobVacancyNotice.route:
      screen = UpdateJobVacancyNotice(
        args: arguments,
      );
      break;
    case UpdateGeneralNotice.route:
      screen = UpdateGeneralNotice(
        args: arguments,
      );
      break;

// **** Materials ****
    case MaterialScreen.route:
      screen = const MaterialScreen();
      break;
    case AddMaterialScreen.route:
      screen = const AddMaterialScreen();
      break;

// **** Materials ****
    case AssignmentScreen.route:
      screen = const AssignmentScreen();
      break;
    case AddAssignmentScreen.route:
      screen = const AddAssignmentScreen();
      break;

// **** Course ****
    case CourseScreen.route:
      screen = const CourseScreen();
      break;
    case AddCourseScreen.route:
      screen = const AddCourseScreen();
      break;

// **** Course ****
    case ResultScreen.route:
      screen = const ResultScreen();
      break;
    case AddResultScreen.route:
      screen = const AddResultScreen();
      break;
  }

  switch (routeType) {
    case RouteType.fade:
      return FadeRoute(
        builder: (_) => screen!,
        settings: RouteSettings(name: routeName),
      );
    case RouteType.left:
      return SlideRoute(
        enterPage: screen!,
        direction: AxisDirection.left,
      );

    case RouteType.down:
      return SlideRoute(
        enterPage: screen!,
        direction: AxisDirection.down,
      );
    case RouteType.up:
      return SlideRoute(
        enterPage: screen!,
        direction: AxisDirection.up,
      );
    case RouteType.right:
      return SlideRoute(
        enterPage: screen!,
        direction: AxisDirection.right,
      );

    case RouteType.defaultRoute:
    default:
      return MaterialPageRoute(
        builder: (_) => screen!,
        settings: RouteSettings(name: routeName),
      );
  }
}
