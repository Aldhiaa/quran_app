class ReportEndpoints {
  const ReportEndpoints._();

  static const reports = '/reports';
  static const generate = '/reports/generate';

  static String pdf(int id) => '/reports/$id/pdf';
  static String excel(int id) => '/reports/$id/excel';
}

