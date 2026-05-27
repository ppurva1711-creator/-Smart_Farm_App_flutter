import 'package:flutter/material.dart';

class PowerSourceCard extends StatefulWidget {
  const PowerSourceCard({super.key});

  @override
  State<PowerSourceCard> createState() =>
      _PowerSourceCardState();
}

class _PowerSourceCardState
    extends State<PowerSourceCard> {

  bool solarEnabled = true;

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Row(

        children: [

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: const [

                Text(
                  "Power Source",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  "AUTO (Solar)",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: solarEnabled,

            onChanged: (value) {
              setState(() {
                solarEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}