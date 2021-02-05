import 'package:ajam/data/StoreType.dart';

import 'Exceptions.dart';
import 'Store.dart';
import 'config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

final currentUserProvider =
    StateProvider<ParseUser>((ref) => ParseUser("123456789", "", ""));

final otpPassword = StateProvider<String>((ref) => "");

/*
 * FutureProviders
 */
// watch(connectionProvider).when(data: (parse) {}, error: (e, stack){}, loading: (){});

final storeProvider = FutureProvider<Store>(
  (ref) async {
    final queryBuilder = QueryBuilder<Store>(Store())
      ..whereMatchesQuery(
          "user", QueryBuilder(ref.watch(currentUserProvider).state));

    final response = await _parseRequest(queryBuilder.query);

    return response.results?.elementAt(0) ?? Store()
      ..user = ref.read(currentUserProvider);
  },
);

final connectionProvider = FutureProvider<Parse>(
  (ref) async {
    return await Parse().initialize(
      appId,
      serverUrl,
      clientKey: clientKey,
      debug: true,
    );
  },
);

final storeTypesProvider = FutureProvider<List<String>>(
  (ref) async {
    final response = await _parseRequest(StoreType().getAll);

    final results = response.results
        .map<String>((storeType) => (storeType as StoreType).name)
        .toList();

    return results;
  },
);

/*
 * Future functions
 */
// userByPhoneNumber(username).then((ParseUser) => doSomething).catchError((e, stack) => exceptionSnackbar(context, e));

// returns ParseUser if exists, and null if none exist
Future<ParseUser> userByPhoneNumber(String username) async {
  final queryBuilder = QueryBuilder<ParseUser>(ParseUser.forQuery())
    ..whereEqualTo("username", username);

  final response = await _parseRequest(queryBuilder.query);

  return response.results?.elementAt(0);
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

Future logout(ParseUser user) async {
  try {
    user.logout();
  } catch (e) {}
}

// returns true if request sent
Future otpRequest(String username) async {
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
Future<ParseResponse> _parseRequest(Function request) async {
  try {
    final ParseResponse response = await request();

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
