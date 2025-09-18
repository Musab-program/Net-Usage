import 'package:flutter/material.dart';
import 'package:net_uasge/core/widgets/custom_text.dart';

import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(pageName: 'الرئيسية',),
      body: Column(
        children: [
          CustomText(text: "musab"),
          CustomButton(buttonText:"click", onPressed: () {  },),
          CustomTextField(),

        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),

    );
  }
}
