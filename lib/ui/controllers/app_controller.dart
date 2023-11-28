import 'dart:async';

import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:talk_around/domain/models/channel.dart';
import 'package:talk_around/domain/models/message.dart';
import 'package:talk_around/domain/models/topic.dart';
import 'package:talk_around/domain/models/user.dart';
import 'package:talk_around/domain/models/user_location.dart';
import 'package:talk_around/domain/repositories/auth_repository.dart';

import 'package:talk_around/domain/use_cases/auth_use_case.dart';
import 'package:talk_around/domain/use_cases/channel_use_case.dart';
import 'package:talk_around/domain/use_cases/geoloc_use_case.dart';
import 'package:talk_around/domain/use_cases/message_use_case.dart';
import 'package:talk_around/domain/use_cases/topic_use_case.dart';
import 'package:talk_around/domain/use_cases/user_use_case.dart';
import 'package:talk_around/ui/pages/home_page.dart';
import 'package:talk_around/ui/routes.dart';
import 'package:talk_around/ui/widgets/bottom_nav_bar_widget.dart';

class AppController extends GetxController {
  final AuthUseCase _authUseCase = Get.find<AuthUseCase>();
  final ChannelUseCase _channelUseCase = Get.find<ChannelUseCase>();
  final GeolocUseCase _geolocUseCase = Get.find<GeolocUseCase>();
  final MessageUseCase _messageUseCase = Get.find<MessageUseCase>();
  final TopicUseCase _topicUseCase = Get.find<TopicUseCase>();
  final UserUseCase _userUseCase = Get.find<UserUseCase>();

  StreamSubscription<AuthChangeData?>? _authChangesSubscription;
  // final Rx<AuthChangeData?> _authChangeData = Rx<AuthChangeData?>(null);
  final Rx<bool> _isLoggedIn = Rx<bool>(false);
  final Rx<bool> _isAnonymous = Rx<bool>(false);
  final Rx<bool> _isLoggedInWithGoogle = Rx<bool>(false);
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isAnonymous => _isAnonymous.value;
  bool get isLoggedInWithGoogle => _isLoggedInWithGoogle.value;

  final Rx<User?> _currentUser = Rx<User?>(null);
  final Rx<User?> _user = Rx<User?>(null);
  User? get currentUser => _currentUser.value;
  User? get user => _currentUser.value;

  StreamSubscription<UserLocation?>? _geolocChangesSubscription;
  final Rx<bool> _isGeolocEnabled = Rx<bool>(false);
  final Rx<double?> _geolocPrefRadius = Rx<double?>(null);
  final Rx<UserLocation?> _userLocation = Rx<UserLocation?>(null);
  bool get isGeolocEnabled => _isGeolocEnabled.value;
  double? get geolocRadius => _geolocPrefRadius.value;
  set geolocRadius(double? value) => _geolocPrefRadius.value = value;
  UserLocation? get userLocation => _userLocation.value;

  final Rx<List<Channel>?> _channels = Rx<List<Channel>?>(null);
  final Rx<Channel?> _currentChannel = Rx<Channel?>(null);
  List<Channel>? get channels => _channels.value;
  Channel? get currentChannel => _currentChannel.value;

  final Rx<List<Topic>?> _topics = Rx<List<Topic>?>(null);
  List<Topic>? get topics => _topics.value;

  final Rx<List<User>?> _users = Rx<List<User>?>(null);
  List<User>? get users => _users.value;

  final Rx<bool> _isDrawerOpen = Rx<bool>(false);
  bool get isDrawerOpen => _isDrawerOpen.value;
  set isDrawerOpen(bool value) => _isDrawerOpen.value = value;

  final Rx<List<Message>?> _messages = Rx<List<Message>?>(null);
  List<Message>? get messages => _messages.value;
  Rx<List<Message>?> get messagesPublic => _messages;

  final Rx<int?> _currentSection = Rx<int?>(null);
  int? get currentSection => _currentSection.value;
  set currentSection(int? value) => _currentSection.value = value;

