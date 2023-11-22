import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:talk_around/domain/models/user.dart';

import 'package:talk_around/domain/use_cases/auth_use_case.dart';
import 'package:talk_around/domain/use_cases/channel_use_case.dart';
import 'package:talk_around/domain/use_cases/message_use_case.dart';
import 'package:talk_around/domain/use_cases/topic_use_case.dart';
import 'package:talk_around/domain/use_cases/user_use_case.dart';

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

    _authUseCase.isLoggedIn().then((value) {
      _isLoggedIn.value = value;
    }).catchError((err) {
      _isLoggedIn.value = false;
      logError(err);
    });

    _userUseCase.getCurrentUser().then((value) {
      _currentUser.value = value;
    }).catchError((err) {
      _currentUser.value = null;
      logError(err);
    });
  }

  Future<void> signIn(String email, String password) async {
    await _authUseCase.signIn(email, password);
    _isLoggedIn.value = true;
    if (_isAnonymous.value) _isAnonymous.value = false;
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

  Future<void> signUp(User user) async {
    logInfo('Controller Sign Up');

    final User newUser = await _authUseCase.signUp(user);
    _isLoggedIn.value = true;
    if (_isAnonymous.value) _isAnonymous.value = false;

    await _userUseCase.setLocalUser(newUser);
    _currentUser.value = user;
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
