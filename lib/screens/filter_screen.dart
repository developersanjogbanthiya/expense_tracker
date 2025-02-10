import 'package:flutter/material.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Row(
          children: [
            // Cross Button to dismiss

            // Filter text

            // Clear All Button
          ],
        ),
        Row(
          children: [
            Column(
              children: [
                // Months

                // Categories
              ],
            ),
            Column(
              children: [
                // if(months) then display last 6 months with check box

                // if Categories then display all categories with check box
              ],
            ),
          ],
        ),
        // Apply button
      ],
    ));
  }
}
