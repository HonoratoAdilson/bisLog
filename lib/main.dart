import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    title: 'BisLOG',
    home: new MainPage()
  ));
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('BisLOG'),
        backgroundColor: Color(0xFF32A852),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () { Scaffold.of(context).openDrawer(); },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: new Center(
          child: Text(
            'Com classe',
            style: TextStyle(fontSize: 24),
          )
      ),
      drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text('Adicionar item'),
                subtitle: Text('Adicione um item ao transporte'),
                trailing: Icon(Icons.add),
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new NewTrackingBody())
                  );
                },
              )
            ],
          )
      ),
    );
  }
}

class NewTrackingBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('BisLOG'),
        backgroundColor: Color(0xFF32A852),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () { Navigator.pop(context); }
            );
          },
        ),
      ),
      body: Center(
          child: NewTrackingForm()
      )
    );
  }
}

class NewTrackingForm extends StatefulWidget {
  @override
  NewTrackingFormState createState() {
    return NewTrackingFormState();
  }
}

class NewTrackingFormState extends State<NewTrackingForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'É necessário informar o código do produto';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Código do pacote da mercadoria'
            ),
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Center(
                child: ElevatedButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate()) {
                        //Se o formulário está preenchido, então ele passa por essa funcionalidade.
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Produto registrado ao rastreamento com sucesso.')));
                      }
                    },
                    child: Text('Registrar')
              )
            ),
          )
        ],
      )
    );
  }
}
