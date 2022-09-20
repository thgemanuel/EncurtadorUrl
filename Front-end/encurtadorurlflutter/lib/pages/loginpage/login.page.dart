import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test_encurtar_link/pages/loginpage/widgets/backHome.button.dart';
import '../../class/sharedPref.class.dart';
import '../../class/Usuario.class.dart';
import '../../functions/authentication.function.dart';
import '../../widgets/text.submitbutton.dart';
import 'widgets/textfieldemail.widget.dart';
import 'package:http/http.dart' as http;
import 'widgets/textfieldpassword.widget.dart';

bool loading = false;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<Usuario>? _futureUsuario;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void fetchUsuario(String username, String password) async {
    final response = await http.post(
      Uri.parse(
          'https://southamerica-east1-encurtador-url-thg.cloudfunctions.net/authentication'),
      headers: <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
        emailController.clear();
        passwordController.clear();

        SharedPref().save(
          'user_info',
          Usuario.fromJson(jsonDecode(response.body)),
        );
        Navigator.of(context).pushNamed('/dashboard');
      });
    } else {
      setState(() {
        loading = false;
        emailController.clear();
        passwordController.clear();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                content: Text('Usuário ou senha incorreta'),
              );
            });
      });

      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Usuario');
    }
  }

  // fetchUsuario(String login, String password) {
  //   if (autenticaUsuario(login, password)) {
  //     setState(() {
  //       loading = false;
  //       Navigator.of(context).pushNamed('/dashboard');
  //     });
  //   } else {
  //     setState(() {
  //       loading = false;
  //       emailController.clear();
  //       passwordController.clear();
  //       showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return const AlertDialog(
  //               content: Text('Usuário ou senha incorreta!'),
  //             );
  //           });
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFF404040),
            body: Center(
              child: SizedBox(
                width: 370,
                height: 700,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: const Color(0xFFB00afdf),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: SizedBox(
                              width: 316,
                              height: 48,
                              child: TxtFieldEmail(controller: emailController),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: SizedBox(
                              width: 316,
                              height: 48,
                              child: TxtFieldPassword(
                                  controller: passwordController,
                                  callback: () {
                                    setState(() {
                                      if (emailController.text.isNotEmpty &&
                                          passwordController.text.isNotEmpty) {
                                        loading = true;
                                        fetchUsuario(emailController.text,
                                            passwordController.text);
                                      }
                                    });
                                  }),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 96.0,
                                  right: 96.0,
                                  top: constraints.maxHeight * 0.01),
                              child: loading
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 25.0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            shape: MaterialStateProperty.all<
                                                    CircleBorder>(
                                                const CircleBorder())),
                                        onPressed: () {},
                                        child: const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 25.0),
                                      width: double.infinity,
                                      child: FutureBuilder<Usuario>(
                                        future: _futureUsuario,
                                        builder: (context,
                                            AsyncSnapshot<Usuario> snapshot) {
                                          if (loading) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 25.0),
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.white),
                                                    shape: MaterialStateProperty
                                                        .all<CircleBorder>(
                                                            const CircleBorder())),
                                                onPressed: () {},
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.white),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                )),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (emailController
                                                          .text.isNotEmpty &&
                                                      passwordController
                                                          .text.isNotEmpty) {
                                                    loading = true;
                                                    fetchUsuario(
                                                        emailController.text,
                                                        passwordController
                                                            .text);
                                                  }
                                                });
                                              },
                                              child: const TextSubmitButton(
                                                textButton: 'Logar',
                                                cor: Color(0xFF000000),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                            ),
                          ),
                          const Center(child: BackHomeButton()),
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
