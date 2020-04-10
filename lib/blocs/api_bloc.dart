import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:komodo_ui/repository/repository.dart';
import 'package:komodo_ui/model/model.dart';
import 'package:komodo_ui/blocs/blocs.dart';

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
        final PersonalNew personal = await apiRepository.getProfile('');
        yield ApiLoaded(personal: personal);
      } catch(_){
        yield ApiError();
      }
    }
  }

}