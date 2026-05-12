import '../../data/quran_surahs.dart';

class QuranRangeValidationResult {
  final bool isValid;
  final String? message;

  const QuranRangeValidationResult.valid()
      : isValid = true,
        message = null;

  const QuranRangeValidationResult.invalid(this.message) : isValid = false;
}

class QuranRangeValidator {
  const QuranRangeValidator._();

  static QuranRangeValidationResult validate({
    required int fromSurah,
    required int fromAyah,
    required int toSurah,
    required int toAyah,
  }) {
    if (fromSurah < 1 || fromSurah > 114 || toSurah < 1 || toSurah > 114) {
      return const QuranRangeValidationResult.invalid('يرجى اختيار سورة صحيحة');
    }

    final fromMax = surahByNumber(fromSurah).ayahCount;
    final toMax = surahByNumber(toSurah).ayahCount;

    if (fromAyah < 1 || fromAyah > fromMax) {
      return const QuranRangeValidationResult.invalid('آية البداية غير صحيحة');
    }
    if (toAyah < 1 || toAyah > toMax) {
      return const QuranRangeValidationResult.invalid('آية النهاية غير صحيحة');
    }
    if (fromSurah > toSurah) {
      return const QuranRangeValidationResult.invalid('نطاق الحفظ غير مرتب');
    }
    if (fromSurah == toSurah && fromAyah > toAyah) {
      return const QuranRangeValidationResult.invalid('آية البداية يجب أن تكون قبل آية النهاية');
    }

    return const QuranRangeValidationResult.valid();
  }
}
