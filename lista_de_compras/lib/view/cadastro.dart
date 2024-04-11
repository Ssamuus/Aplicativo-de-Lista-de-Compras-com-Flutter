// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_compras/main.dart';

class User {
  final String nome;
  final String email;
  final String senha;

  User({
    required this.nome,
    required this.email,
    required this.senha,
  });
}

// Serviço para gerenciar os usuários
class UserService {
  static List<User> users = []; // Lista para armazenar os usuários cadastrados

  // Método para adicionar um novo usuário
  static void addUser(User user) {
    users.add(user);
  }

  // Método para verificar se um usuário com determinado email já existe
  static bool emailExists(String email) {
    return users.any((user) => user.email == email);
  }
}

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
      home: Cadastro(),
    );
  }
}

//
// Cadastro
//
class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  //Chave para o formulário
  var formKey = GlobalKey<FormState>();
  var status = false;

  //Controladores para os Campos de Texto
  var txtNome = TextEditingController();
  var txtSenha = TextEditingController();
  var txtEmail = TextEditingController();

  //
  // CAIXA DE DIÁLOGO
  //
  caixaDialogo(context, titulo, mensagem) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'confirmar'),
            child: Text('confirmar'),
          ),
        ],
      ),
    );
  }

  void _cadastrarUsuario() {
    if (formKey.currentState!.validate()) {
      var nome = txtNome.text;
      var email = txtEmail.text;
      var senha = txtSenha.text;

      if (!UserService.emailExists(email)) {
        var user = User(nome: nome, email: email, senha: senha);
        UserService.addUser(user);

        setState(() {
          var v1 = txtNome.text;
          var v2 = txtEmail.text;
          var v3 = txtSenha.text;
          var msg = 'Nome: $v1\nEmail: $v2\nSenha: $v3';
          caixaDialogo(context, 'Dados', msg);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuário cadastrado com sucesso!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Este email já está sendo usado!'),
          ),
        );
      }
    }
  }

  void _abrirLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 100, 50, 100),
        child: SingleChildScrollView(
          //Direção da barra de rolagem
          scrollDirection: Axis.vertical,

          child: Form(
            key: formKey,
            child: Column(
              children: [
                //
                // Ícone
                //
                Icon(
                  Icons.app_registration_rounded,
                  size: 120,
                  color: Colors.red,
                ),

                SizedBox(height: 15),
                TextFormField(
                  controller: txtNome,

                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),

                  //
                  // Validação
                  //
                  validator: (value) {
                    if (value == null) {
                      return 'Em branco';
                    } else if (value.isEmpty) {
                      return 'Em branco';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: txtEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),

                  //
                  // Validação
                  //
                  validator: (value) {
                    if (value == null) {
                      return 'Em branco';
                    } else if (value.isEmpty) {
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
                  //
                  // Validação
                  //
                  validator: (value) {
                    // Verifica se o valor é nulo ou está vazio
                    if (value == null || value.isEmpty) {
                      return 'Em branco';
                    }

                    // Verifica se a senha contém pelo menos um número
                    if (!RegExp(r'\d').hasMatch(value)) {
                      return 'A senha deve conter pelo menos um número';
                    }

                    // Retorna null se a validação passar
                    return null;
                  },
                ),
                SizedBox(height: 30),

                //ElevatedButton
                //TextButton
                //OutlinedButton
                Row(
                  // Row para alinhar os botões horizontalmente
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Alinha os widgets à direita
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: Colors.red,
                            width: 7.0,
                            style: BorderStyle.solid),
                        maximumSize: Size(135, 50),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () {
                        _abrirLogin();
                      },
                      child: Text(
                        'VOLTAR',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 10), // Adiciona um espaço entre os botões
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: Colors.black,
                            width: 7.0,
                            style: BorderStyle.solid),
                        maximumSize: Size(170, 150),
                        minimumSize: Size(170, 48),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        //
                        // Executar o processo de VALIDAÇÃO
                        //
                        if (formKey.currentState!.validate()) {
                          _cadastrarUsuario();
                          //Validação com sucesso

                          //
                          // Recuperar as informações contidas nos
                          // Campos de texto
                          //

                          txtNome.clear();
                          txtEmail.clear();
                          txtSenha.clear();
                        }
                      },
                      child: Text(
                        'CADASTRAR',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
