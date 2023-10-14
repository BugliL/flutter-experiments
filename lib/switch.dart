import 'package:flutter/material.dart';

class SwitchNFC extends StatefulWidget {
  const SwitchNFC(
      {super.key, required this.initialValue, required this.onChanged});

  final bool initialValue;
  final ValueChanged<bool> onChanged;

  @override
  State<SwitchNFC> createState() => _SwitchNFCState();
}

class _SwitchNFCState extends State<SwitchNFC> {
  bool _lights = false;

  @override
  void initState() {
    super.initState();
    _lights = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('NFC'),
      value: _lights,
      onChanged: (bool value) {
        setState(() {
          _lights = value;
          widget.onChanged(value);
        });
      },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }
}
