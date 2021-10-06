import 'package:bytebankapi/models/name.dart';
import 'package:bytebankapi/widgets/container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

//construtor padrão que recebe um estado e passa para frente
class NameContainer extends BlocContainer {
  const NameContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //nesse contexto já temos o NameCubit, porque o dashboard tem o NameCubit
    return NameView();
  }
}

class NameView extends StatelessWidget {
  NameView({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //não uso bloc bluid porque não preciso rebuildar a tela
    _nameController.text = context.read<NameCubit>().state;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Change Name'),
        ),
        body: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Desired name:',
              ),
              style: TextStyle(fontSize: 24),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: TextButton(
                  child: Text(
                    'Change',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    //coloca o que vem do controller para a variável name e chama a função change do NameCubit
                    final name = _nameController.text;
                    context.read<NameCubit>().change(name);
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green[900],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
