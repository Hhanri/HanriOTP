import 'package:encrypt/encrypt.dart';

class Khazix {
  static final khaKey = Key.fromUtf8('+KbPeShVmYq3t6v9');
  static final vi = IV.fromLength(16);
  static final encrypter = Encrypter(AES(khaKey));

  static Encrypted encryptPin(String text) {
    return encrypter.encrypt(text, iv: vi);
  }
  static String decryptPin(Encrypted encryptedText) {
    return encrypter.decrypt(encryptedText, iv: vi);
  }
}