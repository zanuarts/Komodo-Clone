import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ApiEvent extends Equatable{
  ApiEvent();
}
class FetchPersonal extends ApiEvent{
  final String id;
  FetchPersonal({@required this.id}) : assert(id != null);
  @override
  List<Object> get props => [id];
}