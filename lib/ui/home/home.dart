import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manize/common/utils.dart';
import 'package:manize/data/address.dart';
import 'package:manize/data/product_entity.dart';
import 'package:manize/data/waste.dart';
import 'package:manize/main.dart';
import 'package:manize/ui/bottomSheet/bottom_sheet.dart';
import 'package:manize/ui/home/bloc/home_bloc.dart';
import 'package:manize/ui/map/map_screen.dart';
import 'package:manize/ui/menu/menuScreen.dart';
import 'package:manize/ui/profile/profile.dart';
import 'package:manize/ui/rootscreens/addPackageScreen/add_package_screen.dart';
import 'package:manize/ui/widgets/app_slider.dart';
import 'package:manize/ui/widgets/image.dart';
import 'package:shimmer/shimmer.dart';


final GlobalKey<ScaffoldMessengerState> scaffoldMessengerStateHome =
    GlobalKey();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final Color appBarColor =
      const Color.fromARGB(110, 213, 216, 226).withOpacity(0.3);
  HomeBloc? homeBloc;
  StreamSubscription<HomeState>? streamSubscription;

  @override
  void dispose() {
    // TODO: implement dispose
    homeBloc?.close();
    streamSubscription?.cancel();
    scaffoldMessengerStateHome.currentState!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: ScaffoldMessenger(
        key: scaffoldMessengerStateHome,
        child: BlocProvider<HomeBloc>(
          create: (context) {
            final bloc = context.read<HomeBloc>()..add(HomeStarted());
            homeBloc = bloc;
            streamSubscription = bloc.stream.listen((event) {});
            return bloc;
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: FlotBtn(
                    nextIconPath: 'assets/icons/add_home_icon.svg',
                    isLoading: state is HomeLoading ? true : false,
                    backIconPath: null,
                    inHome: true,
                    borderColor: state is HomeError
                        ? Colors.redAccent
                        : Colors.transparent,
                    next: () {
                      if (state is HomeError) {
                        () {};
                      } else {
                        showModalBottomSheet(
                            elevation: 6,
                            backgroundColor: theme.colorScheme.primary,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12.0),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return BottomSheetScreen();
                            });
                      }
                    },
                    back: () {}),
                body: state is HomeSuccess ||
                        state is HomeLoading ||
                        state is HomeSkeletonLoading
                    ? Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(24, 36, 24, 32),
                            width: MediaQuery.of(context).size.width,
                            color: appBarColor,
                            child: Column(
                              children: [
                                AppBarItems(theme: theme),
                                const SizedBox(
                                  height: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: theme.colorScheme.primary,
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/icons/Shape.svg',
                                          width: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 46,
                                      ),
                                      RankAndScoreItems(
                                        theme: theme,
                                        number: state is HomeSuccess
                                            ? state.homeResponse.score
                                            : "",
                                        title: 'امتیاز',
                                        iconPath: 'assets/icons/score_icon.svg',
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 32, left: 32),
                                        height: 70,
                                        width: 1,
                                        color: theme.dividerColor,
                                      ),
                                      RankAndScoreItems(
                                        theme: theme,
                                        number: state is HomeSuccess
                                            ? state.homeResponse.rank.toString()
                                            : "",
                                        title: 'رتبه',
                                        iconPath: 'assets/icons/rank_icon.svg',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: state is HomeSkeletonLoading
                                ? _AddressListSkeletonLoading()
                                : state is HomeLoading || state is HomeSuccess
                                    ? ListView.builder(
                                        padding:
                                            const EdgeInsets.only(bottom: 95),
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: 4,
                                        itemBuilder: (context, index) {
                                          switch (index) {
                                            case 0:
                                              return AddresListView(
                                                isLoading: state is HomeLoading
                                                    ? true
                                                    : false,
                                                theme: theme,
                                                addressList:
                                                    state is HomeSuccess
                                                        ? state.homeResponse
                                                            .addressList
                                                        : state is HomeLoading
                                                            ? state.addressList
                                                            : [],
                                                addBtnTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const MapScreem()));
                                                },
                                              );
                                            case 1:
                                              return state is HomeSuccess
                                                  ? state.homeResponse.wasteList
                                                          .isNotEmpty
                                                      ? HistoryListView(
                                                          theme: theme,
                                                          historyList: state
                                                              .homeResponse
                                                              .wasteList,
                                                          appBarColor:
                                                              appBarColor,
                                                        )
                                                      : const SizedBox()
                                                  : const SizedBox();

                                            case 2:
                                              return _ProductList(
                                                theme: theme,
                                                title: "خرید از کرمانسل",
                                                onTap: () {},
                                                productList:
                                                    state is HomeSuccess
                                                        ? state.productList
                                                        : state is HomeLoading
                                                            ? state.productList
                                                            : [],
                                              );
                                            case 3:
                                              return AppSlider(
                                                title:
                                                    'اجرای سبک زندگی مانیزه ای',
                                                theme: Theme.of(context),
                                                articelList:
                                                    state is HomeSuccess
                                                        ? state.articelList
                                                        : state is HomeLoading
                                                            ? []
                                                            : [],
                                              );
                                          }
                                        })
                                    : const SizedBox(),
                          ),
                        ],
                      )
                    : state is HomeError
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('لطفا اتصال اینترنت خود را برسی کنید'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('تلاش دوباره'),
                                  IconButton(
                                      onPressed: () {
                                        homeBloc!.add(HomeStarted());
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.refresh,
                                        size: 12,
                                      )),
                                ],
                              )
                            ],
                          ))
                        : throw Exception(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<ProductEntity> productList;
  final ThemeData theme;
  const _ProductList({
    super.key,
    required this.title,
    required this.onTap,
    required this.productList,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/bag.svg',
                width: 12,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                title,
                style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  final product = productList[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SizedBox(
                      width: 176,
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 176,
                                  height: 189,
                                  child: ImageLoadingService(
                                      imageUrl: product.imageSrc,
                                      borderRadius: BorderRadius.circular(12),)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.salePrice.isNotEmpty
                                                ? product
                                                    .salePrice.withPriceLable
                                                : product
                                                        .regularPrice.isNotEmpty
                                                    ? product.regularPrice
                                                        .withPriceLable
                                                    : product
                                                        .price.withPriceLable,
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                          product.salePrice.isNotEmpty
                                              ? Text(
                                                  product.regularPrice
                                                      .withPriceLable,
                                                  style: theme
                                                      .textTheme.bodySmall!
                                                      .copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          Uri url =
                                              Uri.parse(product.permalink);
                                          await LaunchInBrowser.launchInBrowser(
                                              url);
                                        },
                                        child: Text(
                                          'خرید',
                                          style: theme.textTheme.labelLarge!
                                              .copyWith(
                                                  color: theme
                                                      .colorScheme.onPrimary,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                        ))
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  );
                }),
          ),
        )
      ],
    );
  }
}

