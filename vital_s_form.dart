import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VitalsForm extends StatelessWidget {
  final TextEditingController heartRateController;
  final TextEditingController bpController;
  final TextEditingController temperatureController;
  final TextEditingController sugarController;

  const VitalsForm({
    Key? key,
    required this.heartRateController,
    required this.bpController,
    required this.temperatureController,
    required this.sugarController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vitals Check',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildVitalsField('Heart Rate', heartRateController, unit: 'bpm')),
            const SizedBox(width: 10),
            Expanded(child: _buildVitalsField('BP', bpController, showDropdown: true)),
            const SizedBox(width: 10),
            Expanded(child: _buildVitalsField('Temperature', temperatureController, unit: '°C')),
            const SizedBox(width: 10),
            Expanded(child: _buildVitalsField('Sugar', sugarController, showDropdown: true, unit: 'mg/dL')),
          ],
        ),
      ],
    );
  }

  Widget _buildVitalsField(String label, TextEditingController controller,
      {bool showDropdown = false, String unit = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Enter...',
                    hintStyle: const TextStyle(fontSize: 14),
                    suffixText: unit.isNotEmpty ? ' $unit' : null,
                  ),
                ),
              ),
              if (showDropdown)
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.arrow_drop_down, color: Colors.grey),
                ),
            ],
          ),
        ),
      ],
    );
  }
}