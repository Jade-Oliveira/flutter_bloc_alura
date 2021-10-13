import 'package:flutter_bloc/flutter_bloc.dart';

class ValueCubit extends Cubit<bool> {
  //estado inicial seria 0.0
  ValueCubit() : super(false);

  //fazer função de validação
  void validateValue(String value) {
    emit(value.isNotEmpty);
  }
}
