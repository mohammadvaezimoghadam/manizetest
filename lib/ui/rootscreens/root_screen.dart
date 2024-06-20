import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manize/data/repo/package_request_repo.dart';
import 'package:manize/main.dart';

import 'package:manize/ui/home/home.dart';
import 'package:manize/ui/rootscreens/addPackageScreen/add_package_screen.dart';
import 'package:manize/ui/rootscreens/addSuccessScreen/addSuccessScreen.dart';
import 'package:manize/ui/rootscreens/bloc/root_screen_bloc.dart';
import 'package:manize/ui/rootscreens/collectPackageScreen/collect_package_Screen.dart';
import 'package:manize/ui/rootscreens/rating/rating.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

const int addPackageScreenIndex = 0;
const int collectPackageScreenIndex = 1;
const int ratingPackageScreenIndex = 2;
const int addPackageSuccessIndex = 3;

class RootForAddAndCollect extends StatefulWidget {
  late int selectedScreenIndex;
  final String addressId;
  final List<int>? packageRequests;
  final List<int>? collectRequests;

  RootForAddAndCollect.addPackage({
    super.key,
    this.selectedScreenIndex = addPackageScreenIndex,
    required this.addressId,
  })  : packageRequests = null,
        collectRequests = null;
  RootForAddAndCollect.rating({
    super.key,
    this.selectedScreenIndex = ratingPackageScreenIndex,
    this.addressId = "",
    required this.packageRequests,
    required this.collectRequests,
  });
  RootForAddAndCollect.collectRequest({
    super.key,
    this.selectedScreenIndex = collectPackageScreenIndex,
    required this.addressId,
  })  : packageRequests = null,
        collectRequests = null;
  RootForAddAndCollect.addSuccess({
    super.key,
    this.selectedScreenIndex = addPackageSuccessIndex,
    this.addressId = "",
  })  : packageRequests = null,
        collectRequests = null;

  @override
  State<RootForAddAndCollect> createState() => _RootForAddAndCollectState();
}

class _RootForAddAndCollectState extends State<RootForAddAndCollect> {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey();