  @override
  void onInit() {
    super.onInit();

    _listenAuthChanges();
    getCurrentUserInitial();
  }

  Future<void> getCurrentUserInitial() async {
    try {
      return await getCurrentUser();
    } catch (err) {
      logError(err);
    }
  }

  void _listenAuthChanges() {
    _authChangesSubscription =
        _authUseCase.authChanges.listen((AuthChangeData? authChangeData) async {
      if (authChangeData == null) {
        logInfo('Not logged in');
        if (_isLoggedIn.value) _isLoggedIn.value = false;
        if (_isAnonymous.value) _isAnonymous.value = false;

        await _userUseCase.deleteLocalUser();
        _currentUser.value = null;
        _isGeolocEnabled.value = false;
        _geolocPrefRadius.value = null;
        return;
      }

      if (authChangeData.isAnonymous) {
        logInfo('Logged in as anonymous');
        if (!_isAnonymous.value) _isAnonymous.value = true;
        if (_isLoggedIn.value) _isLoggedIn.value = false;
      } else {
        logInfo('Logged in as ${authChangeData.email}');
        if (_isAnonymous.value) _isAnonymous.value = false;
        if (!_isLoggedIn.value) _isLoggedIn.value = true;
      }

      if (_isLoggedIn.value || _isAnonymous.value) {
        if ([AppRoutes.signIn, AppRoutes.signUp].contains(Get.currentRoute)) {
          Get.offNamed(AppRoutes.home);
        }
      } else {
        if (![AppRoutes.signIn, AppRoutes.signUp].contains(Get.currentRoute)) {
          Get.offNamed(AppRoutes.signIn);
        }
      }
    });
  }

  void goToSignUp() {
    Get.toNamed(AppRoutes.signUp);
  }

  void getStarted() {
    print('isLoggedIn $isLoggedIn');
    if (_isLoggedIn.value || _isAnonymous.value) {
      Get.offNamed(AppRoutes.home);
    } else {
      Get.offNamed(AppRoutes.signIn);
    }
  }

  Future<void> signUp(
      String name, String email, String username, String password) async {
    logInfo('Controller Sign Up');

    if (name.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty) {
      return Future.error('Empty fields');
    }

    User user = User(
        id: null,
        name: name,
        email: email,
        username: username,
        password: password,
        geolocEnabled: false,
        prefGeolocRadius: 100,
        lat: 0,
        lng: 0,
        channels: [],
        interests: []);

    final User newUser = await _authUseCase.signUp(user);
    logInfo('Sign up success');

    await _authUseCase.signIn(email, password);
    logInfo('Sign in success');

    try {
      await _userUseCase.setLocalUser(newUser);
    } catch (err) {
      logError(err);
    }

    _currentUser.value = user;
    _isGeolocEnabled.value = _currentUser.value!.geolocEnabled;
    _geolocPrefRadius.value = _currentUser.value!.prefGeolocRadius;
    _isLoggedIn.value = true;
    if (_isAnonymous.value) _isAnonymous.value = false;

    Get.offNamed(AppRoutes.home);
  }

  Future<void> signInWithGoogle() async {
    logInfo('Controller Sign In With Google');

    User? user = await _authUseCase.signInWithGoogle();
    user ??= User.defaultUser();

    try {
      await _userUseCase.setLocalUser(user);
    } catch (err) {
      logError(err);
    }

    _isLoggedIn.value = true;
    if (_isAnonymous.value) _isAnonymous.value = false;
    _currentUser.value = user;
    _isGeolocEnabled.value = _currentUser.value!.geolocEnabled;
    _geolocPrefRadius.value = _currentUser.value!.prefGeolocRadius;

    _isLoggedInWithGoogle.value = true;

    Get.offNamed(AppRoutes.home);
  }

  Future<void> signInAsAnonymous() async {
    logInfo('Controller Sign In As Anonymous');
    await _authUseCase.signInAsAnonymous();
    _isAnonymous.value = true;
    if (_isLoggedIn.value) _isLoggedIn.value = false;
  }

