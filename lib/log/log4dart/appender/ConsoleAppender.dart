
import 'package:mib/log/log4dart/Level.dart';
import 'package:mib/log/log4dart/LogRecord.dart';
import 'package:mib/log/log4dart/LogRecordFormatter.dart';
import 'package:mib/log/log4dart/appender/Appender.dart';
import 'package:mib/log/log4dart/appender/AppenderType.dart';

///
/// A appender for writing logs to the console output
///
class ConsoleAppender extends Appender {
  @override
  void append(LogRecord logRecord) {
    print(LogRecordFormatter.format(logRecord, format, dateFormat: dateFormat));
    if (logRecord.stackTrace != null) {
      print(logRecord.stackTrace.toString());
    }
  }

  @override
  String toString() {
    return '$type $format $level';
  }

  @override
  void init(Map<String, dynamic> config, bool test, DateTime date) {
    created = date ?? DateTime.now();
    type = AppenderType.CONSOLE;
    if (config.containsKey('format')) {
      format = config['format'];
    } else {
      format = Appender.defaultFormat;
    }
    if (config.containsKey('dateFormat')) {
      dateFormat = config['dateFormat'];
    } else {
      dateFormat = Appender.defaultDateFormat;
    }
    if (config.containsKey('level')) {
      level = Level.fromString(config['level']);
    } else {
      level = Level.INFO;
    }
  }

  @override
  Appender getInstance() {
    return ConsoleAppender();
  }

  @override
  String getType() {
    return 'CONSOLE';
  }
}
