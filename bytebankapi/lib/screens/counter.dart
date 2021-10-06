import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//exemplo de contador utilizando bloc com duas variações

//vai encapsular os comportamentos ligados ao nosso estado
//o estado é um int
//CounterCubit é o gerenciador do estado
class CounterCubit extends Cubit<int> {
  CounterCubit(int initialState) : super(0);

  //troco o estado emitindo um novo evento para o sistema (increment e decrement)
  //interface de comunicação com o evento são os parâmetros
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  //nesse caso o gerenciador de estado é uma classe com dois comportamentos diferentes, um increment e um decrement
}

class CounterContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //provendo um cubit para os filhos
    //blocprovider vai juntar o gerenciador de estado com a view
    return BlocProvider(
      create: (_) => CounterCubit(0),
      child: CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      //builder que é notificado
      //uma forma de usar bloc
      body: Center(child: BlocBuilder<CounterCubit, int>(
        builder: (context, state) {
          //vai buildar algo de acordo com o state, ou seja, o build é notificado quando deve ser rebuildado
          return Text(
            '$state',
            style: textTheme.headline2,
          );
        },
      )),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            //context.read para acessar o bloc que quero notificar através de algum evento
            //outra forma de usar bloc
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          SizedBox(
            height: 8,
          ),
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          )
        ],
      ),
    );
  }
}
