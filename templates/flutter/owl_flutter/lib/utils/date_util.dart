String HHMM(DateTime t) {
  String h = t.hour.toString();
  String m = t.minute.toString();
  return h.padLeft(2, '0') + ":" + m.padLeft(2, '0');
}

String YYYYMMDD(DateTime t) {
  String y = t.year.toString();
  String m = t.month.toString();
  String d = t.day.toString();
  return y.padLeft(4, '0') + '-' + m.padLeft(2, '0') + '-' + d.padLeft(2, '0');
}
