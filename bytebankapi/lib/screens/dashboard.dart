import 'package:bytebankapi/models/name.dart';
import 'package:bytebankapi/screens/name.dart';
import 'package:bytebankapi/screens/transactions_list.dart';
import 'package:bytebankapi/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contacts_list.dart';

class DashboardContainer extends BlocContainer {
  const DashboardContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      //cria o NameCubit
      create: (_) => NameCubit("Jade"),
      child: DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              //só isso precisa ser rebuildado, toda vez que esse estado é alterado eu quero ele
              //misturando um blocBuilder (que é um observer de eventos) com UI
              BlocBuilder<NameCubit, String>(
            builder: (context, state) => Text('Welcome $state'),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('images/bytebank_logo.png'),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 250,
                      margin: EdgeInsets.only(bottom: 30),
                      child: Row(
                        children: [
                          _FeatureItem(
                            name: 'Transfer',
                            icon: Icons.monetization_on,
                            onClick: () {
                              _showContactsList(context);
                            },
                          ),
                          _FeatureItem(
                              name: 'Transaction Feed',
                              icon: Icons.description,
                              onClick: () => _showTransactionsList(context)),
                          _FeatureItem(
                            name: 'Change Name',
                            icon: Icons.person_outline,
                            onClick: () {
                              _showChangeName(context);
                            },
                          ),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ));
  }

  //função para navegar para a lista de contatos
  void _showContactsList(BuildContext blocContext) {
    //atualisei a lista de contatos para bloc
    push(blocContext, ContactsListContainer());
  }

  void _showChangeName(BuildContext blocContext) {
    Navigator.of(blocContext).push(
      MaterialPageRoute(
        //aqui rolou um problema de que o context principal da aplicação não tá sendo passado para frente quando cria o MaterialPageRoute
        //extrai o NameCubit para eu conseguir utilizar nessa rota
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<NameCubit>(blocContext),
          child: NameContainer(),
        ),
      ),
    );
  }
}

void _showTransactionsList(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => TransactionsList(),
    ),
  );
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem(
      {Key? key, required this.name, required this.icon, required this.onClick})
      : super(key: key);

  final String name;
  final IconData icon;
  //callback do dart
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => onClick(),
          child: Container(
            padding: EdgeInsets.all(8.0),
            height: 100,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24.0,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
