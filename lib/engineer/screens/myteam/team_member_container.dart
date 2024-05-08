import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:pma/const.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/theme.dart';

class MemberContainer extends StatefulWidget {
  final User user;
  final String projectName;

  MemberContainer({required this.user, required this.projectName});

  @override
  State<MemberContainer> createState() => _MemberContainerState();
}

class _MemberContainerState extends State<MemberContainer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Format the hiring date
    String formattedDate = DateFormat('MMM d, yyyy').format(widget.user.hiringDate);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.nearlyWhite,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0.r),
                    child: Image.network(
                      "$imageUrl/${widget.user.image}",
                      width: 100.0.w,
                      height: 100.0.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          noImageUrl,
                          width: 100.0.w,
                          height: 100.0.h,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                widget.user.fullName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25.sp,
                                  fontFamily: AppTheme.fontName,
                                ),
                              ),
                            ),
                            Spacer(),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(
                                  isExpanded ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down,
                                  size: 35,
                                  color: Color.fromARGB(255, 102, 31, 184),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.user.roles[0],
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.grey[600],
                            fontFamily: AppTheme.fontName,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Member of project: ",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.grey[600],
                                  fontFamily: AppTheme.fontName,
                                ),
                              ),
                              TextSpan(
                                text: widget.projectName,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.black,
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
  if (isExpanded)
  Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: AppTheme.fontName,
              ),
              children: [
                TextSpan(
                  text: "Hiring Date: ",
                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black),
                ),
                TextSpan(
                  text: formattedDate, 
                  style: TextStyle(color:Colors.grey[600]),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: AppTheme.fontName,
              ),
              children: [
                TextSpan(
                  text: "Email: ",
                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black),
                ),
                TextSpan(
                  text: widget.user.email,
                  style: TextStyle(color:Colors.grey[600]),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: AppTheme.fontName,
              ),
              children: [
                TextSpan(
                  text: "Phone: ",
                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black),
                ),
                TextSpan(
                  text: widget.user.phone,
                  style: TextStyle(color:Colors.grey[600]),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: AppTheme.fontName,
              ),
              children: [
                TextSpan(
                  text: "Address: ",
                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black),
                ),
                TextSpan(
                  text: widget.user.address,
                  style: TextStyle(color:Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
          ],
        ),
      ),
    );
  }
}
