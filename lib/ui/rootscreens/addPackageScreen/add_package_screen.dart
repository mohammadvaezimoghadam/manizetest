import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manize/data/repo/work_times_repository.dart';
import 'package:manize/data/waste.dart';
import 'package:manize/data/work_times.dart';
import 'package:manize/ui/rootscreens/addPackageScreen/bloc/add_package_bloc.dart';
import 'package:manize/ui/rootscreens/collectPackageScreen/collect_package_Screen.dart';
import 'package:shimmer/shimmer.dart';

class AddPackageScreen extends StatefulWidget {
  final Function(String timesLotId,String startTime,String endTime) getTimesLotId;
  final Function(String requestDate) getRequestDay;
  const AddPackageScreen(
      {super.key, required this.getTimesLotId, required this.getRequestDay});

  @override
  State<AddPackageScreen> createState() => _AddPackageScreenState();
}

class _AddPackageScreenState extends State<AddPackageScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<AddPackageBloc>(
      create: (context) =>
          AddPackageBloc(workTimesRepository)..add(AddPackageStarted()),
      child: BlocBuilder<AddPackageBloc, AddPackageState>(
        builder: (context, state) {
          if (state is AddPackageSuccess) {
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
                Text(
                  'درخواست پکیج',
                  style: theme.textTheme.titleLarge!.copyWith(fontSize: 18),
                ),
                Text(
                  'جمع آوری پسماند خشک',
                  style: theme.textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 24,
                ),
                DayAndTimeCart(
                  getTimeId: (timeid,startTime, endTime) {
                    setState(() {
                      widget.getTimesLotId(timeid,startTime,endTime);
                    });
                  },
                  iconPath: 'assets/icons/history.svg',
                  iconBtnPath: 'assets/icons/calendar.svg',
                  title: 'تاریخ و بازه زمانی دریافت پکیج',
                  workTimes: state.workTimes,
                  theme: theme,
                  getRequestDay: (String requestDay) {
                    setState(() {
                      widget.getRequestDay(requestDay);
                    });
                  },
                ),
              ],
            );
          } else {
            if (state is AddPackageError) {
              return Center(
                child: Text('error'),
              );
            } else {
              if (state is AddPackageLoading) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              } else {
                if (state is AddPackageSkletonLoading) {
                  return AddAndCollectPackageSkeletonLoading.forAddPackage();
                } else {
                  throw Exception();
                }
              }
            }
          }
        },
      ),
    );
  }
}

class WorkTimesList extends StatefulWidget {
  final List<WorkTimesEntity>? workTimes;
  final List<WasteEntity>? wastes;
  final Color color;
  final Function(String id, String startTime, String endTime)? getTimeId;
  final Function(String wasteId)? getWasteId;
  const WorkTimesList.workTime({
    super.key,
    required this.workTimes,
    this.color = const Color.fromARGB(255, 138, 179, 44),
    required this.getTimeId,
  })  : wastes = null,
        getWasteId = null;
  const WorkTimesList.waste({
    super.key,
    required this.wastes,
    this.color = const Color.fromARGB(255, 138, 179, 44),
    required this.getWasteId,
  })  : workTimes = null,
        getTimeId = null;

  @override
  State<WorkTimesList> createState() => WorkTimesListState();
}

class WorkTimesListState extends State<WorkTimesList> {
  int selectedWorkTimeItem = 0;
  int? clickedId = null;
  late List<WorkTimeItems> workTimesList = [];
  late List<WorkTimeItems> wasteEntityList = [];
  bool isLoading = true;

  Future<void> _makeListWorkTimes(List<WorkTimesEntity> list) async {
    list.forEach((workTimesEntity) {
      workTimesList.add(WorkTimeItems.workTime(
        workTime: workTimesEntity,
        isActive: selectedWorkTimeItem == workTimesEntity.id,
        color: widget.color,
        onTapForWorkTime: (id, startTime, endTime) {
          setState(() {
            selectedWorkTimeItem = id;
            widget.getTimeId!(id.toString(), startTime, endTime);
            workTimesList.clear();
            _makeListWorkTimes(list);
          });
        },
      ));
    });
  }

  Future<void> _makeListWaste(List<WasteEntity> list) async {
    list.forEach((waste) {
      wasteEntityList.add(WorkTimeItems.waste(
        waste: waste,
        isActive: selectedWorkTimeItem == waste.id,
        color: widget.color,
        onTapForWaste: (wasteId) {
          setState(() {
            selectedWorkTimeItem = int.parse(wasteId);
            widget.getWasteId!(wasteId);
            wasteEntityList.clear();
            _makeListWaste(list);
          });
        },
      ));
    });
  }