  @override
  void dispose() {
    // TODO: implement dispose
    scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  RootScreenBloc? rootScreenBloc;
  StreamSubscription<RootScreenState>? streamSubscription;
  late String requestDateRoot="";
  late String timesLotIdRoot="";
  late String wasteIdRoot="";
  late String? tody;
  late String? startTimeforSuccess;
  late String? endTimeforSuccess;
  late String? requestDay;
  late String trackingCode;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: ScaffoldMessenger(
        key: scaffoldKey,
        child: Scaffold(
          
          floatingActionButton: BlocProvider<RootScreenBloc>(
            create: (context) {
              final bloc = RootScreenBloc(packageRequestRepository);
              rootScreenBloc = bloc;
              streamSubscription = bloc.stream.listen((state) {
                if (state is RootScreenSuccess) {
                  scaffoldKey.currentState!.showSnackBar(const SnackBar(content: Text('در خواست شما با موفقیت ثبت شد')));
                  if (widget.selectedScreenIndex == collectPackageScreenIndex) {
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      trackingCode = state.packageInfo.trackingCode;
                      widget.selectedScreenIndex = addPackageSuccessIndex;
                    });
                  }
                } else if (state is RootScreenError) {
                  scaffoldKey.currentState!
                      .showSnackBar(SnackBar(content: Text(state.errorMessage)));
                }
              });
              return bloc;
            },
            child: BlocBuilder<RootScreenBloc, RootScreenState>(
              builder: (context, state) {
                return widget.selectedScreenIndex == ratingPackageScreenIndex
                    ? SizedBox()
                    : FlotBtn(
                        nextIconPath:
                            widget.selectedScreenIndex == addPackageScreenIndex ||
                                    widget.selectedScreenIndex ==
                                        ratingPackageScreenIndex ||
                                    widget.selectedScreenIndex ==
                                        addPackageSuccessIndex
                                ? "assets/icons/add_n.svg"
                                : widget.selectedScreenIndex ==
                                        collectPackageScreenIndex
                                    ? "assets/icons/delivery_icon_4.svg"
                                    : "",
                        backIconPath: 'assets/icons/close_address.svg',
                        size: 36,
                        isLoading: state is RootScreenLoading ? true : false,
                        padding: const EdgeInsets.only(right: 88),
                        inAddAndColectPackage: true,
                        next: () {
                          switch (widget.selectedScreenIndex) {
                            case addPackageScreenIndex:
                              if (requestDateRoot.isNotEmpty &&
                                  timesLotIdRoot.isNotEmpty) {
                                BlocProvider.of<RootScreenBloc>(context).add(
                                    AddPackageEvent(
                                        requestDateRoot.split(" ").first,
                                        widget.addressId,
                                        timesLotIdRoot));
                              }
                            case collectPackageScreenIndex:
                              if (requestDateRoot.isNotEmpty &&
                                  timesLotIdRoot.isNotEmpty &&
                                  wasteIdRoot.isNotEmpty) {
                                BlocProvider.of<RootScreenBloc>(context).add(
                                    CollectPackageEvent(
                                        requestDateRoot.split(" ").first,
                                        widget.addressId,
                                        timesLotIdRoot,
                                        wasteIdRoot));
                              }
                            case addPackageSuccessIndex:
                              Navigator.pop(context);
                          }
                        },
                        back: () {
                          Navigator.pop(context);
                        });
              },
            ),
          ),
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: AppBarItems(theme: theme),
            ),
            Expanded(
                child: Container(
                    alignment: Alignment.topCenter,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32))),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                        child: Builder(builder: (context) {
                          switch (widget.selectedScreenIndex) {
                            case addPackageScreenIndex:
                              return AddPackageScreen(
                                getTimesLotId: (timesLotId, startTime, endTime) {
                                  setState(() {
                                    timesLotIdRoot = timesLotId;
                                    startTimeforSuccess = startTime;
                                    endTimeforSuccess = endTime;
                                  });
                                },
                                getRequestDay: (String requestDate) {
                                  setState(() {
                                    final year = int.parse(requestDate
                                        .split(' ')
                                        .first
                                        .split("-")
                                        .first);
                                    final month = int.parse(requestDate
                                        .split(' ')
                                        .first
                                        .split("-")[1]);
                                    final day = int.parse(requestDate
                                        .split(' ')
                                        .first
                                        .split("-")
                                        .last);
                                    requestDateRoot = requestDate;
                                    requestDay = Jalali.fromDateTime(
                                            DateTime(year, month, day, 0, 0))
                                        .formatFullDate();
                                  });
                                },
                              );
        
                            case ratingPackageScreenIndex:
                              return RatingScreen(
                                packageRequests: widget.packageRequests!,
                                collectRequests: widget.collectRequests!,
                              );
                            case collectPackageScreenIndex:
                              return CollectRequestScreen(
                                getRequestDay: (String requestDate) {
                                  setState(() {
                                    requestDateRoot = requestDate;
                                  });
                                },
                                getTimesLotId: (String timeid) {
                                  setState(() {
                                    timesLotIdRoot = timeid;
                                  });
                                },
                                getWasteId: (String wasteId) {
                                  wasteIdRoot = wasteId;
                                },
                              );
                            case addPackageSuccessIndex:
                              return AddSuccessPackageScreen(
                                requestDay: requestDay!,
                                time:
                                    "ساعت ${startTimeforSuccess!.split(':').first} تا ${endTimeforSuccess!.split(':').first}",
                                today: Jalali.now().formatFullDate().toString(),
                                trackingCode: trackingCode,
                              );
        
                            default:
                              return Container();
                          }
                        }),
                      ),
                    )))
          ]),
        ),
      ),
    );
  }
}
