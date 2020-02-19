import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_ui1/repository/repository.dart';
import 'package:flutter_ui1/model/model.dart';
import 'package:flutter_ui1/blocs/blocs.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState>{
  final ApiRepository apiRepository;
  ApiBloc({@required this.apiRepository}):assert(apiRepository != null);

  @override
  ApiState get initialState => ApiLoading();

  @override
  Stream<ApiState> mapEventToState(ApiEvent event) async* {
    if (event is FetchPersonal){
      yield ApiLoading();
      try {
        final Personal personal = await apiRepository.getProfile('');
        yield ApiLoaded(personal: personal);
      } catch(_){
        yield ApiError();
      }
    }
  }

}