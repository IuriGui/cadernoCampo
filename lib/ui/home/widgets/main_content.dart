import 'package:caderno_de_campo/domain/models/local/local.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/propriedade/propriedade.dart';
import 'local_section.dart';

class MainContent extends StatelessWidget {
  List<Local> locais = [];

  Propriedade propriedade;

   MainContent({super.key, required this.locais, required this.propriedade});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const _CalendarStrip(),
          const Text('teste'),
          LocalSection(locais: locais, propriedade: propriedade,),
        ]
    );
  }
}

class _CalendarStrip extends StatelessWidget {
  const _CalendarStrip();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    const labels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (i) {
        final day = monday.add(Duration(days: i));
        final isToday =
            day.day == now.day &&
                day.month == now.month &&
                day.year == now.year;
        return _CalendarDay(
          label: labels[i],
          date: day.day.toString(),
          isSelected: isToday,
        );
      }),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final String label;
  final String date;
  final bool isSelected;

  const _CalendarDay({
    required this.label,
    required this.date,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.green : Colors.grey;
    final weight = isSelected ? FontWeight.bold : FontWeight.normal;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: color, fontWeight: weight),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.only(bottom: 4),
          decoration: isSelected
              ? const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.green, width: 2),
            ),
          )
              : null,
          child: Text(
            date,
            style: TextStyle(fontSize: 18, fontWeight: weight, color: color),
          ),
        ),
      ],
    );
  }
}
