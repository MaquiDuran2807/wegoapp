import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wegocol/pages/login/login_controller.dart';

import 'package:wegocol/pages/login/register.dart';

class ClientRegisterPage extends StatefulWidget {
  @override
  _ClientRegisterPageState createState() => _ClientRegisterPageState();
}

class _ClientRegisterPageState extends State<ClientRegisterPage> {

  ClientRegisterController _con = new ClientRegisterController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INIT STATE');

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context,refresh);
    });

  }

  @override
  Widget build(BuildContext context) {

    print('METODO BUILD');

    return Scaffold(
      key: _con.key,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerApp(),
            _textLogin(),
            _BotonCam(),
            _textFieldUsername(),
            _textFieldName(),
            _textFieldLastName(),
            _textFieldIdentification(),
            _textFieldPhone(),
            _textFieldEmail(),
            _textFieldGender(),
            _textFieldPassword(),
            _textFieldConfirmPassword(),
            _buttonRegister(),
          ],
        ),
      ),
    );
  }

  Widget _buttonRegister() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ElevatedButton(
        onPressed: _con.register,
        child:Text('Registrar ahora',
          style: TextStyle(
            color: Colors.white,
          ),
        ) ,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0))
            )
        ),


      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.emailController,
        decoration: InputDecoration(
            hintText: 'correo@gmail.com',
            labelText: 'Correo electronico',
            suffixIcon: Icon(
              Icons.email_outlined,
              color: Colors.black87,
            )
        ),
      ),
    );
  }

  Widget _textFieldUsername() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.usernameController,
        decoration: InputDecoration(
            hintText: 'Pepito Perez',
            labelText: 'Nombre de usuario',
            suffixIcon: Icon(
              Icons.person_outline,
              color: Colors.black87,
            )
        ),
      ),
    );
  }
  Widget _BotonCam() {
    return Container(
      child: ElevatedButton(
        onPressed: (){
          _con.showAlertDialog(context);

          //refresh();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('foto'),
            Icon(Icons.camera_alt)
          ],
        ),
      ),
    );
  }
  
  Widget _textFieldName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        controller: _con.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Nombre',
            suffixIcon: Icon(Icons.person)
        ),
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        controller: _con.lastnameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Apellido',
            suffixIcon: Icon(Icons.person_outline)
        ),
      ),
    );
  }
  Widget _textFieldIdentification() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        controller: _con.idController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'identificacion',
            suffixIcon: Icon(Icons.add_card_outlined,color:Colors.black87,)
        ),
      ),
    );
  }

  Widget _textFieldGender() {

    return Container(
      child: Column(
        children: [
          RadioListTile<String>(
            title: const Text('masculino'),
            value: "masculino",
            groupValue: _con.genero,
            selected: true,
            activeColor: Colors.black87,
            onChanged: (value) {
              setState(() {
                _con.genero = value;
              });
            },
          ),



        RadioListTile<String>(
          title: const Text('femenino'),
          value: 'femenino',
          groupValue: _con.genero,
          selected: true,
          activeColor: Colors.black87,
          onChanged: (value) {
            print(value);
            setState(() {
              _con.genero = value;
            });
          },
        )
        ]
      )
    );


  }

  Widget _textFieldPhone() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        controller: _con.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Telefono',
            suffixIcon: Icon(Icons.phone)
        ),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        obscureText: true,
        controller: _con.passwordController,
        decoration: InputDecoration(
            labelText: 'Contraseña',
            suffixIcon: Icon(
              Icons.lock_open_outlined,
              color: Colors.black87,
            )
        ),
      ),
    );
  }

  Widget _textFieldConfirmPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        obscureText: true,
        controller: _con.confirmPasswordController,
        decoration: InputDecoration(
            labelText: 'Confirmar Contraseña',
            suffixIcon: Icon(
              Icons.lock_open_outlined,
              color: Colors.black87,
            )
        ),
      ),
    );
  }


  Widget _textLogin() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'REGISTRO',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25
            ),
          ),
              _con.imageFile!=null? Image.file(_con.imageFile,width: 120,height: 180,):Image.asset('assets/img/logoempresa.png',scale: 6,),

        ],
      ),
    );
  }

  Widget _bannerApp() {
    return ClipPath(
      child: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height * 0.22,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/img/logoblanco.png',
              width: 150,
              height: 100,
            ),
            Text(
              'Facil y Rapido',
              style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }
  void refresh() {
    setState(() {});
  }
}
