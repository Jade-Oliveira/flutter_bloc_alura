import 'package:bytebankapi/screens/dashboard.dart';
import 'package:bytebankapi/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BytebankApp());
}

//observer geral
class LogObserver extends BlocObserver {
  @override
  //recebe um cubit e a mudança ele delega para o super
  void onChange(BlocBase bloc, Change change) {
    print('${bloc.runtimeType} > $change');
    super.onChange(bloc, change);
  }
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //na prática evitar log do gênero, pois pode vazar informações sensíveis para o log
    Bloc.observer = LogObserver();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: bytebankTheme,
      home: DashboardContainer(),
    );
  }
}
