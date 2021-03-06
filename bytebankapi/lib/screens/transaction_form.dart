import 'dart:async';

import 'package:bytebankapi/http/webclients/transaction_webclient.dart';
import 'package:bytebankapi/models/contact.dart';
import 'package:bytebankapi/models/transaction.dart';
import 'package:bytebankapi/models/value.dart';
import 'package:bytebankapi/widgets/container.dart';
import 'package:bytebankapi/widgets/error.dart';
import 'package:bytebankapi/widgets/progress.dart';
import 'package:bytebankapi/widgets/transaction_auth_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class TransactionFormState {
  const TransactionFormState();
}

@immutable
class SendingState extends TransactionFormState {
  const SendingState();
}

@immutable
class ShowFormState extends TransactionFormState {
  const ShowFormState();
}

@immutable
class SentState extends TransactionFormState {
  const SentState();
}

@immutable
class FatalErrorFormState extends TransactionFormState {
  final String _message;

  const FatalErrorFormState(this._message);
}

class TransactionFormCubit extends Cubit<TransactionFormState> {
  //estado inicial
  TransactionFormCubit() : super(ShowFormState());

  void save(Transaction transactionCreated, String password,
      BuildContext context) async {
    emit(SendingState());
    await _send(
      transactionCreated,
      password,
      context,
    );
  }

  _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    await TransactionWebClient()
        .save(transactionCreated, password)
        .then((transaction) => emit(SentState()))
        .catchError((e) {
      emit(FatalErrorFormState(e.message));
    }, test: (e) => e is HttpException).catchError((e) {
      emit(FatalErrorFormState(e.message));
    }, test: (e) => e is TimeoutException).catchError((e) {
      emit(FatalErrorFormState(e.message));
    });
  }
}

class TransactionFormContainer extends BlocContainer {
  final Contact _contact;
  TransactionFormContainer(this._contact);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => TransactionFormCubit()),
          BlocProvider(create: (_) => ValueCubit()),
        ],
        child: BlocListener<TransactionFormCubit, TransactionFormState>(
          listener: (BuildContext context, state) {
            if (state is SentState) {
              Navigator.pop(context);
            }
          },
          child: TransactionFormStateless(_contact),
        ));
  }
}

class TransactionFormStateless extends StatelessWidget {
  final Contact _contact;
  TransactionFormStateless(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionFormCubit, TransactionFormState>(
      builder: (context, state) {
        if (state is ShowFormState) {
          return _BasicForm(_contact);
        }
        if (state is SendingState || state is SentState) {
          return ProgressView();
        }
        if (state is FatalErrorFormState) {
          return ErrorView(state._message);
        }
        return ErrorView('Unknown Error!');
      },
    );
  }
}

class _BasicForm extends StatelessWidget {
  final TextEditingController _valueController = TextEditingController();
  final String transactionId = Uuid().v4();
  final Contact _contact;

  _BasicForm(this._contact);
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ValueCubit>();

    //substitui o blocBuilder
    final state = context.watch<ValueCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextFormField(
                  //acesso a fun????o que criei no Cubit para valida????o do campo
                  onChanged: bloc.validateValue,
                  //essa fun????o de autoValidate reconhece o input do usu??rio
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _valueController,
                  //valida????o se estiver vazio
                  validator: (_) =>
                      _valueController.text.isEmpty ? 'Insira um valor' : null,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(
                    labelText: 'Value',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      child: Text('Transfer'),
                      //usar o state que criamos por meio do watch aqui vai verificar se ele ?? true e habilitar o bot??o
                      onPressed: state
                          ? () {
                              //pega o valor do textField por meio do _valueController
                              final double value =
                                  double.parse(_valueController.text);
                              final transactionCreated = Transaction(
                                transactionId,
                                value,
                                _contact,
                              );
                              showDialog(
                                  context: context,
                                  //nome diferente para o context do builder para ter certeza que vai executar o contexto correto
                                  builder: (contextDialog) {
                                    return TransactionAuthDialog(
                                      onConfirm: (String password) {
                                        //executa o envio da transa????o
                                        BlocProvider.of<TransactionFormCubit>(
                                                context)
                                            .save(
                                          transactionCreated,
                                          password,
                                          context,
                                        );
                                      },
                                    );
                                  });
                            }
                          : null,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
