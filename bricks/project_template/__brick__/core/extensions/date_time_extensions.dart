// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//
// extension DateTimeExtensions on DateTime? {
//   DateTime get validate {
//     if (this == null) {
//       return DateTime.now();
//     }
//     return this!;
//   }
//
//   String format({String format = 'dd/MM/yyyy', String locale = 'en'}) {
//     return DateFormat(format, locale).format(validate);
//   }
//
//   String formatTime({String format = 'hh:mm a', String locale = 'en'}) {
//     return DateFormat(format, locale).format(validate);
//   }
//
//   bool get isNull => this == null;
// }
//
// extension PickerDateRangeEx on PickerDateRange? {
//   PickerDateRange get validate {
//     if (this == null) {
//       return PickerDateRange(DateTime.now(), DateTime.now());
//     }
//     return this!;
//   }
//
//   DateTime get startDate => validate.startDate ?? DateTime.now();
//   DateTime get endDate => validate.endDate ?? DateTime.now();
//
//   String get startDateFormatted => startDate.format();
//   String get endDateFormatted => endDate.format();
//
//   String get formattedRange => '$startDateFormatted - $endDateFormatted';
//
//   int get daysDifference {
//     return endDate.difference(startDate).inDays;
//   }
// }
//
// extension DurationExtensions on Duration {
//   String get formatDuration {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(inMinutes.remainder(60));
//     final seconds = twoDigits(inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }
// }
