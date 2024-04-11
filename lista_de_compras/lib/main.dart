// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'view/cadastro.dart';
import 'view/sobre.dart';
import 'view/lista.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MainApp(),
    ),
  );
}

//
// MainApp
//
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
    );
  }
}

//
// Login
//
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Chave para o formulário
  var formKey = GlobalKey<FormState>();
  //var status = false;

  //Controladores para os Campos de Texto
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();

  void _abrirCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Cadastro()),
    );
  }

  void _abrirLista() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Lista()),
    );
  }

  void _abrirSobre() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Sobre()),
    );
  }

  void _entrar() {
    if (formKey.currentState!.validate()) {
      final email = txtEmail.text;
      final senha = txtSenha.text;

      UserService.addUser(User(
          nome: 'Login ADM', email: 'usuario@example.com', senha: '123456'));

      UserService.addUser(User(nome: 'Login 1', email: '1', senha: '1'));

      // Verifica se o email e a senha correspondem a algum usuário cadastrado
      var user = UserService.users.firstWhere(
        (user) => user.email == email && user.senha == senha,
        orElse: () => User(
            nome: '',
            email: '',
            senha: ''), // Retorna um usuário vazio caso não encontre
      );

      if (user.nome.isNotEmpty) {
        // Se encontrou um usuário com o email e senha fornecidos
        // Implemente aqui a ação desejada, como navegar para outra tela ou exibir uma mensagem de sucesso.
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login bem-sucedido'),
            content: Text('Bem-vindo, ${user.nome}!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _abrirLista();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Se não encontrou nenhum usuário com o email e senha fornecidos
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login falhou'),
            content: Text('Email ou senha incorretos.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
        txtEmail.clear();
        txtSenha.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 50, 50, 100),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _abrirSobre();
                      },
                      icon: Icon(
                        Icons.face,
                        size: 30,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Icon(
                  Icons.login_rounded,
                  size: 120,
                  color: Colors.black,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: txtEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Em branco';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: txtSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Em branco';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                Row(
                  // Row para alinhar os botões horizontalmente
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Alinha os widgets à direita
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.black,
                          width: 7.0,
                          style: BorderStyle.solid,
                        ),
                        maximumSize: Size(135, 50),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        _abrirCadastro();
                      },
                      child: Text(
                        'CADASTRAR',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Adiciona um espaço entre os botões
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.red,
                          width: 7.0,
                          style: BorderStyle.solid,
                        ),
                        minimumSize: Size(150, 50),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _entrar();
                        }
                      },
                      child: Text(
                        'ENTRAR',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
