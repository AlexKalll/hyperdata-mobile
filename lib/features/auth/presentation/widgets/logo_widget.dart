import 'package:flutter/material.dart';

import '../../../../../core/utils/screen_size.dart';
import '../../../../../core/widgets/image.dart';


class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: getScreenHeight(context)*0.02),
          child: Center(
            child: assetImageWidget("logo.png",scale: 2.5,)
          ),
        ),
      ],
    );
  }
}
