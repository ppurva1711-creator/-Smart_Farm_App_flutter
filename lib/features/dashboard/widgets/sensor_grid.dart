import 'package:flutter/material.dart';

class SensorGrid extends StatelessWidget {

  final Map sensors;
  final int solarPercent;

  const SensorGrid({
    super.key,
    required this.sensors,
    required this.solarPercent,
  });

  @override
  Widget build(BuildContext context) {

    return GridView.count(

      shrinkWrap: true,

      physics:
          const NeverScrollableScrollPhysics(),

      crossAxisCount: 2,

      crossAxisSpacing: 16,
      mainAxisSpacing: 16,

      childAspectRatio: 1.2,

      children: [

        buildCard(
          "Temperature",
          "${sensors["temperature"] ?? 0}°C",
          Icons.thermostat,
          Colors.orange,
        ),

        buildCard(
          "Humidity",
          "${sensors["humidity"] ?? 0}%",
          Icons.water_drop,
          Colors.blue,
        ),

        buildCard(
          "Soil Moisture",
          "${sensors["soilMoisture"] ?? 0}%",
          Icons.grass,
          Colors.green,
        ),

        buildCard(
          "Battery",
          "${sensors["battery"] ?? 0}%",
          Icons.battery_full,
          Colors.purple,
        ),

        buildCard(
          "Solar",
          "$solarPercent%",
          Icons.solar_power,
          Colors.amber,
        ),
      ],
    );
  }

  Widget buildCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {

    return Container(

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(24),

        boxShadow: [

          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.04,
            ),

            blurRadius: 10,
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(

            padding:
                const EdgeInsets.all(12),

            decoration: BoxDecoration(

              color:
                  color.withOpacity(
                0.15,
              ),

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const Spacer(),

          Text(

            value,

            style: const TextStyle(
              fontSize: 26,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}