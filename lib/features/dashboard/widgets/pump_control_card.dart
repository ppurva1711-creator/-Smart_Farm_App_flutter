import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_service.dart';

class PumpControlCard extends ConsumerStatefulWidget {
  const PumpControlCard({super.key});

  @override
  ConsumerState<PumpControlCard> createState() =>
      _PumpControlCardState();
}

class _PumpControlCardState
    extends ConsumerState<PumpControlCard> {

  bool isPumpOn = false;

  @override
  Widget build(BuildContext context) {

    final firebaseService =
        FirebaseService();

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFFF5EBDD),
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(16),
                ),

                child: Icon(
                  Icons.power_settings_new,
                  size: 30,
                  color: isPumpOn
                      ? Colors.green
                      : Colors.grey,
                ),
              ),

              const SizedBox(width: 16),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Water Pump",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  Text(
                    isPumpOn
                        ? "Pump ON"
                        : "Pump OFF",

                    style: TextStyle(
                      color: isPumpOn
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [

              Expanded(
                child: ElevatedButton(

                  onPressed: () async {

                    setState(() {
                      isPumpOn = true;
                    });

                    await firebaseService
                        .setMotor(true);
                  },

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green,

                    foregroundColor:
                        Colors.white,

                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 18,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),

                  child: const Text(
                    "Turn ON",
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: OutlinedButton(

                  onPressed: () async {

                    setState(() {
                      isPumpOn = false;
                    });

                    await firebaseService
                        .setMotor(false);
                  },

                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        Colors.red,

                    side: const BorderSide(
                      color: Colors.red,
                    ),

                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 18,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),

                  child: const Text(
                    "Turn OFF",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}