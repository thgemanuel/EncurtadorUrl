import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_encurtar_link/widgets/loading.button.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../class/getUrlOriginal.class.dart';
import '../../widgets/text.submitbutton.dart';
import 'widgets/textfieldlink.widget.dart';
import 'package:http/http.dart' as http;

bool loading = false;
bool loadingUrl = false;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController linkController = TextEditingController();

  _navegaLoginPage(BuildContext context) {
    Navigator.of(context).pushNamed('/login');
  }

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
                              child: TxtFieldLink(
                                  controller: linkController,
                                  callback: () {
                                    setState(() {
                                      loading = true;
                                      shortenUrl(linkController.text, '-');
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
                                  ? const LoadingButton()
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 25.0),
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color.fromARGB(
                                                      255, 27, 99, 233)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (linkController
                                                .text.isNotEmpty) {
                                              loading = true;
                                              shortenUrl(
                                                  linkController.text, '-');
                                            }
                                          });
                                        },
                                        child: const TextSubmitButton(
                                          textButton: 'Encurtar Link',
                                          cor: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 96.0, right: 96.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 25.0),
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    )),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _navegaLoginPage(context);
                                    });
                                  },
                                  child: const TextSubmitButton(
                                    textButton: 'Logar',
                                    cor: Color(0xFF000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
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

  Future openDialogUrl(String resultUrl) => showDialog<String>(
        //dialog
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text(
                  'URL encurtada com sucesso!',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    letterSpacing: 1.5,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                  ),
                ),
                content: SizedBox(
                  height: 80,
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              child: Container(
                                color: Colors.grey.withOpacity(.2),
                                child: InkWell(
                                  onTap: () async {
                                    setState(
                                      () {
                                        loadingUrl = true;
                                      },
                                    );
                                    // obtendo url origninal na base de dados 
                                    Map<String, dynamic> urlredirecionamento =
                                        await getUrlOriginal(resultUrl);
                                    launchUrlString(urlredirecionamento['body']['url_original']);
                                    setState(
                                      () {
                                        loadingUrl = false;
                                      },
                                    );
                                  },
                                  child: loadingUrl
                                      ? CircularProgressIndicator()
                                      : Text(resultUrl),
                                ),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  Clipboard.setData(
                                          ClipboardData(text: resultUrl))
                                      .then(
                                    (_) => ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Url copiada para ??rea de transferencia!'),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.copy))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                          ),
                          onPressed: () {
                            setState(() {
                              linkController.clear();
                              Navigator.pop(context);
                            });
                          },
                          child: const Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );

  // consumindo API para encurtar
  void shortenUrl(String url, String username) async {
    try {
      final responseURL = await http.post(
        Uri.parse(
            'https://southamerica-east1-encurtador-url-thg.cloudfunctions.net/geraurl'),
        headers: <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'url_original': url,
        }),
      );

      Map<String, dynamic> response = jsonDecode(responseURL.body);

      if (responseURL.statusCode == 201) {
        setState(() {
          loading = false;
          String resultUrl = response['url_encurtada'].toString();
          openDialogUrl(resultUrl);
        });
      }
    } catch (e) {
      setState(
        () {
          loading = false;
          linkController.clear();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('Error ${e.toString()}'),
              );
            },
          );
        },
      );
    }
  }
}
