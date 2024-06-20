import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manize/data/address.dart';
import 'package:manize/data/repo/address_repo.dart';
import 'package:manize/data/repo/check_address_repo.dart';
import 'package:manize/ui/rootscreens/root_screen.dart';
import 'package:manize/ui/bottomSheet/bloc/bottom_sheet_bloc.dart';
import 'package:manize/ui/map/map_screen.dart';

class BottomSheetScreen extends StatefulWidget {
  const BottomSheetScreen({super.key});

  @override
  State<BottomSheetScreen> createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends State<BottomSheetScreen> {
  BottomSheetBloc? bottomSheetBloc;

  StreamSubscription<BottomSheetState>? streamSubscription;

  int? selectedIndexId = null;

  @override
  void dispose() {
    bottomSheetBloc?.close();
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<BottomSheetBloc>(
      create: (context) {
        final bloc = BottomSheetBloc(addressRepository, checkAddressRepository)
          ..add(BSheetStrted());
        bottomSheetBloc = bloc;
        streamSubscription = bloc.stream.listen((state) {
          if (state is BottomSheetCheckAddressResponse) {
            if (state.hasPackage) {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RootForAddAndCollect.collectRequest(
                        addressId: selectedIndexId.toString(),
                      )));
            } else {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RootForAddAndCollect.addPackage(
                        addressId: selectedIndexId.toString(),
                      )));
            }
          }
        });

        return bloc;
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Scaffold(
          body: BlocBuilder<BottomSheetBloc, BottomSheetState>(
            builder: (context, state) {
              if (state is BottomSheetSuccess) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 12),
                            height: 3,
                            width: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                                color: theme.dividerColor,
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width / 2 / 2)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'آدرس دریافت پکیج',
                                style: theme.textTheme.titleMedium!,
                              ),
                              TextButton(
                                onPressed: () {
                                  //fix:use a value listener for real time serch
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const MapScreem()));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "آدرس جدید",
                                      style: theme.textTheme.bodySmall!.apply(
                                          color: theme.colorScheme.primary),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    SvgPicture.asset(
                                      'assets/icons/add.svg',
                                      width: 12,
                                      height: 12,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: _AddressItemList(
                              setId: (id) {
                                setState(() {
                                  selectedIndexId = id;
                                });
                              },
                              theme: theme,
                              addressList: state.addressList,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 24,
                        left: 18,
                        child: FloatingActionButton.extended(
                            onPressed: () {
                              if (selectedIndexId != null) {
                                bottomSheetBloc!.add(BSheetCheckAddressClicked(
                                    selectedIndexId!));
                              }
                            },
                            label: Row(
                              children: [
                                const Text('تایید'),
                                const SizedBox(
                                  width: 8,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/add_n.svg',
                                  width: 16,
                                  height: 16,
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                );
              } else {
                if (state is BottomSheetError) {
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('دوباره تلاش کنید'),
                        IconButton(
                          onPressed: () {
                            BlocProvider.of<BottomSheetBloc>(context)
                                .add(BSheetRefreshClicked());
                          },
                          icon: const Icon(
                            CupertinoIcons.refresh,
                            size: 14,
                          ),
                          splashRadius: 12,
                        )
                      ],
                    ),
                  );
                } else {
                  if (state is BottomSheetLoading ||
                      state is BottomSheetCheckAddressResponse) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else {
                    if (state is BottomSheetEmptyState) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 12, bottom: 24),
                            height: 3,
                            width: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                                color: theme.dividerColor,
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width / 2 / 2)),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1.5,
                                    child: SvgPicture.asset(
                                      'assets/icons/empty_state_address.svg',
                                    ),
                                  ),
                                  const Text(
                                    'با ثبت آدرس های خود روند درخواست پکیج را سریعتر کنید',
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  OutlinedButton(
                                      style: ButtonStyle(
                                          side: MaterialStatePropertyAll(
                                              BorderSide(
                                                  color: theme
                                                      .colorScheme.primary))),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const MapScreem()))
                                            .then((value) =>
                                                Navigator.pop(context));
                                      },
                                      child: Text(' افزودن آدرس جدید')),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      throw Exception();
                    }
                  }
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

class _AddressItemList extends StatefulWidget {
  final List<AddressEntity> addressList;
  final ThemeData theme;
  final Function(int id) setId;

  _AddressItemList({
    super.key,
    required this.addressList,
    required this.theme,
    required this.setId,
  });

  @override
  State<_AddressItemList> createState() => _AddressItemListState();
}

class _AddressItemListState extends State<_AddressItemList> {
  int? selectedIndexId = null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 60),
          itemCount: widget.addressList.length,
          itemBuilder: (context, index) {
            return _AddressItem(
              onTap: (id) {
                setState(() {
                  selectedIndexId = id;
                  widget.setId(id);
                });
              },
              theme: widget.theme,
              addressList: widget.addressList,
              addressEntity: widget.addressList[index],
              isAvtive: selectedIndexId == widget.addressList[index].id,
            );
          }),
    );
  }
}

class _AddressItem extends StatelessWidget {
  final bool isAvtive;
  final AddressEntity addressEntity;
  final Function(int id) onTap;

  const _AddressItem({
    super.key,
    required this.theme,
    required this.addressList,
    required this.isAvtive,
    required this.addressEntity,
    required this.onTap,
  });

  final ThemeData theme;
  final List<AddressEntity> addressList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            onTap(addressEntity.id);
          },
          child: Container(
            height: 44,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
            decoration: BoxDecoration(),
            child: Row(
              children: [
                isAvtive
                    ? Container(
                        width: 1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0.75),
                            color: theme.colorScheme.primary.withOpacity(0.5)),
                      )
                    : const SizedBox(),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        addressEntity.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/location_icon.svg',
                            width: 8,
                            height: 8,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              addressEntity.address,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          endIndent: 38,
          indent: 38,
        )
      ],
    );
  }
}
