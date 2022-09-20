import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_encurtar_link/pages/dashboardpage/widgets/textfieldlink.logado.widget.dart';
import 'package:test_encurtar_link/widgets/loading.button.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../class/getUrlOriginal.class.dart';
import '../../../widgets/text.submitbutton.dart';
import 'package:http/http.dart' as http;

bool loading = false;
bool loadingUrl = false;

class CardLinkLogado extends StatefulWidget {
  final username;
  const CardLinkLogado({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<CardLinkLogado> createState() => _CardLinkLogadoState();
}

class _CardLinkLogadoState extends State<CardLinkLogado> {
  TextEditingController linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Color.fromARGB(255, 167, 167, 167),
            body: Center(
              child: SizedBox(
                width: 370,
                height: 700,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Color.fromARGB(250, 255, 255, 255),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: SizedBox(
                              width: 316,
                              height: 48,
                              child: TxtFieldLinkLogado(
                                  controller: linkController,
                                  callback: () {
                                    setState(() {
                                      loading = true;
                                      shortenUrl(
                                          linkController.text, widget.username);
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
                                              shortenUrl(linkController.text,
                                                  widget.username);
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
                                    Map<String, dynamic> urlredirecionamento =
                                        await getUrlOriginal(resultUrl);
                                    launchUrlString(urlredirecionamento['body']
                                        ['url_original']);
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
                                            'Url copiada para área de transferencia!'),
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
        Uri.parse('https://southamerica-east1-encurtador-url-thg.cloudfunctions.net/geraurl'),
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
