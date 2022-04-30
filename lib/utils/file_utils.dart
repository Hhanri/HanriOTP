import 'package:intl/intl.dart';

class FileUtils {
  static String getDateFormatFileName() {
    return DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
  }
  static const String rootPath = "/storage/emulated/0/HanriOTP/";
  static const String aesExt = ".aes";
  static const String jsonExt = ".json";
}