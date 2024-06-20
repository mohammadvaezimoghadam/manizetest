import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manize/data/base_response.dart';
import 'package:manize/data/last_trans.dart';
import 'package:manize/data/money.dart';
import 'package:manize/data/money_types.dart';
import 'package:manize/data/repo/cash_repo.dart';
import 'package:manize/data/wallet.dart';
import 'package:manize/ui/menu/cash/cashScreen.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

part 'cash_event.dart';
part 'cash_state.dart';

class CashBloc extends Bloc<CashEvent, CashState> {
  final ICashRepository cashRepository;
  late BaseResponse wallet;
  late ThemeData theme;

  late List<LastTransItem> lastItems;
  CashBloc(this.cashRepository) : super(CashLoading()) {
    on<CashEvent>((event, emit) async {
      if (event is CashStarted) {
        theme = event.theme;

        emit(CashLoading());
        try {
          // final respose = await cashRepository.getCash();
          wallet = await cashRepository.getUserWallet();
          if (wallet.error == true) {
            emit(CashError(wallet.body));
          } else {
            final walletEntity = wallet.body as WalletEntity;
            // final itemsList = await getCartItem(
            //     walletEntity.money, walletEntity.types, event.theme, context);
            lastItems =
                await getlastTransItems(walletEntity.lastTrans, event.theme);
            emit(CashSuccess(walletEntity.score.toString(), lastItems, "",
                wallet.body.money, wallet.body.types));
          }
        } catch (e) {
          emit(CashError("خطا در برقراری ارتباط"));
        }
      } else if (event is CashConvertScore) {
        debugPrint('aaaaaaa');
        // emit(CashDialogLoading(wallet.body.score.toString(), lastItems, "",
        //     wallet.body.money, wallet.body.types,true));
        try {
          final convetResponse =
              await cashRepository.convertCash(event.moneyTypeId, event.amount);
          final walletEntity = wallet.body as WalletEntity;
          // final itemsList = await getCartItem(
          //     walletEntity.money, walletEntity.types, theme, context);
          lastItems = await getlastTransItems(walletEntity.lastTrans, theme);

          if (convetResponse.error == true) {
            emit(CashSuccess(walletEntity.score.toString(), lastItems,
                convetResponse.body, walletEntity.money, walletEntity.types));
          } else {
            emit(CashLoading());
            wallet = await cashRepository.getUserWallet();
            final walletEntity = wallet.body as WalletEntity;
            // final itemsList = await getCartItem(
            //     walletEntity.money, walletEntity.types, theme, context);
            lastItems = await getlastTransItems(walletEntity.lastTrans, theme);
            emit(CashSuccess(walletEntity.score.toString(), lastItems,
                convetResponse.body, walletEntity.money, walletEntity.types));
          }
        } catch (e) {
          emit(CashError("خطا در برقراری ارتباط"));
        }
      }
    });
  }
}

Future<List<CartTypesItem>> getCartItem(
    List<MoneyEntity> moneyList,
    List<MoneyTypesEntity> typesList,
    ThemeData theme,
    bool isLoading,
    BuildContext context) async {
  final List<CartTypesItem> itemsList = [];
  typesList.forEach((element) {
    itemsList.add(CartTypesItem(
      theme: theme,
      title: element.title,
      baseScore: element.moneyBase,
      lastTitle: moneyList[
              typesList[typesList.indexWhere((element1) => element1 == element)]
                      .id -
                  1]
          .title,
      amount: moneyList[
              typesList[typesList.indexWhere((element1) => element1 == element)]
                      .id -
                  1]
          .amount,
      question: element.question,
      id: element.id.toString(),
      dialogIsLoading: false,
      parentContext: context,
    ));
  });
  return itemsList;
}

Future<List<LastTransItem>> getlastTransItems(
    List<LastTransEntity> lastTrancList, ThemeData theme) async {
  final List<LastTransItem> itemsList = [];
  lastTrancList.forEach((element) {
    itemsList.add(LastTransItem(
      theme: theme,
      title: element.type,
      amount: element.amount,
      date: convertDateToJalali(element.date),
    ));
  });
  return itemsList;
}

String convertDateToJalali(String dateTime) {
  final year = int.parse(dateTime.split(" ").first.split("-").first);
  final month = int.parse(dateTime.split(" ").first.split("-")[1]);
  final day = int.parse(dateTime.split(" ").first.split("-").last);
  final dateTiem = DateTime(year, month, day, 0, 0);
  var jalali = Jalali.fromDateTime(dateTiem).formatCompactDate();
  return jalali;
}
