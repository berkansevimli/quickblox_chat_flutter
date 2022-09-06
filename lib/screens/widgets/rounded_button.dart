import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../size_config.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    this.size = 64,
    @required this.iconSrc,
    this.color = Colors.white,
    this.iconColor = Colors.black,
    @required this.press,
  }) : super(key: key);

  final double size;
  final String? iconSrc;
  final Color color, iconColor;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6.0),
      child: SizedBox(
        height: getProportionateScreenWidth(size),
        width: getProportionateScreenWidth(size),
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.all(15 / 64 * size),
          child: InkWell(
            onTap: press,
            child: SvgPicture.asset(iconSrc!, color: iconColor),
          ),
        ),
      ),
    );
  }
}
