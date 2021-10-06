import 'package:flutter_bloc/flutter_bloc.dart';

//o estado é uma única String
//poderia ser um perfil com diversos valores
class NameCubit extends Cubit<String> {
  NameCubit(String name) : super(name);

  //recebe um nome novo e emite um novo estado
  void change(String name) => emit(name);
}
