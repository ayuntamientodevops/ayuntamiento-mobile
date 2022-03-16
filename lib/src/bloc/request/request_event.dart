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
  final List<HistoryPayment> paHistory;
  HistoryPaymentLoad({this.load, this.paHistory});
  @override
  String toString() => 'HistoryPaymentLoad';
}