class AppBarItems extends StatelessWidget {
  const AppBarItems({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Image.asset(
                'assets/img/logo.png',
                height: 40,
                width: 40,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                'مانیزه',
                style: theme.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ProfieScreen())),
          child: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: theme.colorScheme.background,
                borderRadius: BorderRadius.circular(25)),
            child: SvgPicture.asset(
              'assets/icons/profile_icon.svg',
              width: 19,
              height: 19,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MenuScreen()));
            },
            splashRadius: 18,
            icon: SvgPicture.asset(
              'assets/icons/menu_icon.svg',
              width: 19,
              height: 20,
            ))
      ],
    );
  }
}

class AddresListView extends StatelessWidget {
  final List<AddressEntity> addressList;
  final bool isLoading;
  const AddresListView({
    super.key,
    required this.theme,
    required this.addressList,
    required this.addBtnTap,
    required this.isLoading,
  });

  final ThemeData theme;
  final Function() addBtnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/location_icon.svg',
                    width: 10,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    'آدرس ها',
                    style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
                  ),
                ],
              ),
              IconButton(
                  onPressed: addBtnTap,
                  splashRadius: 16,
                  icon: SvgPicture.asset(
                    'assets/icons/add.svg',
                    width: 24,
                  ))
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: addressList.isNotEmpty
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 0, 8, 0),
                  scrollDirection: Axis.horizontal,
                  itemCount: addressList.length,
                  itemBuilder: (context, index) {
                    final address = addressList[index];
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 4, left: 4),
                          width: 170.5,
                          height: 164.5,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      'assets/img/map.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)),
                                    onTap: () {
                                      isLoading
                                          ? () {}
                                          : BlocProvider.of<HomeBloc>(context)
                                              .add(HomeDeletAddressClicked(
                                                  address.id));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50.5,
                                      width: 53,
                                      decoration: BoxDecoration(
                                          color: theme.colorScheme.primary,
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20))),
                                      child: isLoading
                                          ? CupertinoActivityIndicator(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            )
                                          : SvgPicture.asset(
                                              'assets/icons/trash_icon.svg',
                                              width: 16,
                                            ),
                                    ),
                                  )),
                              Positioned(
                                  bottom: 0,
                                  top: 0,
                                  right: 0,
                                  left: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      'assets/icons/location_icon.svg',
                                      width: 20,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        SizedBox(
                            width: 70,
                            child: Text(
                              address.title,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            )),
                        SizedBox(
                          width: 100,
                          child: Text(
                            address.address,
                            style: theme.textTheme.bodySmall!
                                .copyWith(fontWeight: FontWeight.w300),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  })
              : Container(
                  //color: Colors.blue,
                  margin: EdgeInsets.only(right: 12, left: 12),
                  alignment: Alignment.centerRight,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(24),
                    padding: EdgeInsets.all(6),
                    strokeWidth: 1.7,
                    dashPattern: [6, 3],
                    color: theme.textTheme.bodySmall!.color!.withOpacity(0.5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: Container(
                        alignment: Alignment.center,
                        width: 170.5,
                        height: 164.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/location_icon.svg',
                              color: theme.textTheme.bodySmall!.color!
                                  .withOpacity(0.5),
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'آدرس',
                              style: theme.textTheme.headlineSmall!.copyWith(
                                fontSize: 20,
                                color: theme.textTheme.bodySmall!.color!
                                    .withOpacity(0.5),
                              ),
                            )
                          ],
                        ),
                        //color: Colors.amber,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class RankAndScoreItems extends StatelessWidget {
  const RankAndScoreItems({
    super.key,
    required this.theme,
    required this.iconPath,
    required this.title,
    required this.number,
  });

  final ThemeData theme;
  final String iconPath;
  final String title;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: theme.textTheme.titleLarge!.copyWith(fontSize: 18),
            ),
            Text(
              title,
              style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.w300),
            )
          ],
        ),
        const SizedBox(
          width: 18,
        ),
        SvgPicture.asset(
          iconPath,
          width: 18,
        )
      ],
    );
  }
}

