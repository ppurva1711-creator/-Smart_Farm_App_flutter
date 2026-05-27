import 'package:flutter/material.dart';

class StatusProgressCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color progressColor;

  const StatusProgressCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.orange.shade300,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                Icon(
                  icon,
                  color: Colors.white,
                ),

                Text(
                  "$value%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),

              child: LinearProgressIndicator(
                value: value / 100,
                minHeight: 8,
                backgroundColor: Colors.white30,
                valueColor:
                    AlwaysStoppedAnimation(
                  progressColor,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}