import 'package:flutter/material.dart';
import '../core/utils/quran_range_validator.dart';
import '../data/quran_surahs.dart';

class QuranRange {
  final int fromSurah;
  final int fromAyah;
  final int toSurah;
  final int toAyah;
  const QuranRange({
    required this.fromSurah,
    required this.fromAyah,
    required this.toSurah,
    required this.toAyah,
  });

  Map<String, dynamic> toJson() => {
        'from_surah': fromSurah,
        'from_ayah': fromAyah,
        'to_surah': toSurah,
        'to_ayah': toAyah,
      };

  String get summary {
    final f = surahByNumber(fromSurah);
    final t = surahByNumber(toSurah);
    if (fromSurah == toSurah) {
      return '${f.arabicName} (آية $fromAyah - $toAyah)';
    }
    return '${f.arabicName} آية $fromAyah → ${t.arabicName} آية $toAyah';
  }
}

class QuranRangePicker extends StatefulWidget {
  final String label;
  final QuranRange? initialRange;
  final ValueChanged<QuranRange> onChanged;

  const QuranRangePicker({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialRange,
  });

  @override
  State<QuranRangePicker> createState() => _QuranRangePickerState();
}

class _QuranRangePickerState extends State<QuranRangePicker> {
  late int _fromSurah;
  late int _fromAyah;
  late int _toSurah;
  late int _toAyah;
  String? _error;

  @override
  void initState() {
    super.initState();
    final r = widget.initialRange;
    _fromSurah = r?.fromSurah ?? 1;
    _fromAyah = r?.fromAyah ?? 1;
    _toSurah = r?.toSurah ?? 1;
    _toAyah = r?.toAyah ?? surahByNumber(1).ayahCount;
  }

  void _emit() {
    final range = QuranRange(
      fromSurah: _fromSurah,
      fromAyah: _fromAyah,
      toSurah: _toSurah,
      toAyah: _toAyah,
    );
    final validation = QuranRangeValidator.validate(
      fromSurah: range.fromSurah,
      fromAyah: range.fromAyah,
      toSurah: range.toSurah,
      toAyah: range.toAyah,
    );
    setState(() => _error = validation.message);
    if (validation.isValid) {
      widget.onChanged(range);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fromSurahMax = surahByNumber(_fromSurah).ayahCount;
    final toSurahMax = surahByNumber(_toSurah).ayahCount;
    if (_fromAyah > fromSurahMax) _fromAyah = fromSurahMax;
    if (_toAyah > toSurahMax) _toAyah = toSurahMax;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _surahDropdown('من سورة', _fromSurah, (v) {
                setState(() {
                  _fromSurah = v;
                  if (_fromAyah > surahByNumber(v).ayahCount) {
                    _fromAyah = surahByNumber(v).ayahCount;
                  }
                });
                _emit();
              })),
              const SizedBox(width: 6),
              SizedBox(width: 90, child: _ayahDropdown('آية', _fromAyah, fromSurahMax, (v) {
                setState(() => _fromAyah = v);
                _emit();
              })),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _surahDropdown('إلى سورة', _toSurah, (v) {
                setState(() {
                  _toSurah = v;
                  if (_toAyah > surahByNumber(v).ayahCount) {
                    _toAyah = surahByNumber(v).ayahCount;
                  }
                });
                _emit();
              })),
              const SizedBox(width: 6),
              SizedBox(width: 90, child: _ayahDropdown('آية', _toAyah, toSurahMax, (v) {
                setState(() => _toAyah = v);
                _emit();
              })),
            ]),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _surahDropdown(String label, int value, ValueChanged<int> onChanged) {
    return DropdownButtonFormField<int>(
      isExpanded: true,
      value: value,
      decoration: InputDecoration(labelText: label, isDense: true),
      items: kQuranSurahs
          .map((s) => DropdownMenuItem(value: s.number, child: Text('${s.number}. ${s.arabicName}', overflow: TextOverflow.ellipsis)))
          .toList(),
      onChanged: (v) { if (v != null) onChanged(v); },
    );
  }

  Widget _ayahDropdown(String label, int value, int max, ValueChanged<int> onChanged) {
    return DropdownButtonFormField<int>(
      isExpanded: true,
      value: value.clamp(1, max),
      decoration: InputDecoration(labelText: label, isDense: true),
      items: List.generate(max, (i) => i + 1)
          .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
          .toList(),
      onChanged: (v) { if (v != null) onChanged(v); },
    );
  }
}
