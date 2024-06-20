import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddSuccessPackageScreen extends StatelessWidget {
  final String trackingCode;
  final String today;
  final String requestDay;
  final String time;
  const AddSuccessPackageScreen(
      {super.key,
      required this.trackingCode,
      required this.today,
      required this.requestDay,
      required this.time});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color color = Color.fromARGB(255, 138, 179, 44);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color.fromARGB(255, 138, 179, 44),
            ),
            child: SvgPicture.asset(
              'assets/icons/add_home_icon.svg',
              width: 38,
              height: 38,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'پکیج' + " ",
                style: theme.textTheme.titleLarge!.copyWith(fontSize: 18),
              ),
              Text(
                trackingCode,
                style: theme.textTheme.titleLarge!.copyWith(fontSize: 18),
              ),
            ],
          ),
          Text(
            today,
            style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.w300),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(
                  right: 32,
                  left: MediaQuery.of(context).size.width / 6,
                  bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تحویل در تاریخ',
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                  _TimeAdndRequestDayItem(
                    color: color,
                    requestDay: requestDay,
                    title: requestDay,
                    theme: theme,
                  ),
                  Text(
                    'و بازه زمانی',
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                  _TimeAdndRequestDayItem(
                    color: color,
                    requestDay: requestDay,
                    title: time,
                    theme: theme,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "پکیج بازیافت شما در تاریخ مشخص شده توسط پیک مانیزه به دست شما خواهد رسید.",
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'با تشکر از همراهی شما',
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TimeAdndRequestDayItem extends StatelessWidget {
  final String title;
  final ThemeData theme;
  const _TimeAdndRequestDayItem({
    super.key,
    required this.color,
    required this.requestDay,
    required this.title,
    required this.theme,
  });

  final Color color;
  final String requestDay;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 2, right: 2),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Text(
          title,
          style: theme.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.w300),
        ));
  }
}
