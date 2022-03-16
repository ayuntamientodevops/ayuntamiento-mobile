part of 'request_bloc.dart';

class RequestState {
  bool requestload;
  List<Request> requests;
  RequestState({this.requestload = false, this.requests});

  RequestState copyWith({bool requestload, List<Request> requests}) =>
      new RequestState(
          requestload: requestload ?? this.requestload,
          requests: requests ?? this.requests);
}

class HistoryPaymentState {
  bool paymentHistoryload;
  List<HistoryPayment> paHistory;
  HistoryPaymentState({this.paymentHistoryload = false, this.paHistory});

  HistoryPaymentState copyWith({bool paymentHistoryload, List<HistoryPayment> paHistory}) =>
      new HistoryPaymentState(
          paymentHistoryload: paymentHistoryload ?? this.paymentHistoryload,
          paHistory: paHistory ?? this.paHistory);
}
