import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manize/data/repo/waste_repo.dart';
import 'package:manize/data/repo/work_times_repository.dart';
import 'package:manize/data/waste.dart';
import 'package:manize/data/work_times.dart';
import 'package:manize/ui/rootscreens/addPackageScreen/add_package_screen.dart';
import 'package:manize/ui/rootscreens/collectPackageScreen/bloc/collect_package_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class CollectRequestScreen extends StatefulWidget {
  final Function(String wasteId) getWasteId;
  final Function(String timeid) getTimesLotId;
  final Function(String requestDate) getRequestDay;
  const CollectRequestScreen(
      {super.key,
      required this.getWasteId,
      required this.getTimesLotId,
      required this.getRequestDay});

  @override
  State<CollectRequestScreen> createState() => _CollectRequestScreenState();
}

class _CollectRequestScreenState extends State<CollectRequestScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<CollectPackageBloc>(
      create: (context) =>
          CollectPackageBloc(workTimesRepository, wasteRepository)
            ..add(CollectPackageStarted()),
      child: BlocBuilder<CollectPackageBloc, CollectPackageState>(
        builder: (context, state) {
          if (state is CollectPackageSuccess) {
            return Column(
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
                Text.rich(TextSpan(
                    text: 'تحویل به ماشین',
                    style: theme.textTheme.titleLarge!.copyWith(fontSize: 18),
                    children: [
                      const TextSpan(text: ' '),
                      TextSpan(
                          text: 'جمع آوری کننده پسماند',
                          style: theme.textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.w300))
                    ])),
                const SizedBox(
                  height: 24,
                ),
                WasteCart(
                  wasteList: state.wasteList,
                  theme: theme,
                  iconPath: 'assets/icons/trash_icon_black.svg',
                  title: "نوع پسماند",
                  getWasteId: (wasteId) {
                    setState(() {
                      widget.getWasteId(wasteId);
                    });
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                DayAndTimeCart(
                  theme: theme,
                  title: 'تاریخ و بازه زمانی دریافت پکیج',
                  iconPath: "assets/icons/history.svg",
                  iconBtnPath: "assets/icons/calendar.svg",
                  workTimes: state.timesList,
                  getTimeId: (timeid, startTime, endTime) {
                    setState(() {
                      widget.getTimesLotId(timeid);
                    });
                  },
                  getRequestDay: (requestDay) {
                    setState(() {
                      widget.getRequestDay(requestDay);
                    });
                  },
                )
              ],
            );
          } else {
            if (StepState is CollectPackageError) {
              return const Center(
                child: Text('error'),
              );
            } else {
              if (state is CollectSkletonLoading) {
                return AddAndCollectPackageSkeletonLoading.forCollectPackage();
              } else {
                throw Exception();
              }
            }
          }
        },
      ),
    );
  }
}

class WasteCart extends StatefulWidget {
  final List<WasteEntity> wasteList;
  final ThemeData theme;
  final String iconPath;
  final String title;
  final Function(String wasteId) getWasteId;
  const WasteCart(
      {super.key,
      required this.wasteList,
      required this.theme,
      required this.title,
      required this.getWasteId,
      required this.iconPath});

  @override
  State<WasteCart> createState() => _WasteCartState();
}

class _WasteCartState extends State<WasteCart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(blurRadius: 4, color: Colors.grey.shade600.withOpacity(0.3))
        ],
        color: const Color.fromARGB(255, 177, 215, 89),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Row(
            children: [
              SvgPicture.asset(
                widget.iconPath,
                width: 14,
                height: 14,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                widget.title,
                style: widget.theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        WorkTimesList.waste(
          wastes: widget.wasteList,
          getWasteId: (wasteId) {
            setState(() {
              widget.getWasteId(wasteId);
            });
          },
        ),
      ]),
    );
  }
}

