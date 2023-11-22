import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
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

      if (isLoggedIn || isAnonymous) {
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

  void getStarted() {
    if (isLoggedIn) {
      Get.offNamed(AppRoutes.home);
    } else {
      Get.offNamed(AppRoutes.signIn);
    }
  }

  Future<void> signUp(
      String name, String email, String username, String password) async {
    logInfo('Controller Sign Up');
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

    Get.offNamed(AppRoutes.home);
  }

  Future<void> logOut() async {
    logInfo('Controller Log Out');
    await _authUseCase.logOut();
    _isLoggedIn.value = false;
    _isAnonymous.value = false;

    await _userUseCase.deleteLocalUser();
    _currentUser.value = null;
  }

  // void setLoggedIn() {
  //   _isLoggedIn.value = true;
  //   if (_isAnonymous.value) _isAnonymous.value = false;
  // }

  Future<void> getCurrentUser() async {
    logInfo("Getting current user");
    _currentUser.value = await _userUseCase.getCurrentUser();
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
    if (currentUser == null || currentUser!.id == null) {
      return Future.error('User or id is null');
    }
    User updatedUser = await _userUseCase.updatePartialCurrentUser(
        currentUser!.id!,
        name: name,
        email: email,
        username: username,
        geolocEnabled: geolocEnabled,
        prefGeolocRadius: prefGeolocRadius,
        lat: lat,
        lng: lng);
    _currentUser.value = updatedUser;
    return updatedUser;
  }
}
