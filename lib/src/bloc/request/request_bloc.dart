import 'dart:async';

import 'package:asdn/src/models/HistoryPayment.dart';
import 'package:asdn/src/models/Request.dart';
import 'package:asdn/src/share_prefs/preferences_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  PreferenceStorage preferenceStorage = PreferenceStorage();
  RequestBloc() : super(RequestState(requestload: false));

  @override
  Stream<RequestState> mapEventToState(
    RequestEvent event,
  ) async* {
    if (event is RequestLoad) {
      if (event.load) {
        await preferenceStorage.setValue(
            key: "requests", value: Request.encode(event.requests));

        await preferenceStorage.setValue(
            key: "requestLoad", value: event.load.toString());
      } else {
        preferenceStorage.deleteValue(key: "requests");
        preferenceStorage.deleteValue(key: "requestLoad");
      }

      yield state.copyWith(requestload: event.load);
    }
  }
}

class HistoryPaymentBloc extends Bloc<HistoryPaymentEvent, HistoryPaymentState> {
  PreferenceStorage preferenceStorage = PreferenceStorage();
  HistoryPaymentBloc() : super(HistoryPaymentState(paymentHistoryload: false));

  @override
  Stream<HistoryPaymentState> mapEventToState(
      HistoryPaymentEvent event,
      ) async* {
    if (event is HistoryPaymentLoad) {
      if (event.load) {
        await preferenceStorage.setValue(
            key: "paHistory", value: HistoryPayment.encode(event.paHistory));

        await preferenceStorage.setValue(
            key: "historyPaymentLoad", value: event.load.toString());
      } else {
        preferenceStorage.deleteValue(key: "paHistory");
        preferenceStorage.deleteValue(key: "historyPaymentLoad");
      }

      yield state.copyWith(paymentHistoryload: event.load);
    }
  }
}