import 'package:flutter/material.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

final _deviceHashController = TextEditingController();

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
              ),
              ListTile(
                title: Text('Registrar dispositivo'),
                subtitle: Text('Registre o dispositivo para vinculo de mercadorias'),
                trailing: Icon(Icons.settings_cell),
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new RegisterDevice())
                  );
                }
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

class RegisterDevice extends StatelessWidget {
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
            child: Center(
              child: new NewDeviceForm()
            )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('tentou abrir a camera');
            _scan();
          },
          child: const Icon(Icons.camera_enhance),
          backgroundColor: Color(0xFF32A852),
        ),
    );
  }
}

class NewDeviceForm extends StatefulWidget {
  @override
  NewDeviceFormState createState() {
    return NewDeviceFormState();
  }
}

class NewDeviceFormState extends State<NewDeviceForm>{
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    return new Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget> [
              TextFormField(
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "É necessário inserir o código de vinculação do dispositivo.";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Código de vinculação do dispositivo'
                ),
                controller: _deviceHashController,
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: new Center(
                  child: ElevatedButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate()) {
                        //Se o formulário está preenchido, então ele passa por essa funcionalidade.
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dispositivo vinculado')));
                      }
                    },
                    child: Text('Registrar')
                  )
                ),
              )
            ],
          )
        ]
      )
    );
  }
}
Future _scan() async { //Função de scan do qrscan para escanear código de barras e código qr
  await Permission.camera.request();
  String barcode = await scanner.scan();
  if (barcode == null) {
    print('nothing return.');
  } else {
    _deviceHashController.text = barcode;
  }
}