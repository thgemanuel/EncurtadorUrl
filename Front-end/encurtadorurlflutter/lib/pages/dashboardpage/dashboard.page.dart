import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../class/SideNav.class.dart';
import '../../class/sharedPref.class.dart';
import 'widgets/card.link.dart';
import 'widgets/table.link.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  int navIndex = 0;
  String tituloPagina = "Visão Geral";
  late Future<Map<String, dynamic>> _user_info;
  late Future<Map<String, dynamic>> _urlsInfo;

  Future<Map<String, dynamic>> loadUser() async {
    var userInfo = await SharedPref().read('user_info');
    // this._urlsInfo = loadCardsInfo(
    //     userInfo['username'], userInfo['token'], userInfo['companyId']);
    return userInfo;
  }

  @override
  void initState() {
    super.initState();
    _user_info = loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _user_info,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                elevation: 0,
                title: Text(
                  tituloPagina,
                  style: GoogleFonts.lato(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal),
                ),
                actions: <Widget>[
                  Row(
                    children: [
                      Text(
                        snapshot.data?['name'],
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          letterSpacing: 0,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {},
                          child: ClipOval(
                            child: Image(
                              image: MemoryImage(base64Decode(
                                  snapshot.data?['profile_picture'])),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              drawer: Sidenav(
                navIndex,
                (int index) {
                  setState(
                    () {
                      navIndex = index;
                      switch (navIndex) {
                        case 0:
                          tituloPagina = 'Encurtar Link';
                          break;
                        case 1:
                          tituloPagina = 'Registros de Links';
                          break;
                        default:
                          break;
                      }
                    },
                  );
                },
              ),
              body: LayoutBuilder(
                builder: (context, constraint) {
                  switch (navIndex) {
                    case 0:
                      return const CardLinkLogado();
                    case 1:
                      return const TableLinks();
                    default:
                      return const Center();
                  }
                },
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Aguardando resultados...'),
                  )
                ],
              ),
            );
          }
        });
  }
}
