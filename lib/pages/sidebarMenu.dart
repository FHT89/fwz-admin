import 'package:fhtwzadmin/globals.dart';
import 'package:fhtwzadmin/pages/login.dart';
import 'package:fhtwzadmin/pages/prix.dart';
import 'package:fhtwzadmin/pages/profil.dart';
import 'package:fhtwzadmin/pages/stats.dart';
import 'package:fhtwzadmin/pages/tickets.dart';
import 'package:fhtwzadmin/utils/decoration.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class SideBarMenu extends StatelessWidget {
  SideBarMenu({super.key});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: Colors.white,
        scaffoldBackgroundColor: secondaryColor2,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
                    backgroundColor: primaryColor,
                    title: Text(
                      _getTitleByIndex(_controller.selectedIndex),
                      style: wtTitle(22, 1, Colors.white, true, false),
                    ),
                    leading: IconButton(
                      onPressed: () {
                        // if (!Platform.isAndroid && !Platform.isIOS) {
                        //   _controller.setExtended(true);
                        // }
                        _key.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu, color: Colors.white),
                    ),
                  )
                : null,
            drawer: SidebarXMenu(controller: _controller),
            body: Row(
              children: [
                if (!isSmallScreen) SidebarXMenu(controller: _controller),
                Expanded(
                  child: Center(
                    child: _ScreensExample(controller: _controller),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SidebarXMenu extends StatelessWidget {
  const SidebarXMenu({super.key, required SidebarXController controller})
    : _controller = controller;

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: primaryColor,
        textStyle: TextStyle(color: Colors.black),
        selectedTextStyle: const TextStyle(color: Colors.white),
        hoverTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        hoverIconTheme: IconThemeData(color: Colors.white, size: 20),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor),
          gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
          boxShadow: [
            BoxShadow(color: const Color.fromARGB(86, 0, 0, 0), blurRadius: 30),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black, size: 20),
        selectedIconTheme: const IconThemeData(color: Colors.white, size: 20),
      ),
      extendedTheme: SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(color: Colors.white),
      ),
      footerDivider: Divider(color: secondaryColor, height: 2),
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 150,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/images/logo1.png'),
          ),
        );
      },
      footerItems: [
        SidebarXItem(
          icon: Icons.logout_outlined,
          label: 'Deconnexion',
          onTap: () {
            ouvrirR(context, LoginPage());
          },
        ),
      ],
      items: [
        SidebarXItem(icon: Icons.home, label: 'Accueil'),
        SidebarXItem(icon: Icons.monetization_on_outlined, label: 'Prix'),
        SidebarXItem(icon: Icons.receipt_outlined, label: 'Tickets'),
        SidebarXItem(icon: Icons.event_note_outlined, label: 'Points'),
      ],
    );
  }
}

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({required this.controller});

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return ProfilPage();
          case 1:
            return PrixPage();
          case 2:
            return TicketsPage();
          case 3:
            return StatsPage();
          default:
            return Text(
              pageTitle,
              style: wtTitle(18, 1, primaryColor, true, false),
            );
        }
      },
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Accueil';
    case 1:
      return 'Prix';
    case 2:
      return 'Tickets';
    case 3:
      return 'Points';
    default:
      return 'Not found page';
  }
}
