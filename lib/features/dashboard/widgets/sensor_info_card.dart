import 'package:flutter/material.dart';

class SensorInfoCard extends StatelessWidget {

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String tag;

  const SensorInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                CircleAvatar(
                  backgroundColor:
                      color.withOpacity(0.15),

                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color:
                        color.withOpacity(0.15),

                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: Text(
                    tag,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              value,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}