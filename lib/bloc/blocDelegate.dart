import 'package:bloc/bloc.dart';

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }
}
