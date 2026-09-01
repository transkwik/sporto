import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';

class MCP {
  static createAlert(
    BuildContext context,
    String error,
    String errormsg,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Text(error), content: Text(errormsg));
      },
    );
  }

  static formatNewDateTime(String rawDate) {
    try {
      // ✅ Clean up unwanted spaces before parsing
      String cleaned = rawDate.replaceAll(' ', '');

      // ✅ Parse to DateTime
      DateTime dateTime = DateTime.parse(cleaned).toLocal();

      // ✅ Format to desired style
      return DateFormat('hh:mm a, dd MMM yyyy').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }

  static Widget noDataWidget({
    double? size,
    String assetPath = 'assets/lottie/NoData.json',
    String? message,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            assetPath,
            height: size ?? 35.h,
            width: size ?? 35.h,
            fit: BoxFit.contain,
          ),
          if (message != null) ...[
            SizedBox(height: 1.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  static Future<void> openBrowser(String redirectUrl) async {
    final Uri url = Uri.parse(redirectUrl);
    try {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw 'Could not launch $redirectUrl';
      }
    } catch (e) {
      throw 'Error opening URL: $e';
    }
  }

  static willpopAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to exit?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    navigateBack(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppColors.primary),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                GestureDetector(
                  onTap: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppColors.primary),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Exit', style: TextStyle(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static actionAlert(
    BuildContext context,
    String info,
    String msg,
    dynamic onTap,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(info),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                MCP.navigateBack(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: 20.w,
              height: 5.h,
              child: CustomButton(
                onPressed: onTap,
                label: 'OK',
              ),
            ),
          ],
        );
      },
    );
  }

  static navigateTo(BuildContext context, page) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static navigateBack(BuildContext context) async {
    Navigator.pop(context);
  }

  static showMessage(
    BuildContext context,
    message, {
    Color backgroundColor = AppColors.primary,
    IconData icon = Icons.info,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message.toString(),
                style: TextStyle(
                  color: AppColors.surface,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        duration: const Duration(seconds: 5),
        backgroundColor: backgroundColor,
      ),
    );
  }

  static errorHandler(BuildContext context, errorRes) async {
    switch (errorRes) {
      case 301:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Moved Permanently')));
        break;
      case 302:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Found')));
        break;
      case 401:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Unauthorized')));
        break;
      case 403:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Forbidden')));

        break;
      case 404:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Not Found')));
        break;
      case 500:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Internal Server Error')));
        break;
      case 502:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Bad Gateway')));
        break;
      case 503:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Service Unavailable')));

        break;
      case 504:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gateway Timeout')));
        break;
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Oops!...')));
    }
  }

  static dateFormate(now) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    final String formatted = formatter.format(DateTime.parse(now.toString()));
    return formatted;
  }

  static calculateDiscountPercentage({
    double? originalPrice,
    double? discountPrice,
  }) {
    // Handle null values
    if (originalPrice == null || discountPrice == null) {
      return 0;
    }

    // Handle zero or minus values
    if (originalPrice <= 0 || discountPrice < 0) {
      return 0;
    }

    // Discount should not be greater than original price
    if (discountPrice > originalPrice) {
      return 0;
    }

    double discount = ((originalPrice - discountPrice) / originalPrice) * 100;

    // Round to 2 decimals
    double finalDiscount = double.parse(discount.toStringAsFixed(2));

    // If value is like 95.0 return 95
    if (finalDiscount % 1 == 0) {
      return finalDiscount.toInt();
    }

    // Else return full decimal value like 95.5
    return finalDiscount;
  }

  static String dateConversion(now) {
    final DateFormat formatter = DateFormat('E, dd MMM yyyy');
    final DateTime parsedDate = DateFormat(
      'E, dd-MMM-yyyy',
    ).parse(now.toString());
    return formatter.format(parsedDate);
  }

  static String formatToMonthAndDay(dynamic now) {
    try {
      // Null check
      if (now == null || now.toString().trim().isEmpty) {
        return "No Date";
      }

      // Parse date safely
      DateTime? parsedDate = DateTime.tryParse(now.toString());

      // Invalid date check
      if (parsedDate == null) {
        return "No Date";
      }

      // Format date
      final DateFormat formatter = DateFormat('MMMM d');

      return formatter.format(parsedDate);
    } catch (e) {
      return "No Date";
    }
  }

  formatDateTime(dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.trim().isEmpty) {
      return "-"; // return placeholder if null or empty
    }

    try {
      // Parse input safely
      final DateTime dateTime = DateTime.parse(dateTimeStr);

      // Format output: 13 Sep 2025 01:58 PM
      final DateFormat formatter = DateFormat("dd MMM yyyy hh:mm a");
      return formatter.format(dateTime);
    } catch (e) {
      // If invalid date string
      return "-";
    }
  }

  getExpiryStatus(String? expiryDateStr) {
    if (expiryDateStr == null || expiryDateStr.trim().isEmpty) {
      return "No expiry date";
    }

    try {
      final DateTime expiryDate = DateTime.parse(expiryDateStr);
      final DateTime today = DateTime.now();

      // Clear time part to compare only dates
      final DateTime onlyExpiry = DateTime(
        expiryDate.year,
        expiryDate.month,
        expiryDate.day,
      );
      final DateTime onlyToday = DateTime(today.year, today.month, today.day);

      final int difference = onlyExpiry.difference(onlyToday).inDays;

      if (difference > 0) {
        return "Expiry in $difference day${difference > 1 ? 's' : ''}";
      } else if (difference == 0) {
        return "Expires today";
      } else {
        return "Expired ${difference.abs()} day${difference.abs() > 1 ? 's' : ''} ago";
      }
    } catch (e) {
      return "Invalid expiry date";
    }
  }

  static forceNavigateTo(BuildContext context, page) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => page),
    );
  }

  static double calculateFinalAmount({
    num? totalAmount,
    num? cashbackAmount,
    num? gst,
  }) {
    double total = (totalAmount ?? 0).toDouble();
    double cashback = (cashbackAmount ?? 0).toDouble();
    double gstAmount = (gst ?? 0).toDouble();

    return (total - cashback) + gstAmount;
  }

  static showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 12.0),
                Text(
                  "Are you sure you want to exit the app?",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigateBack(context);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: AppColors.primary,
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.surface,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () {
                        SystemChannels.platform.invokeMethod(
                          'SystemNavigator.pop',
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Text(
                          'Exit',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // mask mobile number
  static maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length != 10) {
      return 'Invalid number';
    }
    String countryCode = '';
    String start = phoneNumber.substring(0, 3); // First 3 digits
    String end = phoneNumber.substring(phoneNumber.length - 2); // Last 2 digits
    return '$countryCode${start}XXXXX$end';
  }

  //Map Launcher
  Future<void> chooseMapAndOpen(
    context,
    double latitude,
    double longitude,
    String title,
  ) async {
    final availableMaps = await MapLauncher.installedMaps;

    if (availableMaps.isNotEmpty) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var map in availableMaps)
                  ListTile(
                    onTap: () {
                      map.showMarker(
                        coords: Coords(latitude, longitude),
                        title: title,
                      );
                      Navigator.pop(context);
                    },
                    title: Text(map.mapName),
                    leading: Image.asset(map.icon, height: 30, width: 30),
                  ),
              ],
            ),
          );
        },
      );
    }
  }
}
