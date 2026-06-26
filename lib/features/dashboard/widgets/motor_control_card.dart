import 'package:flutter/material.dart';

class MotorControlCard extends StatefulWidget {
  const MotorControlCard({super.key});

  @override
  State<MotorControlCard> createState() => _MotorControlCardState();
}

class _MotorControlCardState extends State<MotorControlCard> {
  bool isMotorOn = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Water Motor",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  isMotorOn ? "ON" : "OFF",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isMotorOn ? Colors.green : Colors.red,
                  ),
                ),

                Switch(
                  value: isMotorOn,

                  onChanged: (value) {
                    setState(() {
                      isMotorOn = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
