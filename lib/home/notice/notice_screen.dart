import '../../libs.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);
  static const route = 'notice';

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, title: 'Notice'),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                animation(
                  context,
                  seconds: 500,
                  horizontalOffset: -100,
                  verticalOffset: 100,
                  child: NoticeCard(
                    title: "Culture Festival",
                    icon: "assets/icons/culture_festival.png",
                    onPress: () async {
                      await CulturalFestivalApi.fetchData();
                      AppNavigation.shared.moveToCulturalFestivalScreen();
                      setState(() {});
                    },
                  ),
                ),
                animation(
                  context,
                  seconds: 500,
                  horizontalOffset: 100,
                  verticalOffset: -100,
                  child: NoticeCard(
                    title: "College Activity",
                    icon: "assets/icons/college_activity.png",
                    onPress: () async {
                      await CollegeActivityApi.fetchData();
                      AppNavigation.shared.moveToCollegeActivityScreen();
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                animation(
                  context,
                  seconds: 500,
                  horizontalOffset: -100,
                  verticalOffset: 100,
                  child: NoticeCard(
                    title: "Sports",
                    icon: "assets/icons/sport.png",
                    onPress: () async {
                      await SportsApi.fetchData();
                      AppNavigation.shared.moveToSportsScreen();
                      setState(() {});
                    },
                  ),
                ),
                animation(
                  context,
                  seconds: 500,
                  horizontalOffset: 100,
                  verticalOffset: -100,
                  child: NoticeCard(
                    title: "Competitive Exam",
                    icon: "assets/icons/exam.png",
                    onPress: () async {
                      await CompetitiveExamApi.fetchData();
                      AppNavigation.shared.moveToCompatitiveExamScreen();
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                animation(
                  context,
                  seconds: 500,
                  horizontalOffset: -100,
                  verticalOffset: 100,
                  child: NoticeCard(
                    title: "Job Vacancy",
                    icon: "assets/icons/job_vacancy.png",
                    onPress: () async {
                      await JobVacancyApi.fetchData();
                      AppNavigation.shared.moveToJobVacancyScreen();
                      setState(() {});
                    },
                  ),
                ),
                animation(
                  context,
                  seconds: 500,
                  horizontalOffset: 100,
                  verticalOffset: -100,
                  child: NoticeCard(
                    title: "General",
                    icon: "assets/icons/general.png",
                    onPress: () async {
                      await GeneralApi.fetchData();
                      AppNavigation.shared.moveToGeneralScreen();
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
