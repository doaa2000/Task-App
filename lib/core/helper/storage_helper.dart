import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  // Create a private constructor to enforce the singleton pattern
  StorageHelper._privateConstructor();

  // A static instance to be used across the app
  static final StorageHelper instance = StorageHelper._privateConstructor();

  // The secure storage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Method to write data to secure storage
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  // Method to read data from secure storage
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Method to delete data from secure storage
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