class HistoryListView extends StatelessWidget {
  final List<WasteEntity> historyList;
  const HistoryListView({
    super.key,
    required this.theme,
    required this.historyList,
    required this.appBarColor,
  });

  final ThemeData theme;
  final Color appBarColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/icons/history.svg',
                width: 10,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                'تاریخچه',
                style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
        Container(
          height: 77.5,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 0, 8, 0),
              scrollDirection: Axis.horizontal,
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                // final historyItem = historyList[index];
                return Container(
                  padding: const EdgeInsets.fromLTRB(8, 0, 10, 0),
                  margin: const EdgeInsets.only(
                      right: 4, left: 4, top: 11, bottom: 11),
                  width: 125,
                  decoration: BoxDecoration(
                      color: appBarColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            historyList[index].title,
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            historyList[index].value + 'کیلو گرم',
                            style: theme.textTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                      SvgPicture.asset(
                        'assets/icons/box_history.svg',
                        width: 26,
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class _AddressListSkeletonLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final color = Colors.black38;
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          SizedBox(
              height: 280,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                  right: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Row(
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
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(left: 12, right: 8),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black38,
                                  ),
                                  width: 170,
                                  height: 164,
                                ),
                                TextLoadingPlace.small(
                                    width: width / 2, color: color),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextLoadingPlace.small(
                                    width: width / 3, color: color),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              )),
          const SizedBox(
            height: 24,
          ),
          SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: TextLoadingPlace(width: width, color: color),
                ),
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 125,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12)),
                        );
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
