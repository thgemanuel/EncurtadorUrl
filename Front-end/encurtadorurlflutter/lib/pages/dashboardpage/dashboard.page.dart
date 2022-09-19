import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../class/SideNav.class.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: Text(
          this.tituloPagina,
          style: GoogleFonts.lato(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              letterSpacing: 1,
              fontWeight: FontWeight.normal),
        ),
        actions: <Widget>[
          Row(
            children: [
              const Text(
                "Thiago Emanuel",
                style: TextStyle(
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
                  child: const ClipOval(
                    child: Image(
                      image: AssetImage('perfil.jpg'),
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
                  this.tituloPagina = 'Encurtar Link';
                  break;
                case 1:
                  this.tituloPagina = 'Registros de Links';
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
  }
}
