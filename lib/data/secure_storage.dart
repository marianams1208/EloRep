import 'package:elorep_core/elorep_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureSessionStorage implements SessionStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const key = 'elorep.figma.localdemo.v1';
  @override
  Future<String?> read() => storage.read(key: key);
  @override
  Future<void> write(String value) => storage.write(key: key, value: value);
  @override
  Future<void> clear() => storage.delete(key: key);
}