  Future<void> signIn(String email, String password) async {
    logInfo('Controller Sign In');

    if (email.isEmpty || password.isEmpty) {
      return Future.error('Empty fields');
    }

    await _authUseCase.signIn(email, password);
    logInfo('Sign in success');

    final User user = await _userUseCase.getUserByEmail(email);
    try {
      await _userUseCase.setLocalUser(user);
    } catch (err) {
      logError(err);
    }

    _isLoggedIn.value = true;
    if (_isAnonymous.value) _isAnonymous.value = false;
    _currentUser.value = user;
    _isGeolocEnabled.value = _currentUser.value!.geolocEnabled;
    _geolocPrefRadius.value = _currentUser.value!.prefGeolocRadius;

    Get.offNamed(AppRoutes.home);
  }

  Future<void> logOut() async {
    logInfo('Controller Log Out');

    if (_isLoggedIn.value) {
      if (_isLoggedInWithGoogle.value) {
        await _authUseCase.signOutGoogle();
        _isLoggedInWithGoogle.value = false;
      } else {
        await _authUseCase.logOut();
      }
      _isLoggedIn.value = false;
      _isAnonymous.value = false;

      Get.offNamed(AppRoutes.signIn);

      await _userUseCase.deleteLocalUser();
      _currentUser.value = null;
      _isGeolocEnabled.value = false;
      _geolocPrefRadius.value = null;
    }
  }

  void toggleGeoloc(bool value) {
    logInfo('Controller Toggle Geoloc');
    // if (_currentUser.value == null) {
    //   throw Exception('User is null');
    // }
    // _currentUser.value!.geolocEnabled = value;
    // _currentUser.refresh();

    _isGeolocEnabled.value = value;
    // if (_isLoggedIn.value) {
    // }
  }

  Future<void> saveGeolocPrefs() async {
    logInfo('Controller Toggle Geoloc');
    if (_isLoggedIn.value) {
      if (_currentUser.value == null || _currentUser.value!.id == null) {
        Future.error('User or id is null');
      }
      if (_currentUser.value!.geolocEnabled != _isGeolocEnabled.value ||
          _currentUser.value!.prefGeolocRadius != _geolocPrefRadius.value) {
        await _userUseCase.updatePartialCurrentUser(_currentUser.value!.id!,
            geolocEnabled: _isGeolocEnabled.value,
            prefGeolocRadius: _geolocPrefRadius.value);

        _currentUser.value!.geolocEnabled = _isGeolocEnabled.value;
        _currentUser.value!.prefGeolocRadius = _geolocPrefRadius.value;
        _currentUser.refresh();

        logInfo('Geoloc updated');

        try {
          await checkGeoloc();
        } catch (err) {
          logError(err);
        }
      }
    } else {
      Future.error('Saving geoloc prefs requires user to be logged in');
    }
  }

  // void setLoggedIn() {
  //   _isLoggedIn.value = true;
  //   if (_isAnonymous.value) _isAnonymous.value = false;
  // }

  Future<void> getCurrentUser() async {
    logInfo("Getting current user");
    _currentUser.value = await _userUseCase.getCurrentUser();
    _isGeolocEnabled.value =
        _currentUser.value != null ? _currentUser.value!.geolocEnabled : false;
    _geolocPrefRadius.value = _currentUser.value != null
        ? _currentUser.value!.prefGeolocRadius
        : null;
  }

  Future<void> getUser(String id) async {
    logInfo("Getting user");
    _user.value = await _userUseCase.getUser(id);
  }

  // Future<List<User>> getUsersFromChannel(String channelId) async {
  //   return await _userUseCase.getUsersFromChannel(channelId);
  // }

