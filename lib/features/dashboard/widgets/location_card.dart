import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {

  final Map location;

  const LocationCard({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Row(

            children: [

              Icon(
                Icons.location_on,
                color: Colors.red,
              ),

              SizedBox(width: 10),

              Text(

                "Live Location",

                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          buildInfo(
            "Latitude",
            "${location["lat"] ?? 0}",
          ),

          buildInfo(
            "Longitude",
            "${location["lng"] ?? 0}",
          ),

          buildInfo(
            "Speed",
            "${location["speedKmph"] ?? 0} km/h",
          ),

          buildInfo(
            "Satellites",
            "${location["satellites"] ?? 0}",
          ),

          buildInfo(
            "GPS Status",
            location["status"] ??
                "Searching",
          ),
        ],
      ),
    );
  }

  Widget buildInfo(
    String title,
    String value,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 14,
      ),

      child: Row(

        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

        children: [

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}