  Future<void> _initialList() async {
    widget.wastes == null
        ? await _makeListWorkTimes(widget.workTimes!)
            .then((value) => setState(() {
                  isLoading = false;
                  wasteEntityList = [];
                  // isLoading != (workTimesList.length == list.length);
                }))
        : await _makeListWaste(widget.wastes!).then((value) => setState(() {
              isLoading = false;
              workTimesList = [];
            }));
  }

  @override
  void initState() {
    _initialList();
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == false
        ? SizedBox(
            height: 50,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 26, right: 40, bottom: 10),
                    child: Row(
                      children: wasteEntityList.isEmpty
                          ? workTimesList
                          : wasteEntityList,
                    ),
                  ),
                )),
          )
        : CupertinoActivityIndicator();
  }
}

class WorkTimeItems extends StatelessWidget {
  final WorkTimesEntity? workTime;
  final WasteEntity? waste;
  final bool isActive;
  final Color color;
  final Function(int id, String startTime, String endTime)? onTapForWorkTime;
  final Function(String wasteId)? onTapForWaste;

  const WorkTimeItems.workTime({
    super.key,
    required this.workTime,
    required this.isActive,
    required this.color,
    required this.onTapForWorkTime,
  })  : waste = null,
        onTapForWaste = null;
  const WorkTimeItems.waste({
    super.key,
    required this.waste,
    required this.isActive,
    required this.color,
    required this.onTapForWaste,
  })  : workTime = null,
        onTapForWorkTime = null;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        waste == null
            ? onTapForWorkTime!(
                workTime!.id, workTime!.startTime, workTime!.endTime)
            : onTapForWaste!(waste!.id.toString());
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: isActive
              ? Container(
                  height: 28,
                  padding: EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(12)),
                  alignment: Alignment.center,
                  child: waste == null
                      ? Text(
                          workTime!.startTime.split(":").removeAt(0) +
                              " - " +
                              workTime!.endTime.split(":").removeAt(0),
                          style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          waste!.title,
                          style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                )
              : Text(
                  waste == null
                      ? workTime!.startTime.split(":").removeAt(0) +
                          " - " +
                          workTime!.endTime.split(":").removeAt(0)
                      : waste!.title,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
      ),
    );
  }
}

class AddAndCollectPackageSkeletonLoading extends StatelessWidget {
 final bool inAddPackage;

  const AddAndCollectPackageSkeletonLoading.forAddPackage({super.key,  this.inAddPackage=true});
  const AddAndCollectPackageSkeletonLoading.forCollectPackage({super.key,  this.inAddPackage=false});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Colors.white24;
    final double width = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40), color: color),
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            width: width / 4,
            height: 12,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: color),
          ),
          const SizedBox(
            height: 25,
          ),
        inAddPackage==false?  Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24), color: color),
            child: Padding(
              padding: const EdgeInsets.only(top: 12, right: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width / 4,
                    height: 12,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: color),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 0, 12),
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _ListItemsSkletonLoading(
                              width: width, color: color),
                          const SizedBox(
                            width: 8,
                          ),
                          _ListItemsSkletonLoading(
                              width: width, color: color),
                          const SizedBox(
                            width: 8,
                          ),
                          _ListItemsSkletonLoading(
                              width: width, color: color),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ):const SizedBox(),
          const SizedBox(
            height: 12,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24), color: color),
            child: Padding(
              padding: const EdgeInsets.only(top: 12, right: 14, left: 24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width / 4,
                      height: 12,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: color),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextLoadingPlace(width: width, color: color),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: color),
                        ),
                      ],
                    ),
                    Divider(
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: width / 3,
                      height: 12,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: color),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Row(
                        children: [
                          _ListItemsSkletonLoading(
                              width: width, color: color),
                          const SizedBox(
                            width: 8,
                          ),
                          _ListItemsSkletonLoading(
                              width: width, color: color),
                          const SizedBox(
                            width: 8,
                          ),
                          _ListItemsSkletonLoading(
                              width: width, color: color),
                          const SizedBox(
                            width: 8,
                          ),
                          _ListItemsSkletonLoading(
                              width: width, color: color),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

class TextLoadingPlace extends StatelessWidget {
 final bool small;
  const TextLoadingPlace({
    super.key,
    required this.width,
    required this.color,  this.small=false,
  });
    const TextLoadingPlace.small({
    super.key,
    required this.width,
    required this.color,  this.small=true,
  });

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width / 3,
      height:small==true?5: 12,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color),
    );
  }
}

class _ListItemsSkletonLoading extends StatelessWidget {
  const _ListItemsSkletonLoading({
    super.key,
    required this.width,
    required this.color,
  });

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width / 7,
      height: 28,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), color: color),
    );
  }
}