  Future<User> updatePartialCurrentUser(
      {String? name,
      String? email,
      String? username,
      // String? password,
      bool? geolocEnabled,
      double? prefGeolocRadius,
      double? lat,
      double? lng}) async {
    logInfo("Update user");
    if (_currentUser.value == null || _currentUser.value!.id == null) {
      return Future.error('User or id is null');
    }
    User updatedUser = await _userUseCase.updatePartialCurrentUser(
        _currentUser.value!.id!,
        name: name,
        email: email,
        username: username,
        geolocEnabled: geolocEnabled,
        prefGeolocRadius: prefGeolocRadius,
        lat: lat,
        lng: lng);

    _currentUser.value = updatedUser;
    _isGeolocEnabled.value = _currentUser.value!.geolocEnabled;
    return updatedUser;
  }

  Future<void> fetchChannels() async {
    logInfo('Controller Fetch Channels');
    if (_isGeolocEnabled.value && _userLocation.value != null) {
      _channels.value = await _channelUseCase.getChannels(
          lat: _userLocation.value!.lat,
          lng: _userLocation.value!.lng,
          radius: _geolocPrefRadius.value);
    } else {
      _channels.value = await _channelUseCase.getChannels();
    }
    // _channels.value = await _channelUseCase.getChannels();
  }

  Future<void> fetchTopics() async {
    _topics.value = await _topicUseCase.getTopics();
  }

  Future<void> fetchUsersFromChannel() async {
    if (_currentChannel.value == null || _currentChannel.value!.id == null) {
      return Future.error('Channel or id is null');
    }
    _users.value =
        await _userUseCase.getUsersFromChannel(_currentChannel.value!.id!);
  }

  Future<void> checkGeoloc() async {
    logInfo('Controller Check Geoloc');
    if (_isGeolocEnabled.value) {
      if (_geolocChangesSubscription == null) {
        try {
          await _geolocUseCase.startStream();
          _geolocChangesSubscription =
              _geolocUseCase.geolocChanges.listen((UserLocation? loc) {
            if (loc != null) {
              _userLocation.value = loc;
            } else {
              _isGeolocEnabled.value = false;
              logInfo('Couldn\'t get User Location');
            }
          });

          logInfo('Geoloc started');
        } catch (err) {
          logError(err);
          _isGeolocEnabled.value = false;
          _geolocPrefRadius.value = null;
        }
      }
    }
  }

  Future<void> stopListeningGeoloc() async {
    logInfo('Controller Stop Listening Geoloc');
    await _geolocUseCase.stopStream();
    if (_geolocChangesSubscription != null) {
      _geolocChangesSubscription!.cancel();
      _geolocChangesSubscription = null;
    }

    _userLocation.value = null;
    _isGeolocEnabled.value = false;
    _geolocPrefRadius.value = null;

    logInfo('Geoloc stopped');
  }

  void selectBottomNavBarItem(int index) {
    if (_currentSection.value == null) {
      throw Exception('currentSection is null');
    }

    if (_currentSection.value == index) {
      return;
    }
    logInfo(
        'Current route: ${BottomNavBarWidget.sections[_currentSection.value!].route}. Going to route ${BottomNavBarWidget.sections[index].route}');
    final String route = BottomNavBarWidget.sections[index].route;
    Get.offNamed(route, parameters: {
      if (route == AppRoutes.home) HomePage.paramAvoidFetchData: 'true'
    });
    _currentSection.value = index;
  }

  void checkBottomNavbarSection() {
    if (_currentSection.value == null) {
      final int index = BottomNavBarWidget.sections.indexOf(BottomNavBarWidget
          .sections
          .firstWhere((element) => element.route == Get.currentRoute));
      if (index != -1) {
        _currentSection.value = index;
      }
    }
  }

  List<Channel> getFollowingChannels() {
    if (_channels.value == null || _currentUser.value == null) return [];
    return _channels.value!
        .where((channel) => _currentUser.value!.channels!.contains(channel.id))
        .toList();
  }

  List<User> getUsersFromChannel() {
    if (_users.value == null ||
        _currentChannel.value == null ||
        _currentChannel.value!.id == null ||
        _currentChannel.value!.users == null) return [];
    return _users.value!
        .where((user) => _currentChannel.value!.users!.contains(user.id))
        .toList();
  }

