import 'package:flutter/material.dart';

import '../../../shared/widgets/applogo.dart';
import '../../../shared/widgets/customtext.dart';

class AboutUS extends StatelessWidget {
  const AboutUS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
          "aboutUs".tr(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const AppLogo(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomText(
              "aboutUsText".tr(),
              align: TextAlign.center,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ],
      ),
      // body: FutureBuilder(
      //     future: StaticPagesRepo.aboutUs(context),
      //     builder: (context, snapshot) {
      //       return snapshot.connectionState == ConnectionState.waiting
      //           ? Center(
      //               child: MyLoading.loadingWidget(),
      //             )
      //           : Padding(
      //               padding: const EdgeInsets.symmetric(
      //                   horizontal: 16, vertical: 10),
      //               child: HtmlWidget(snapshot.data.toString()),
      //             );
      //     }),
    );
  }
}
