import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:sporto/core/constants/app_colors.dart';
import 'package:sporto/responsive.dart';

AppBar globalAppBar(
  BuildContext context,
  String title, {
  List<Widget>? actions,
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.white,
    scrolledUnderElevation: 0.0,
    centerTitle: false,
    leading: GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 50, // Set a fixed height
        width: 50, // Set a fixed width
        decoration: BoxDecoration(
          color: AppColors.textHint,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Icon(Icons.arrow_back_ios, size: 20), // Adjust size if needed
        ),
      ),
    ),
    actions: actions ?? [],
    title: Text(
      title.tr,
      style: GoogleFonts.amaranth(
        color: AppColors.textPrimary,
        fontSize: isTab(context) ? 10.sp : 15.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