class DayAndTimeCart extends StatefulWidget {
  final String title;
  final String iconPath;
  final String iconBtnPath;
  final List<WorkTimesEntity> workTimes;
  final ThemeData theme;
  final Function(String timeid, String startTime, String endTime) getTimeId;
  final Function(String requestDay) getRequestDay;
  const DayAndTimeCart({
    super.key,
    required this.theme,
    required this.title,
    required this.iconPath,
    required this.iconBtnPath,
    required this.workTimes,
    required this.getTimeId,
    required this.getRequestDay,
  });

  @override
  State<DayAndTimeCart> createState() => DayAndTimeCartState();
}

class DayAndTimeCartState extends State<DayAndTimeCart>
    with SingleTickerProviderStateMixin {
  final textGreenColor = const Color.fromARGB(255, 138, 179, 44);
  late final AnimationController animationController = AnimationController(
      vsync: this,
      reverseDuration: Duration(milliseconds: 500),
      upperBound: 1.1,
      lowerBound: 0.4 ,
      
      duration: Duration(milliseconds: 1500))
    ..repeat();
    double scale=0;
 
  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  Jalali? dayPicked = null;
  String? startTimeSelected = null;
  String? endTimeSelected = null;
  String? suffixTime = null;
  @override
  Widget build(BuildContext context) {
    debugPrint('aaaaaaaa');
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(blurRadius: 4, color: Colors.grey.shade600.withOpacity(0.3))
        ],
        color: const Color.fromARGB(255, 177, 215, 89),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Row(
              children: [
                SvgPicture.asset(
                  widget.iconPath,
                  width: 14,
                  height: 14,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  widget.title,
                  style: widget.theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dayPicked == null
                    ? Text(
                        'لطفا تاریخ درخواست را مشخص کنید',
                        style: widget.theme.textTheme.bodySmall,
                      )
                    : Text(dayPicked!.formatMediumDate().toString(),
                        style: widget.theme.textTheme.bodyMedium),
                Stack(
                  children: [
                    AnimatedBuilder(
                      builder: (context, child) {
                        return AnimatedScale(
                          scale:scale ==0.85?scale: animationController.value,
                          duration: animationController.duration!,
                          
                          child: Container(
                            width: 37,
                            height: 37,
                            decoration: BoxDecoration(
                                color: widget.theme.colorScheme.secondary
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(32.5)),
                          ),
                        );
                      },
                      animation: animationController,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 2,
                      top: 0,
                      child: InkWell(
                        onTap: () async {
                          Jalali? picked = await showPersianDatePicker(
                            initialEntryMode: PDatePickerEntryMode.calendarOnly,
                            initialDatePickerMode: PDatePickerMode.day,
                            context: context,
                            initialDate: Jalali.now().addDays(1),
                            firstDate: Jalali.now().addDays(1),
                            lastDate: Jalali.now().addDays(5),
                          );
                          picked != null
                              ? setState(() {
                                  dayPicked = picked;
                                  widget.getRequestDay(
                                      picked.toDateTime().toString());
                                      scale=0.85;
                                      animationController.stop(canceled: false);
                                      
                                })
                              : null;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            widget.iconBtnPath,
                            width: 17,
                            height: 17,
                            color: widget.theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: widget.theme.colorScheme.primary,
            endIndent: 24,
            indent: 24,
          ),
          WorkTimesList.workTime(
            workTimes: widget.workTimes,
            color: textGreenColor,
            getTimeId: (id, startTime, endTime) {
              setState(() {
                widget.getTimeId(id, startTime, endTime);
                startTimeSelected = startTime.split(":").first;
                endTimeSelected = endTime.split(":").first;

                if (int.parse(endTimeSelected!) <= 12) {
                  suffixTime = "قبل از ظهر";
                } else {
                  suffixTime = "بعد از ظهر";
                }
              });
            },
          ),
          const SizedBox(
            height: 2,
          ),
          startTimeSelected != null && endTimeSelected != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 32, bottom: 12),
                  child: Text(
                    "ساعت ${startTimeSelected} تا ${endTimeSelected}" +
                        " " +
                        "$suffixTime",
                    style: widget.theme.textTheme.bodySmall!.copyWith(),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
