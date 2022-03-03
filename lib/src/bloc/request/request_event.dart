part of 'request_bloc.dart';

@immutable
abstract class RequestEvent {}
abstract class HistoryPaymentEvent {}

class RequestLoad extends RequestEvent {
  final bool load;
  final List<Request> requests;
  RequestLoad({this.load, this.requests});
  @override
  String toString() => 'RequestLoad';
}
class HistoryPaymentLoad extends HistoryPaymentEvent {
  final bool load;
  final List<HistoryPayment> historyPayments;
  HistoryPaymentLoad({this.load, this.historyPayments});
  @override
  String toString() => 'HistoryPaymentLoad';
}