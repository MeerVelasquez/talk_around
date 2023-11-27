import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:talk_around/domain/models/channel.dart';
import 'package:talk_around/ui/controllers/app_controller.dart';
import 'package:talk_around/ui/widgets/app_bar_home_widget.dart';
import 'package:talk_around/ui/widgets/bottom_nav_bar_widget.dart';
import 'package:talk_around/ui/widgets/brand_header_widget.dart';
import 'package:talk_around/ui/widgets/drawer_widget.dart';
import 'package:talk_around/ui/widgets/grid_channels_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String paramAvoidFetchData = 'avoid_fetch_data';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final AppController _appController = Get.find<AppController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _appController.checkBottomNavbarSection();

    _appController.checkGeoloc().then((value) {
      return _fetchData();
    }).catchError(logError);
  }

  Future<void> _fetchData() async {
    final List<Future<void>> futures = [];

    if ((Get.parameters[HomePage.paramAvoidFetchData] ?? "false") == "false") {
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

  void onJoinChannel(Channel channel) async {
    try {
      await _appController.joinChannel(channel);
    } catch (err) {
      logError(err);
    }
  }

  void onEnterChannel(Channel channel) async {
    try {
      await _appController.enterChannel(channel);
    } catch (err) {
      logError(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarHomeWidget(onPressedNotification: onPressedNotification),
        drawer: DrawerWidget(),
        onDrawerChanged: onDrawerChanged,
        body: Container(
          color: Colors.white,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const BrandHeaderWidget(),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text('Channels you follow',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Obx(() {
                    if (_appController.channels == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    List<Channel> channelsFollowing =
                        _appController.getFollowingChannels();
                    if (channelsFollowing.isEmpty) {
                      return Container(
                        height: 100,
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: Text(
                            "You don't follow any channel yet.",
                            style: TextStyle(
                                fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: Container(
                        height: 300,
                        child: GridChannelsWidget(
                            channels: channelsFollowing, onTap: onEnterChannel),
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Text('Explore',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Obx(() {
                    if (_appController.channels == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    List<Channel> channelsExplore =
                        _appController.getExploreChannels();
                    if (channelsExplore.isEmpty) {
                      return Container(
                        height: 100,
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: Text(
                            "You already follow all channels!",
                            style: TextStyle(
                                fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: Container(
                        height: 300,
                        child: GridChannelsWidget(
                            channels: channelsExplore, onTap: onJoinChannel),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBarWidget());
  }
}
