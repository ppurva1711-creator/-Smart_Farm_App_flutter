import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/dashboard_header.dart';
import 'providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {

  const DashboardScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {

    final dashboardAsync =
        ref.watch(
      dashboardStreamProvider,
    );

    return dashboardAsync.when(

      loading: () =>
          const Scaffold(

        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      ),

      error: (e, _) =>
          Scaffold(

        body: Center(
          child: Text(
            e.toString(),
          ),
        ),
      ),

      data: (event) {

        final rawData =
            event.snapshot.value;

        if (rawData == null) {

          return const Scaffold(

            body: Center(
              child: Text(
                "No Firebase Data Found",
              ),
            ),
          );
        }

        final data =
            Map<dynamic, dynamic>.from(
          rawData as Map,
        );

        return Scaffold(

          appBar: AppBar(
            title:
                const Text(
              "Smart Farm",
            ),
          ),

          body: Padding(

            padding:
                const EdgeInsets.all(
              20,
            ),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

const DashboardHeader(),

const SizedBox(height: 24),

                Text(
                  "Operating Mode: ${data["operatingMode"]}",
                ),

                const SizedBox(height: 20),

                Text(
                  "Solar: ${data["solarPercent"]}",
                ),

                const SizedBox(height: 20),

                Text(
                  "Power Mode: ${data["powerMode"]}",
                ),

                const SizedBox(height: 20),

                Text(
                  "Temperature: ${data["sensors"]["temperature"]}",
                ),

                const SizedBox(height: 20),

                Text(
                  "Humidity: ${data["sensors"]["humidity"]}",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}