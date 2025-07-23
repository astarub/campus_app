import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';
import 'package:intl/intl.dart';

enum _EndCondition { never, onDate, afterCount }

// RecurrenceOptionsDialog UI widget.
class RecurrenceOptionsDialog extends StatefulWidget {
  final String? initialRrule;
  final DateTime eventStartDate;
  const RecurrenceOptionsDialog({super.key, this.initialRrule, required this.eventStartDate});

  @override
  State<RecurrenceOptionsDialog> createState() => __RecurrenceOptionsDialogState();
}

// __RecurrenceOptionsDialogState UI widget.
class __RecurrenceOptionsDialogState extends State<RecurrenceOptionsDialog> {
  late Frequency _frequency;
  late int _interval;
  DateTime? _until;
  int? _count;
  late _EndCondition _endCondition;

  final _intervalController = TextEditingController();
  final _countController = TextEditingController();

  final List<Frequency> _frequencies = const [
    Frequency.yearly,
    Frequency.monthly,
    Frequency.weekly,
    Frequency.daily,
  ];

  @override
  void initState() {
    super.initState();
    RecurrenceRule? initialRule;
    try {
      initialRule = RecurrenceRule.fromString(widget.initialRrule ?? '');
    } catch (_) {}

    _frequency = initialRule?.frequency ?? Frequency.daily;
    _interval = initialRule?.interval ?? 1;
    _until = initialRule?.until;
    _count = initialRule?.count;

    if (_until != null) {
      _endCondition = _EndCondition.onDate;
    } else if (_count != null) {
      _endCondition = _EndCondition.afterCount;
    } else {
      _endCondition = _EndCondition.never;
    }

    _intervalController.text = _interval.toString();
    if (_count != null) _countController.text = _count.toString();
  }

  @override
  void dispose() {
    _intervalController.dispose();
    _countController.dispose();
    super.dispose();
  }

  void _save() {
    final int? finalCount = _endCondition == _EndCondition.afterCount ? _count : null;
    final DateTime? finalUntil = _endCondition == _EndCondition.onDate ? _until : null;

    final rule = RecurrenceRule(
      frequency: _frequency,
      interval: _interval,
      until: finalUntil,
      count: finalCount,
    );
    Navigator.of(context).pop(rule.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Event repeats'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _intervalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Every'),
                    onChanged: (value) => setState(() => _interval = int.tryParse(value) ?? 1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: DropdownButton<Frequency>(
                      isExpanded: true,
                      value: _frequency,
                      underline: const SizedBox(),
                      onChanged: (value) {
                        if (value != null && _frequencies.contains(value)) {
                          setState(() => _frequency = value);
                        }
                      },
                      items: _frequencies
                          .map((f) => DropdownMenuItem(value: f, child: Text(f.toString().split('.').last)))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Ends', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<_EndCondition>(
              title: const Text('Never'),
              value: _EndCondition.never,
              groupValue: _endCondition,
              onChanged: (v) => setState(() {
                _endCondition = v!;
                _until = null;
                _count = null;
              }),
            ),
            RadioListTile<_EndCondition>(
              title: Text(
                _until == null || _endCondition != _EndCondition.onDate
                    ? 'On a date...'
                    : 'On ${DateFormat.yMd().format(_until!.toLocal())}',
              ),
              value: _EndCondition.onDate,
              groupValue: _endCondition,
              onChanged: (v) async {
                setState(() => _endCondition = v!);
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _until?.toLocal() ?? DateTime.now(),
                  firstDate: widget.eventStartDate.toLocal(),
                  lastDate: DateTime(2040),
                );
                if (pickedDate != null) {
                  setState(() {
                    _until = DateTime.utc(pickedDate.year, pickedDate.month, pickedDate.day, 23, 59, 59);
                  });
                }
              },
            ),
            RadioListTile<_EndCondition>(
              title: const Text('After a number of occurrences'),
              value: _EndCondition.afterCount,
              groupValue: _endCondition,
              onChanged: (v) => setState(() {
                _endCondition = v!;
                _until = null;
                if (_count == null) {
                  _countController.clear();
                }
              }),
            ),
            if (_endCondition == _EndCondition.afterCount)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _countController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Occurrences'),
                  onChanged: (value) => setState(() => _count = int.tryParse(value)),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop('clear');
          },
          child: const Text('DONT REPEAT'),
        ),
        const Spacer(),
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        TextButton(onPressed: _save, child: const Text('Done')),
      ],
    );
  }
}
