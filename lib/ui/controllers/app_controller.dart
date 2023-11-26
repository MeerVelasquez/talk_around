import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:talk_around/domain/models/channel.dart';
import 'package:talk_around/domain/models/topic.dart';
import 'package:talk_around/domain/models/user.dart';
import 'package:talk_around/domain/repositories/auth_repository.dart';

import 'package:talk_around/domain/use_cases/auth_use_case.dart';
import 'package:talk_around/domain/use_cases/channel_use_case.dart';
import 'package:talk_around/domain/use_cases/message_use_case.dart';
import 'package:talk_around/domain/use_cases/topic_use_case.dart';
import 'package:talk_around/domain/use_cases/user_use_case.dart';
import 'package:talk_around/ui/routes.dart';

class AppController extends GetxController {
  final AuthUseCase _authUseCase = Get.find<AuthUseCase>();
  final ChannelUseCase _channelUseCase = Get.find<ChannelUseCase>();
  final MessageUseCase _messageUseCase = Get.find<MessageUseCase>();
  final TopicUseCase _topicUseCase = Get.find<TopicUseCase>();
  final UserUseCase _userUseCase = Get.find<UserUseCase>();

  final Rx<bool> _isLoggedIn = Rx<bool>(false);
  final Rx<bool> _isAnonymous = Rx<bool>(false);
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isAnonymous => _isAnonymous.value;

  final Rx<User?> _currentUser = Rx<User?>(null);
  final Rx<User?> _user = Rx<User?>(null);
  User? get currentUser => _currentUser.value;
  User? get user => _currentUser.value;

  final Rx<bool> _isGeolocEnabled = Rx<bool>(false);
  bool get isGeolocEnabled => _isGeolocEnabled.value;

  final Rx<List<Channel>?> _channels = Rx<List<Channel>?>(null);
  List<Channel>? get channels => _channels.value;

  final Rx<List<Topic>?> _topics = Rx<List<Topic>?>(null);
  List<Topic>? get topics => _topics.value;

  final Rx<bool> _isDrawerOpen = Rx<bool>(false);
  bool get isDrawerOpen => _isDrawerOpen.value;
  set isDrawerOpen(bool value) => _isDrawerOpen.value = value;

  @override
  void onInit() {
    super.onInit();

    run() async {
      // try {
      //   _isLoggedIn.value = await _authUseCase.isLoggedIn();
      // } catch (err) {
      //   _isLoggedIn.value = false;
      //   logError(err);
      // }
      try {
        await getCurrentUser();
      } catch (err) {
        logError(err);
      }
    }

    run().catchError(logError);

    _authUseCase.authChanges.listen((AuthChangeData? authChangeData) async {
      if (authChangeData == null) {
        logInfo('Not logged in');
        if (_isLoggedIn.value) _isLoggedIn.value = false;
        if (_isAnonymous.value) _isAnonymous.value = false;

        await _userUseCase.deleteLocalUser();
        _currentUser.value = null;
        _isGeolocEnabled.value = false;
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
    Get.offNamed(AppRoutes.signUp);
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
        channels: []);

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
    _isLoggedIn.value = true;
    if (_isAnonymous.value) _isAnonymous.value = false;

    Get.offNamed(AppRoutes.home);
  }

  Future<void> signInWithGoogle() async {
    logInfo('Controller Sign In With Google');
    await _authUseCase.signInWithGoogle();
    _isLoggedIn.value = true;
    if (_isAnonymous.value) _isAnonymous.value = false;
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

    Get.offNamed(AppRoutes.home);
  }

  Future<void> logOut() async {
    logInfo('Controller Log Out');
    await _authUseCase.logOut();
    _isLoggedIn.value = false;
    _isAnonymous.value = false;

    Get.offNamed(AppRoutes.signIn);

    await _userUseCase.deleteLocalUser();
    _currentUser.value = null;
    _isGeolocEnabled.value = false;
  }

  void toggleGeolocLocal(bool value) {
    logInfo('Controller Toggle Geoloc');
    // if (_currentUser.value == null) {
    //   throw Exception('User is null');
    // }
    // _currentUser.value!.geolocEnabled = value;
    // _currentUser.refresh();

    _isGeolocEnabled.value = value;
  }

  Future<void> updateGeolocRemote() async {
    logInfo('Controller Toggle Geoloc');
    if (_currentUser.value == null || _currentUser.value!.id == null) {
      throw Exception('User or id is null');
    }
    if (_isGeolocEnabled.value != _currentUser.value!.geolocEnabled) {
      _currentUser.value!.geolocEnabled = _isGeolocEnabled.value;
      _currentUser.refresh();

      await _userUseCase.updatePartialCurrentUser(_currentUser.value!.id!,
          geolocEnabled: _isGeolocEnabled.value);
      logInfo('Geoloc updated');
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
  }

  Future<void> getUser(String id) async {
    logInfo("Getting user");
    _user.value = await _userUseCase.getUser(id);
  }

  Future<List<User>> getUsersFromChannel(String channelId) async {
    return await _userUseCase.getUsersFromChannel(channelId);
  }

  Future<User> updatePartialCurrentUser(
      {String? name,
      String? email,
      String? username,
      // String? password,
      bool? geolocEnabled,
      int? prefGeolocRadius,
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
    // if (_isGeolocEnabled.value) {

    // _channels.value = await _channelUseCase.getChannels();
    // } else {
    //   _channels.value = await _channelUseCase.getChannels(lat: _currentUser.value!.lat);
    // }
    _channels.value = await _channelUseCase.getChannels();
  }

  Future<void> fetchTopics() async {
    _topics.value = await _topicUseCase.getTopics();
  }
}
