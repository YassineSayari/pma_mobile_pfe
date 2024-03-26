import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pma/theme.dart';

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: FailSnackBar(message: 'Failed to update ......., please try again',),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                );
            },
            child: const Text("error Message"),
          )),
            Center(
              child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: SuccessSnackBar(message: 'finished .., client updated... successfully!',),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                );
            },
            child: const Text("success Message"),
          )),
        ],
      ),
    );
  }
}

class FailSnackBar extends StatelessWidget {
  const FailSnackBar({
    super.key,
    required this.message,
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
          Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 16.h),
          height: 92.h,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
          ),
          child: Row(
            children: [
              SizedBox(width: 65),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Fail!",style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 20.sp,color:Colors.white),),
                    Spacer(),
                    Text("$message",style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 15.sp
                    ),
                    maxLines: 2,
                    overflow:TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
            ),
            child: SvgPicture.asset("assets/icons/bubbles.svg",
            height: 48.h,
            width: 40.w,
            color: Color(0xFF801336),
            ),
          ),
        ),
        Positioned(
          top:  -15,
          left: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset("assets/icons/fail.svg",
              height: 40.h,
              ),
             Positioned(
              top: 12,
              child: SvgPicture.asset("assets/icons/check.svg",
              height: 16.h,
              ),
              ),
    
            ],
          ),
        ),
        ],
    );
  }
}
class SuccessSnackBar extends StatelessWidget {
  const SuccessSnackBar({
    super.key,
    required this.message,
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
          Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
          height: 92.h,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
          ),
          child: Row(
            children: [
              SizedBox(width: 65),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Success!",style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 20.sp,color:Colors.white),),
                    Spacer(),
                    Text("$message",style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 15.sp
                    ),
                    maxLines: 2,
                    overflow:TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
            ),
            child: SvgPicture.asset("assets/icons/bubbles.svg",
            height: 48.h,
            width: 40.w,
            color: Color(0xFF801336),
            ),
          ),
        ),
        Positioned(
          top:  -15,
          left: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset("assets/icons/fail.svg",
              height: 40.h,
              ),
             Positioned(
              top: 12,
              child: SvgPicture.asset("assets/icons/close.svg",
              height: 16.h,
              ),
              ),
    
            ],
          ),
        ),
        ],
    );
  }
}
