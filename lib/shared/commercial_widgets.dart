import 'package:flutter/material.dart';
import 'package:elorep_core/elorep_core.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

Future<String?> selectValue(
  BuildContext context,
  String title,
  Map<String, String> values,
  String selected,
) => showModalBottomSheet<String>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.white,
  showDragHandle: true,
  builder: (ctx) => SafeArea(
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(ctx).height * .75,
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          gap(),
          for (final e in values.entries)
            ListTile(
              title: Text(e.value),
              trailing: e.key == selected
                  ? const EloIcon('check', color: T.blue)
                  : null,
              onTap: () => Navigator.pop(ctx, e.key),
            ),
        ],
      ),
    ),
  ),
);
Widget orderCard(Snapshot data, Json o, VoidCallback tap) => InkWell(
  borderRadius: BorderRadius.circular(20),
  onTap: tap,
  child: Surface(
    padding: 16,
    radius: 20,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: txt(
                o['id'],
                size: 13,
                weight: FontWeight.w800,
                color: T.blue,
              ),
            ),
            AppStatus(o['status']),
          ],
        ),
        gap(12),
        txt(data.client(o['clientId'])['name'], weight: FontWeight.w700),
        gap(8),
        Row(
          children: [
            const EloIcon('building', size: 15, color: T.muted),
            const SizedBox(width: 5),
            txt(data.rep(o['repId'])['name'], size: 12, color: T.muted),
          ],
        ),
        gap(14),
        const Divider(height: 1, color: T.line),
        gap(12),
        Row(
          children: [
            Expanded(
              child: txt(
                money(o['cents']),
                size: 16,
                weight: FontWeight.w800,
                color: T.navy,
              ),
            ),
            txt(o['date'], size: 11, color: T.muted),
          ],
        ),
      ],
    ),
  ),
);
Widget orderSteps(bool review) => Padding(
  padding: const EdgeInsets.only(bottom: 14),
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: T.navy,
            child: review
                ? const EloIcon('check', size: 17, color: Colors.white)
                : txt('1', color: Colors.white),
          ),
          Container(height: 2, width: 90, color: T.line),
          CircleAvatar(
            radius: 16,
            backgroundColor: review ? T.navy : T.line,
            child: txt('2', color: review ? Colors.white : T.muted),
          ),
        ],
      ),
      gap(8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          txt(
            'Informações',
            size: 12,
            weight: FontWeight.w700,
            color: review ? T.muted : T.navy,
          ),
          txt(
            'Revisão',
            size: 12,
            weight: FontWeight.w700,
            color: review ? T.navy : T.muted,
          ),
        ],
      ),
    ],
  ),
);
