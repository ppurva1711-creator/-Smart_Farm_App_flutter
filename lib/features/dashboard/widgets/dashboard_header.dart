import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {

  const DashboardHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
          const EdgeInsets.all(24),

      decoration: BoxDecoration(

        gradient:
            const LinearGradient(

          colors: [

            Color(0xFFFF9800),
            Color(0xFFFFB74D),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          28,
        ),
      ),

      child: Row(

        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

        children: [

          const Column(

            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [

              Text(

                "Smart Farm",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 28,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(

                "Realtime Monitoring",

                style: TextStyle(

                  color: Colors.white70,

                  fontSize: 16,
                ),
              ),
            ],
          ),

          Container(

            padding:
                const EdgeInsets.all(
              16,
            ),

            decoration: BoxDecoration(

              color:
                  Colors.white
                      .withOpacity(0.2),

              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),

            child: const Icon(

              Icons.agriculture,

              color: Colors.white,

              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}