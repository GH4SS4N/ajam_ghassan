import 'package:ajamapp/Common/Exceptions.dart';
import 'package:ajamapp/Model/Owner.dart';
import 'package:ajamapp/Model/Store.dart';
import 'package:ajamapp/Utils/config.dart';
import 'package:ajamapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 * take these providers away from here and stick them anywhere you want.
 */

enum AccountType { captain, owner, none }

/*
 * State Providers
 */

final accountTypeProvider =
    StateProvider<AccountType>((ref) => AccountType.none);

final currentUserProvider =
    StateProvider<ParseUser>((ref) => ParseUser("", "", ""));

final otpPassword = StateProvider<String>((ref) => "");

/*
 *  Action providers
 */

/* RUN THE FUNCTION
  context
      .read(userByPhoneNumberProvider)
      .request()
      .then((result) => dosomthing)
      .catchError((e) => exceptionSnackbar(context, e));
*/

/* Read loading (bool)
  watch(userByPhoneNumberProvider.state)
*/

// returns ParseUser if exists, and null if none exist
final userByPhoneNumberProvider =
    StateNotifierProvider<FunctionLoading<ParseUser>>(
        (ref) => FunctionLoading(() async {
              final queryBuilder = QueryBuilder<ParseUser>(ParseUser.forQuery())
                ..whereEqualTo(
                    "username", ref.watch(currentUserProvider).state.username);

              final response = await parseRequest(queryBuilder.query);

              return response.results?.elementAt(0);
            }));

// resturns ParseUser
final signUpProvider = StateNotifierProvider<FunctionLoading<ParseUser>>(
    (ref) => FunctionLoading(() async {
          final response =
              await parseRequest(ref.watch(currentUserProvider).state.signUp);

          return response.results?.elementAt(0);
        }));

// resturns ParseUser
final loginProvider = StateNotifierProvider<FunctionLoading<ParseUser>>(
    (ref) => FunctionLoading(() async {
          final response =
              await parseRequest(ref.watch(currentUserProvider).state.login);

          return response.results?.elementAt(0);
        }));

// returns true if request sent
final otpRequestProvider = StateNotifierProvider<FunctionLoading<bool>>(
    (ref) => FunctionLoading(() async {
          final phoneNumber = ref.watch(currentUserProvider).state.username;

          final response = await parseRequest(() async =>
              await ParseCloudFunction('otp')
                  .execute(parameters: {"phone_number": phoneNumber}));

          return response.success;
        }));

// returns true if verified
final otpVerifyProvider = StateNotifierProvider<FunctionLoading<bool>>(
    (ref) => FunctionLoading(() async {
          final phoneNumber = ref.watch(currentUserProvider).state.username;
          final password = ref.watch(otpPassword).state;

          final response = await parseRequest(
              () async => await ParseCloudFunction('otp').execute(parameters: {
                    "phone_number": phoneNumber,
                    "password": password,
                  }));

          switch (response.error?.code) {
            case 500:
              throw OTPExpired();
              break;
            case 409:
              throw WrongOTP();
              break;
          }

          return true;
        }));

/*
 * FutureProviders
 */
// watch(connectionProvider).when(data: (parse) {}, error: (e, stack){}, loading: (){});

final storeProvider = FutureProvider<Store>((ref) async {
  final queryBuilder = QueryBuilder<Store>(Store())
    ..whereMatchesQuery(
        "user", QueryBuilder(ref.watch(currentUserProvider).state));

  final response = await parseRequest(queryBuilder.query);

  return response.results?.elementAt(0);
});

final connectionProvider = FutureProvider<Parse>((ref) async {
  return await Parse().initialize(
    appId,
    serverUrl,
    clientKey: clientKey,
    debug: true,
  );
});

/*
 * Base requester
 */
Future<ParseResponse> parseRequest(Function request) async {
  ParseResponse response;
  try {
    response = await request();
  } catch (e) {
    throw CouldNotConnect();
  }

  if (response.error?.code == 403) throw UnsupportedVersion();

  return response;
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
