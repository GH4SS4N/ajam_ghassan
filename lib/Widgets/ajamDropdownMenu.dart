import 'package:ajam/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

final storeTypeSelectedProvider = StateProvider<String>((ref) => null);
final countrySelectedProvider = StateProvider<String>((ref) => "السعودية");
final citySelectedProvider = StateProvider<String>((ref) => "جدة");

class AjamDropdown extends ConsumerWidget {
  final StateProvider selectedState;
  final List<String> options;

  AjamDropdown({@required this.selectedState, @required this.options});

  @override
  Widget build(BuildContext context, watch) {
    final selected = watch(selectedState).state;

    return Container(
      padding: EdgeInsets.all(24),
      child: options == null
          ? CircularProgressIndicator()
          : DropdownButton<String>(
              isExpanded: true,
              value: selected ?? options[0] ?? '',
              items: options
                  .map(
                    (String item) => DropdownMenuItem<String>(
                      child: Text(item),
                      value: item,
                    ),
                  )
                  .toList(),
              isDense: true,
              underline: Container(),
              onChanged: (String newValue) =>
                  context.read(selectedState).state = newValue,
            ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          border: Border.all(color: lightgrey)),
    );
  }
}
