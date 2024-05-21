import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:encrypt/encrypt.dart';
import 'package:convert/convert.dart';

Future<String> deriveKey(String password, Uint8List salt) async {
  final keyBytes = utf8.encode(password);

  final keyDerivator = crypto.Pbkdf2(
    macAlgorithm: crypto.Hmac.sha256(),
    iterations: 100000,
    bits: 256,
  );

  final key = await keyDerivator.deriveKey(
      secretKey: crypto.SecretKey(keyBytes), nonce: salt);
  var byts = await key.extractBytes();
  return base64.encode(Uint8List.fromList(byts));
}

Future<String?> encrypt(String data, String password) async {
  try {
    var salt = Uint8List.fromList(List.generate(16, (_) => _));
    final key = await deriveKey(password, salt);
    final encrypter = Encrypter(AES(Key.fromBase64(key), mode: AESMode.cbc));
    final iv = IV.fromLength(16);
    final encrypted = encrypter.encrypt(data, iv: iv);
    var result = salt + iv.bytes + encrypted.bytes;
    return hex.encode(result);
  } catch (e) {
    return null;
  }
}

Future<String?> decrypt(String ciphertext, String password) async {
  try {
    final data = Uint8List.fromList(hex.decode(ciphertext));
    final salt = Uint8List.fromList(data.sublist(0, 16));
    final key = await deriveKey(password, salt);
    final encrypter = Encrypter(AES(Key.fromBase64(key), mode: AESMode.cbc));
    final iv = IV.fromBase64(base64Encode(data.sublist(16, 32)));
    final encrypted = Encrypted(data.sublist(32));
    return encrypter.decrypt(encrypted, iv: iv);
  } catch (e) {
    return null;
  }
}