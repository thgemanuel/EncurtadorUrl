import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sidenav extends StatelessWidget {
  final Function setIndex;
  final int selectedIndex;

  const Sidenav(this.selectedIndex, this.setIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Drawer(
        backgroundColor: Colors.white,
        elevation: 0,
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            _navItem(context, Icons.link_outlined, 'Encurtar Link',
                suffix: Text(
                  ' ',
                  style: GoogleFonts.lato(),
                ), onTap: () {
              _navItemClicked(context, 0);
            }, selected: selectedIndex == 0),
            //Divider(color: Colors.grey.shade400),
            _navItem(context, Icons.folder_open_outlined, 'Registros de Links',
                suffix: Text(
                  ' ',
                  style: GoogleFonts.lato(),
                ), onTap: () {
              _navItemClicked(context, 1);
            }, selected: selectedIndex == 1),
          ],
        ),
      ),
    );
  }

  _navItem(BuildContext context, IconData icon, String text,
          {required Text suffix,
          required VoidCallback onTap,
          bool selected = false}) =>
      Container(
        color: selected ? Colors.grey.shade300 : Colors.transparent,
        child: ListTile(
          leading: Icon(icon,
              color: selected ? Theme.of(context).primaryColor : Colors.black),
          trailing: suffix,
          title: Text(text),
          selected: selected,
          onTap: onTap,
        ),
      );

  _navItemClicked(BuildContext context, int index) {
    setIndex(index);
    Navigator.of(context).pop();
  }
}