  List<Channel> getExploreChannels() {
    if (_channels.value == null || _currentUser.value == null) return [];
    return _channels.value!
        .where((channel) => !_currentUser.value!.channels!.contains(channel.id))
        .toList();
  }

  Future<void> enterChannel(Channel channel) async {
    _currentChannel.value = channel;
    Get.toNamed(AppRoutes.channel);
  }

  Future<void> getOutChannel() async {
    _currentChannel.value = null;
    Get.back();
    _users.value = null;
    _messages.value = null;
    // Get.offNamed(AppRoutes.home);
  }

  Future<void> joinChannel(Channel channel) async {
    if (channel.id == null) {
      return Future.error('Channel id is null');
    }

    if (_currentUser.value == null || _currentUser.value!.id == null) {
      return Future.error('User or id is null');
    }

    if (_currentUser.value!.channels != null &&
        _currentUser.value!.channels!.contains(channel.id)) {
      return;
    }
    try {
      await _userUseCase.joinChannel(_currentUser.value!.id!, channel.id!);
      await _channelUseCase.joinChannel(channel.id!, _currentUser.value!.id!);
    } catch (err) {
      logError(err);
    }

    _currentUser.value!.channels!.add(channel.id!);
    _currentUser.refresh();

    channel.users!.add(_currentUser.value!.id!);

    await enterChannel(channel);
  }

  Future<void> leaveChannel(Channel channel) async {
    if (channel.id == null) {
      return Future.error('Channel id is null');
    }

    if (_currentUser.value == null || _currentUser.value!.id == null) {
      return Future.error('User or id is null');
    }

    if (_currentUser.value!.channels != null &&
        !_currentUser.value!.channels!.contains(channel.id)) {
      return;
    }
    await _userUseCase.leaveChannel(_currentUser.value!.id!, channel.id!);
    await _channelUseCase.leaveChannel(channel.id!, _currentUser.value!.id!);

    _currentUser.value!.channels!.remove(channel.id!);
    _currentUser.refresh();

    channel.users!.remove(_currentUser.value!.id!);

    if (_currentChannel.value != null &&
        _currentChannel.value!.id == channel.id) {
      _currentChannel.value = null;
      Get.offNamed(AppRoutes.home);
    }
  }

  Future<void> checkMessages() async {
    logInfo('Controller Check Messages');
    if (_currentUser.value == null || _currentUser.value!.id == null) {
      return Future.error('User or id is null');
    }
    if (_currentChannel.value == null || _currentChannel.value!.id == null) {
      return Future.error('Channel or id is null');
    }

    // print('Getting messages from channel ${_currentChannel.value!.id}');

    _messages.value = await _messageUseCase
        .getMessagesFromChannel(_currentChannel.value!.id!);

// print('Received ${_messages.value != null ? _messages.value!.length : 'null'} messages');

    _messageUseCase
        .getMessageChanges(_currentChannel.value!.id!, _currentUser.value!.id!)
        .listen((List<Message>? messages) {
      print(
          'STREAM: Receiving ${messages != null ? messages.length : 'null'} messages');
      _messages.value = messages;
    });
  }

  Future<void> sendMessage(String text) async {
    logInfo('Controller Send Message $text');
    String parsedText = text.trim();
    if (parsedText.isEmpty) return Future.error('Empty message');

    if (_currentUser.value == null || _currentUser.value!.id == null) {
      return Future.error('User or id is null');
    }
    if (_currentChannel.value == null || _currentChannel.value!.id == null) {
      return Future.error('Channel or id is null');
    }
    Message message = Message(
        text: parsedText,
        senderId: _currentUser.value!.id!,
        channelId: _currentChannel.value!.id!,
        createdAt: DateTime.now(),
        deleted: false,
        id: null);

    message = await _messageUseCase.createMessage(message);

    if (_messages.value == null) {
      _messages.value = [message];
    } else {
      _messages.value!.add(message);
      _messages.refresh();
    }
  }
}
