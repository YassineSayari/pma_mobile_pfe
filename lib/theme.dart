import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);

  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);



  static const double appBarFontSize = 40.0;
  static const double totalObjectFontSize=20.0;  
  static const double sortandfilterIconFontSize=25.0;
  static const String fontName = 'Rubik';



    static TextStyle get multiSelectDropDownTextStyle => TextStyle(
    color: Color(0xFF000000),
    fontSize: 20.sp,
    fontFamily: AppTheme.fontName,
  );

  static TextStyle get multiSelectDropDownLabelStyle => TextStyle(
    color: Color.fromARGB(255, 173, 170, 186),
    fontSize: 25.sp,
    fontFamily: AppTheme.fontName,
    fontWeight: FontWeight.w600,
  );

  static OutlineInputBorder get multiSelectDropDownEnabledBorder => OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.r)),
    borderSide: BorderSide(
      width: 2.w,
      color: Colors.grey,
    ),
  );

  static OutlineInputBorder get multiSelectDropDownFocusedBorder => OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.r)),
    borderSide: BorderSide(
      width: 2.w,
      color: Colors.deepPurple,
    ),
  );

 static TextStyle defaultItemStyle= const TextStyle(
      fontFamily: AppTheme.fontName,
      fontWeight: FontWeight.w500
  );
 static TextStyle selectedItemStyle= const TextStyle(
      color: AppColors.drawerItemColor,
      fontFamily: AppTheme.fontName,
      fontWeight: FontWeight.w500
  );


}

class AppColors {
  static const Color primaryColor = Colors.blue;
  static const Color dialogBackgroundColor = Colors.white;
  static const Color buttonTextPrimary = Colors.blue;
  static const Color buttonTextSecondary = Colors.grey;
  static const Color drawerItemColor=Color.fromARGB(255, 30, 195, 18);
}



class AppButtonStyles {
  static ButtonStyle submitButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 56, 161, 27),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  static TextStyle submitButtonTextStyle= TextStyle(
    color: Colors.white,
    fontSize: 30.sp,
    fontFamily: AppTheme.fontName,
    fontWeight: FontWeight.w500,
  );


   static ButtonStyle cancelButtonStyle =ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                            );
}


class TextInputDecorations {
  static InputDecoration customInputDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: Color.fromARGB(255, 173, 170, 186),
        fontSize: 25.sp,
        fontWeight: FontWeight.w600,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        borderSide: BorderSide(
          width: 3,
          color: Colors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        borderSide: BorderSide(
          width: 3,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  static final TextStyle textStyle = TextStyle(
    color: Color(0xFF000000),
    fontSize: 27.sp,
    fontWeight: FontWeight.w500,
  );
}


class DateFieldsStyle {
  static TextStyle textStyle = TextStyle(
    color: Color(0xFF000000),
    fontSize: 20.sp,
    fontFamily: AppTheme.fontName,
  );

  static TextStyle labelStyle = TextStyle(
    color: Color.fromARGB(255, 173, 170, 186),
    fontSize: 25.sp,
    fontFamily: AppTheme.fontName,
    fontWeight: FontWeight.w600,
  );

  static OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.r)),
    borderSide: BorderSide(
      width: 2.w,
      color: Colors.deepPurple,
    ),
  );

  static OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.r)),
    borderSide: BorderSide(
      width: 2.w,
      color: Colors.deepPurple,
    ),
  );
}


