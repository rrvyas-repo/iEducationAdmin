import '../libs.dart';

class ProfileDetailColumn extends StatelessWidget {
  const ProfileDetailColumn({
    Key? key,
    required this.title,
    required this.value,
    this.icon,
    this.iconSize,
    this.iconColor,
  }) : super(key: key);
  final String title;
  final String value;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(value, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.13,
              child: const Divider(
                thickness: 1.0,
              ),
            ),
          ],
        ),
        Icon(
          icon ?? Icons.lock_outline,
          size: iconSize ?? 10,
          color: iconColor ?? Colors.black,
        ),
      ],
    );
  }
}
