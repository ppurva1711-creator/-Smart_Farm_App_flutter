import 'package:flutter/material.dart';

import '../../../core/services/firebase_service.dart';

class ValveCard extends StatefulWidget {

  final String valveId;
  final dynamic valveData;

  const ValveCard({
    super.key,
    required this.valveId,
    required this.valveData,
  });

  @override
  State<ValveCard> createState() =>
      _ValveCardState();
}

class _ValveCardState
    extends State<ValveCard> {

  final FirebaseService firebaseService =
      FirebaseService();

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    final bool desiredState =
        widget.valveData["desiredState"] == true;

    final bool hardwareState =
        widget.valveData["hardwareState"] == true;

    return Container(

      margin:
          const EdgeInsets.only(
        bottom: 18,
      ),

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(24),

        boxShadow: [

          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 12,
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(

            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [

              Text(

                widget.valveId
                    .toUpperCase(),

                style: const TextStyle(

                  fontSize: 22,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              Container(

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration: BoxDecoration(

                  color: hardwareState
                      ? Colors.green
                          .withOpacity(0.15)
                      : Colors.red
                          .withOpacity(0.15),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Text(

                  hardwareState
                      ? "OPEN"
                      : "CLOSED",

                  style: TextStyle(

                    color: hardwareState
                        ? Colors.green
                        : Colors.red,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          SizedBox(

            width: double.infinity,

            child: ElevatedButton(

              onPressed: loading
                  ? null
                  : () async {

                      setState(() {
                        loading = true;
                      });

                      await firebaseService
                          .setMotor(
                        !desiredState,
                      );

                      await Future.delayed(
                        const Duration(
                          milliseconds: 500,
                        ),
                      );

                      if (mounted) {

                        setState(() {
                          loading = false;
                        });
                      }
                    },

              style:
                  ElevatedButton.styleFrom(

                backgroundColor:
                    desiredState
                        ? Colors.red
                        : Colors.green,

                padding:
                    const EdgeInsets.symmetric(
                  vertical: 16,
                ),

                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
              ),

              child: loading
                  ? const SizedBox(

                      height: 22,
                      width: 22,

                      child:
                          CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(

                      desiredState
                          ? "TURN OFF"
                          : "TURN ON",

                      style:
                          const TextStyle(

                        color: Colors.white,

                        fontSize: 16,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}