import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'Captain.dart';
import 'Exceptions.dart';
import 'Store.dart';
import 'config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

enum SignupStep { login, form, verification, profile, done }

final signupStepProvider =
    StateProvider<SignupStep>((ref) => SignupStep.verification);

enum AccountType { captain, owner, none }

final accountTypeProvider =
    StateProvider<AccountType>((ref) => AccountType.owner);

final currentUserProvider =
    StateProvider<ParseUser>((ref) => ParseUser("", "", null));

final otpPassword = StateProvider<String>((ref) => "");
final storeTypesProvider = StateProvider<List<ParseObject>>((ref) => []);

/*
 * FutureProviders
 */
// watch(connectionProvider).when(data: (parse) {}, error: (e, stack){}, loading: (){});

Future<Store> getStoredStore(ParseUser user) async {
  final queryBuilder = QueryBuilder<Store>(Store())
    ..whereEqualTo("user", user)
    ..includeObject(["storeType"]);

  final response = await _parseRequest(queryBuilder.query);

  final Store store = response.results?.elementAt(0);

  if (store == null) return Store()..user = user;

  store.logo = await store.logo.download();

  return store;
}

Future<Captain> getStoredCaptain(ParseUser user) async {
  final queryBuilder = QueryBuilder<Captain>(Captain())
    ..whereEqualTo("user", user);

  final response = await _parseRequest(queryBuilder.query);

  final Captain captain = response.results?.elementAt(0);

  if (captain == null) return Captain()..user = user;

  captain.photo = await captain.photo.download();
  captain.carFront = await captain.carFront.download();
  captain.carBack = await captain.carBack.download();
  captain.carInside = await captain.carInside.download();

  return captain;
}

final imageProvider =
    FutureProvider.family<File, ParseFile>((ref, image) async {
  if (image == null) return null;

  ParseFile downloaded = await _parseRequest(image.download);

  return downloaded.file;
});

final connectionProvider = FutureProvider<Parse>(
  (ref) async => await Parse().initialize(
    appId,
    serverUrl,
    clientKey: clientKey,
    fileDirectory: (await getExternalStorageDirectory()).path,
  ),
);

/*
 * Future functions
 */
// userByPhoneNumber(username).then((ParseUser) => doSomething).catchError((e, stack) => exceptionSnackbar(context, e));

Future<List<ParseObject>> getStoreTypes() async {
  final ParseResponse response =
      await _parseRequest(ParseObject("StoreType").getAll);

  final results = response.results;

  return results;
}

// returns ParseUser if exists, and null if none exist
Future<ParseUser> userByPhoneNumber(String username) async {
  final queryBuilder = QueryBuilder<ParseUser>(ParseUser.forQuery())
    ..whereEqualTo("username", username);

  final response = await _parseRequest(queryBuilder.query);

  return response.results?.elementAt(0);
}

Future<ParseUser> signupAndRequestOTP(ParseUser user) async {
  ParseUser newUser = await signup(user);

  try {
    await _otpRequest(newUser.username);
  } catch (e) {
    await logout();
    throw e;
  }

  return newUser;
}

Future<ParseUser> loginAndRequestOTP(ParseUser user) async {
  ParseUser newUser = await login(user);

  try {
    await _otpRequest(newUser.username);
  } catch (e) {
    await logout();
    throw e;
  }

  return newUser;
}

// resturns ParseUser
Future<ParseUser> signup(ParseUser user) async {
  final response = await _parseRequest(
    () async => await user.signUp(allowWithoutEmail: true),
  );

  return response.results?.elementAt(0);
}

// resturns ParseUser
Future<ParseUser> login(ParseUser user) async {
  final response = await _parseRequest(user.login);

  if (response.error?.code == 101) throw wrongPassword;

  return response.results?.elementAt(0);
}

Future logout() async {
  try {
    (await ParseUser.currentUser()).logout();
  } catch (e) {}
}

// returns true if request sent
Future _otpRequest(String username) async {
  await _parseRequest(() async => await ParseCloudFunction('otp')
      .execute(parameters: {"phone_number": username}));
}

// returns true if verified
Future otpVerify(String username, String password) async {
  final response = await _parseRequest(
    () async => await ParseCloudFunction('otpVerify').execute(
      parameters: {
        "phone_number": username,
        "password": password,
      },
    ),
  );

  switch (response.error?.code) {
    case 406:
      _otpRequest(username);
      throw otpExpired;
      break;
    case 409:
      throw wrongOTP;
      break;
  }
}

// returns the saved parse object
Future<ParseObject> saveParseObject(ParseObject object) async {
  final response = await _parseRequest(object.save);

  return response.results?.elementAt(0);
}

/*
 * Base requester
 */
Future _parseRequest(Function request) async {
  try {
    final response = await request();

    if (response.error != null && (response.error.code ~/ 100) % 10 == 5) {
      throw Exception();
    }

    return response;
  } catch (e) {
    throw couldNotConnect;
  }
}

/* 
 * Takes an async function and runs it when request() is called.
 * Used in a provider to observe the loading state while that async function works.
 */
class FunctionLoading<T> extends StateNotifier<bool> {
  final Future<T> Function() function;

  FunctionLoading(this.function) : super(false);

  Future<T> request() async {
    state = true;
    T response;

    try {
      response = await function();
      state = false;
    } catch (e) {
      state = false;
      throw e;
    }

    return response;
  }
}
