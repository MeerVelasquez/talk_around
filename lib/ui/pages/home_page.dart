import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:talk_around/domain/models/channel.dart';
import 'package:talk_around/ui/controllers/app_controller.dart';
import 'package:talk_around/ui/widgets/app_bar_home_widget.dart';
import 'package:talk_around/ui/widgets/brand_header_widget.dart';
import 'package:talk_around/ui/widgets/drawer_widget.dart';
import 'package:talk_around/ui/widgets/grid_channels_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  static const String paramAvoidFetchData = 'avoid_reload_channels';

  final AppController _appController = Get.find<AppController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _fetchData().catchError(logError);
    _appController.checkGeoloc().catchError(logError);
  }

  Future<void> _fetchData() async {
    final List<Future<void>> futures = [];

    if ((Get.parameters[paramAvoidFetchData] ?? "false") != "false") {
      futures.add(_appController.fetchTopics());
      futures.add(_appController.fetchChannels());
    } else {
      if (_appController.channels == null) {
        futures.add(_appController.fetchChannels());
      }
      if (_appController.topics == null) {
        futures.add(_appController.fetchTopics());
      }
    }
    await Future.wait(futures);
  }

  Future<void> onDrawerChanged(bool isOpened) async {
    _appController.isDrawerOpen = isOpened;

    if (!isOpened) {
      try {
        await _appController.saveGeolocPrefs();
      } catch (err) {
        logError(err);
      }
    }
  }

  void onPressedNotification() {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState!.openDrawer();
    } else {
      logError('ScaffoldKey.currentState is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('asdasda');
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarHomeWidget(onPressedNotification: onPressedNotification),
        drawer: DrawerWidget(),
        onDrawerChanged: onDrawerChanged,
        body: Container(
          color: Colors.white,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const BrandHeaderWidget(),
                  const SizedBox(height: 20),
                  Container(
                    height: 200,
                    child: GridChannelsWidget(channels: [
                      Channel(
                          topicId: '1',
                          creatorId: '1',
                          name: 'name',
                          description: 'description',
                          imageUrl: 'imageUrl',
                          language: 'language',
                          country: 'country',
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                          lat: 1,
                          lng: 1,
                          users: [])
                    ], onTap: (Channel channel) {}),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     buildClickableBox(
                  //         'Sports: Messi', 'is love', 'assets/img/sports.jpg'),
                  //     buildClickableBox(
                  //         'Games', 'of the season', 'assets/img/games.jpg'),
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     buildClickableBox(
                  //         'AOT: ', 'Grand Finale', 'assets/img/aot.png'),
                  //     buildClickableBox('Tips: ', 'Treats for dogs',
                  //         'assets/img/perfil.jpeg'),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: ConvexAppBar(
          items: [
            TabItem(icon: Icons.people, title: 'Profile'),
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.add, title: 'New chat'),
          ],
          initialActiveIndex: 2, //optional, default as 0
          onTap: (int i) => print('click index=$i'),
          backgroundColor: Color(0xFF013E6A),
        ));
  }

  Widget buildClickableBox(String title, String description, String imagePath) {
    return InkWell(
      onTap: () {
        // Acción al hacer clic en el cuadro
        print('Clic en $title');
      },
      child: Container(
        width: 200,
        height: 250,
        decoration: BoxDecoration(
          color: Color(0xFF799AB1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            // Fondo de la caja
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Container con la imagen en el centro
            Positioned(
              left: 20,
              right: 20,
              top: 20,
              bottom: 70,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFF234E6C)),
                ),
                child: Image.asset(
                  imagePath,
                  width: 20, // Ajusta el tamaño según tus necesidades
                  // height: 50,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Container con el texto en la parte inferior
            Positioned(
              left: 20,
              right: 20,
              bottom: 10,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE7FCFD),
                  border: Border.all(
                    color: Color(0xFF7FA6B9),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    '$title\n$description',
                    style: TextStyle(
                        color: Color(0xFF013E6A),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
