import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:manize/data/repo/home_repo.dart';
import 'package:manize/ui/home/home.dart';
import 'package:manize/ui/map/bloc/map_screen_bloc.dart';

class MapScreem extends StatefulWidget {
  const MapScreem({Key? key}) : super(key: key);

  @override
  MapScreen createState() {
    return MapScreen();
  }
}

class MapScreen extends State<MapScreem> {
  late final MapController mapController = MapController();
  final pointSize = 40.0;
  StreamSubscription? streamSubscription;
  MapScreenBloc? mapScreenBloc;
  LatLng? latLng;
  bool isUpdatingPoint = true;

  final TextEditingController tittleAddressCOntroler = TextEditingController();
  final TextEditingController addressCOntroler = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    // TODO: implement dispose
    streamSubscription?.cancel();
    mapScreenBloc?.close();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      updatePoint(null, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pointY = MediaQuery.of(context).size.height / 2.65;
    return SafeArea(
      child: BlocProvider<MapScreenBloc>(
        create: (context) {
          final bloc = MapScreenBloc(homerepository)..add(MapStarted());
          mapScreenBloc = bloc;
          streamSubscription = bloc.stream.listen((state) {
            if (state is MapGetUserLocation) {
              mapController.move(LatLng(state.lat, state.long), 18);
            } else if (state is MapScreenError || state is MapScreenSuccess) {
              if (state is MapScreenSuccess) {
                scaffoldMessengerStateHome.currentState!
                    .showSnackBar(SnackBar(content: Text(state.messege)));
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('خطا در برقراری ارتیاط لطفا دوباره تلاش کنید')));
              }
            }
          });
          return bloc;
        },
        child: BlocBuilder<MapScreenBloc, MapScreenState>(
          builder: (context, state) {
            return Scaffold(
                backgroundColor: Color.fromARGB(255, 248, 249, 253),
                body: Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: 75,
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: AppBarItems(theme: theme),
                    ),
                    state is MapScreenInitial ||
                            state is MapGetUserLocation ||
                            state is MapScreenSuccess ||
                            state is MapScreenError ||
                            state is MapScreenLoading
                        ? Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                              child: Stack(
                                children: [
                                  FlutterMap(
                                    mapController: mapController,
                                    options: MapOptions(
                                        onMapEvent: (event) {
                                          isUpdatingPoint
                                              ? updatePoint(null, context)
                                              : null;
                                        },
                                        center:
                                            const LatLng(30.291089, 57.062851),
                                        zoom: 18,
                                        minZoom: 7,
                                        maxZoom: 18),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName:
                                            'dev.fleaflet.flutter_map.example',
                                      ),
                                      if (latLng != null)
                                        MarkerLayer(
                                          markers: [
                                            Marker(
                                              width: pointSize,
                                              height: pointSize,
                                              point: latLng!,
                                              builder: (ctx) =>
                                                  const SizedBox(),
                                            )
                                          ],
                                        ),
                                    ],
                                  ),
                                  Positioned(
                                      top: pointY - pointSize / 2.65,
                                      left: _getPointX(context) -
                                          pointSize / 2.65,
                                      child: _Marker()),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    left: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 12),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: theme
                                                      .colorScheme.primary),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        18, 18, 18, 0),
                                                child: Column(
                                                  children: [
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: TextField(
                                                        cursorColor: theme
                                                            .textTheme
                                                            .bodySmall!
                                                            .color,
                                                        onTap: () {
                                                          setState(() {
                                                            isUpdatingPoint =
                                                                false;
                                                          });
                                                        },
                                                        controller:
                                                            tittleAddressCOntroler,
                                                        keyboardType:
                                                            TextInputType
                                                                .streetAddress,
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        textAlign:
                                                            TextAlign.start,
                                                        decoration:
                                                            InputDecoration(
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: theme
                                                                            .dividerColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            14)),
                                                                disabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: theme
                                                                            .textTheme
                                                                            .bodySmall!
                                                                            .color!),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            14)),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: theme
                                                                            .textTheme
                                                                            .bodySmall!
                                                                            .color!),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            14)),
                                                                label: Text('اسم آدرس', style: theme.textTheme.bodySmall!),
                                                                // hintText: 'کد تایید را وارد کنید',
                                                                hintStyle: theme.textTheme.bodySmall!.copyWith(fontSize: 14, color: theme.textTheme.bodySmall!.color!.withOpacity(0.5))),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: TextField(
                                                        cursorColor: theme
                                                            .textTheme
                                                            .bodySmall!
                                                            .color,
                                                        maxLines: 5,
                                                        minLines: 1,
                                                        onTap: () {
                                                          setState(() {
                                                            isUpdatingPoint =
                                                                false;
                                                          });
                                                        },
                                                        controller:
                                                            addressCOntroler,
                                                        keyboardType:
                                                            TextInputType
                                                                .streetAddress,
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        textAlign:
                                                            TextAlign.start,
                                                        decoration:
                                                            InputDecoration(
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: theme
                                                                            .dividerColor),
                                                                    borderRadius: BorderRadius.circular(
                                                                        14)),
                                                                disabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: theme
                                                                            .textTheme
                                                                            .bodySmall!
                                                                            .color!),
                                                                    borderRadius: BorderRadius.circular(
                                                                        14)),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: theme
                                                                            .textTheme
                                                                            .bodySmall!
                                                                            .color!),
                                                                    borderRadius: BorderRadius.circular(
                                                                        14)),
                                                                label: Text(
                                                                  'آدرس دقیق',
                                                                  style: theme
                                                                      .textTheme
                                                                      .bodySmall!,
                                                                ),
                                                                // hintText: 'کد تایید را وارد کنید',
                                                                hintStyle: theme
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .copyWith(fontSize: 14, color: theme.textTheme.bodySmall!.color!.withOpacity(0.5))),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 18,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          FloatingActionButton(
                                            child: state is MapScreenLoading
                                                ? Center(
                                                    child:
                                                        CupertinoActivityIndicator(),
                                                  )
                                                : SvgPicture.asset(
                                                    'assets/icons/add_n.svg',
                                                    width: 38,
                                                  ),
                                            onPressed: state is MapScreenLoading
                                                ? () {}
                                                : () {
                                                    if (addressCOntroler
                                                            .text.isNotEmpty ||
                                                        tittleAddressCOntroler
                                                            .text.isNotEmpty) {
                                                      mapScreenBloc!.add(
                                                          MapAddAddress(
                                                              tittleAddressCOntroler
                                                                  .text,
                                                              addressCOntroler
                                                                  .text,
                                                              latLng!.latitude
                                                                  .toString(),
                                                              latLng!.longitude
                                                                  .toString(),
                                                              context));
                                                    }
                                                  },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    child: FloatingActionButton.small(
                                      child: const Icon(
                                        Icons.location_searching_rounded,
                                        size: 22,
                                      ),
                                      onPressed: () {
                                        mapScreenBloc!
                                            .add(MapUserLocationTap());
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : throw Exception(),
                  ],
                ));
          },
        ),
      ),
    );
  }

  void updatePoint(MapEvent? event, BuildContext context) {
    final pointX = _getPointX(context);
    final pointY = MediaQuery.of(context).size.height / 2.65;

    setState(() {
      latLng = mapController.pointToLatLng(CustomPoint(pointX, pointY));
    });
  }

  double _getPointX(BuildContext context) {
    return MediaQuery.of(context).size.width / 2;
  }
}

class _Marker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/icons/background_marker.svg',
          width: 40,
        ),
        SvgPicture.asset(
          'assets/icons/marker.svg',
          width: 40,

          // color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
