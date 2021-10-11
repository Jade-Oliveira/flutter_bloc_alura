import 'package:flutter_bloc/flutter_bloc.dart';

//o estado é uma única String
//poderia ser um perfil com diversos valores
class ValueCubit extends Cubit<double> {
  //estado inicial seria 0.0
  ValueCubit(double value) : super(0.0);

  //fazer função de validação
  void addValue(double value) => emit(value);

  bool validateValue(value) {
    if (value != null) {
      return true;
    }
    return false;
  }
}
