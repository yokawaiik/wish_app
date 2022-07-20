import 'package:isar/isar.dart';
import 'package:wish_app/src/modules/global/models/light_wish.dart';
import 'package:wish_app/src/modules/home/database/collections/user_collection.dart';
import 'package:wish_app/src/modules/home/database/collections/wish_collection.dart';

import '../../global/models/light_user.dart';

import '../constants/home_constants.dart' as home_constants;

class SuggestionsStorageHelper {
  // Make a singleton class
  SuggestionsStorageHelper._privateConstructor();

  static final SuggestionsStorageHelper instance =
      SuggestionsStorageHelper._privateConstructor();

  // Use a single reference to the db.
  static Isar? _isar;
  // Use this getter to use the database.
  Future<Isar> get _database async {
    if (_isar != null) return _isar!;
    // Instantiate db the first time it is accessed
    _isar = await _initDB();
    return _isar!;
  }

  // Init the database for the first time.
  Future<Isar> _initDB() async {
    final isar = await Isar.open(
      [
        WishCollectionSchema,
        UserCollectionSchema,
      ],
      name: home_constants.suggestionsDatabase,
    );
    return isar;
  }

// // TODO: getUserListSuggestion
  Future<List<LightUser>> getUserList() async {
    final isar = await _database;

    final gotTheUserCollection = await isar.userCollections.where().findAll();

    final gotTheUserList = gotTheUserCollection
        .map((user) => LightUser(
              id: user.id,
              login: user.login,
              imageUrl: user.imageUrl,
              userColor: user.userColor,
            ))
        .toList();

    return gotTheUserList;
  }

// // TODO: addUserToSuggestion
  Future<void> addUser(LightUser lightUser) async {
    final isar = await _database;

    await isar.writeTxn(() async {
      await isar.userCollections.put(
        UserCollection(
          id: lightUser.id,
          login: lightUser.login,
          imageUrl: lightUser.imageUrl,
          userColor: lightUser.userColor,
        ),
      );
    });
  }

// // TODO: removeUser
  Future<void> removeUser(String id) async {
    final isar = await _database;

    await isar.writeTxn(() async {
      // await isar.userCollections.where().filter().idEqualTo(id).deleteFirst();
      await isar.userCollections.deleteByIndex("id", [id]);
    });
  }

// // TODO: getUserListSuggestion
  Future<List<LightWish>> getWishList() async {
    final isar = await _database;

    final gotTheWishCollection = await isar.wishCollections.where().findAll();

    final gotTheWishList = gotTheWishCollection
        .map((user) => LightWish(
              id: user.id,
              title: user.title,
              imageUrl: user.imageUrl,
              userColor: user.userColor,
            ))
        .toList();

    return gotTheWishList;
  }

// // TODO: addWishToSuggestion
  Future<void> addWish(LightWish lightWish) async {
    final isar = await _database;

    await isar.writeTxn(() async {
      await isar.wishCollections.put(
        WishCollection(
          id: lightWish.id,
          title: lightWish.title,
          imageUrl: lightWish.imageUrl,
          userColor: lightWish.userColor,
        ),
      );
    });
  }

// // TODO: removeWish
  Future<void> removeWish(int id) async {
    final isar = await _database;

    await isar.writeTxn(() async {
      // await isar.userCollections.where().filter().idEqualTo(id).deleteFirst();
      await isar.wishCollections.deleteByIndex("id", [id]);
    });
  }
}
