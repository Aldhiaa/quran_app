class ScoreCalculator {
  const ScoreCalculator._();

  static MonthlyTestScore monthlyTest({
    required num memorization,
    required num recitation,
    required num ahkam,
    required num matn,
    required num behavior,
  }) {
    _assertRange('الحفظ', memorization, 50);
    _assertRange('التلاوة', recitation, 50);
    _assertRange('الأحكام', ahkam, 30);
    _assertRange('المتن', matn, 20);
    _assertRange('السلوك', behavior, 50);

    final total = memorization + recitation + ahkam + matn + behavior;
    final percentage = (total / 200) * 100;
    return MonthlyTestScore(
      total: total,
      percentage: percentage,
      rating: ratingForPercentage(percentage),
    );
  }

  static String ratingForPercentage(num percentage) {
    if (percentage >= 90) return 'ممتاز';
    if (percentage >= 80) return 'جيد جداً';
    if (percentage >= 70) return 'جيد';
    if (percentage >= 60) return 'مقبول';
    return 'يحتاج متابعة';
  }

  static void _assertRange(String label, num value, num max) {
    if (value < 0 || value > max) {
      throw ArgumentError('$label يجب أن يكون بين 0 و $max');
    }
  }
}

class MonthlyTestScore {
  final num total;
  final num percentage;
  final String rating;

  const MonthlyTestScore({
    required this.total,
    required this.percentage,
    required this.rating,
  });
}

