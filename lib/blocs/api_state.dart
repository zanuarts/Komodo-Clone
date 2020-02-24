import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:komodo_ui/model/model.dart';

abstract class ApiState extends Equatable {
  ApiState();

  @override
  List<Object> get props => [];
}
class ApiLoading extends ApiState {}
class ApiLoaded extends ApiState {
  final PersonalUpd personal;
  ApiLoaded({@required this.personal}):assert(personal != null);

  @override
  List<Object> get props => [personal];
}
class ApiError extends ApiState{}