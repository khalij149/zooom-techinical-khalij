import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../Terms_conditions_screen/presentation/view/Terms_conditions_screen.dart';
import '../../../contact_us/presentation/view/contact_us_form.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/utils/app_shared_preference.dart';
import '../../../auth/presentation/view/login_screen.dart';
import '../../../settings_screen/presentation/view/delete_confirm_dialog.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B1D27),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              height: 70.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Stack(
                alignment: Alignment.center,
                children: [

                  Text(
                    LocaleKeys.Profile_Profile.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Stack(
                children: [

                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.Profile_Profile.tr().toUpperCase(),
                          style: TextStyle(
                            color: Color(0xffFF5E5E),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        _buildProfileItem(
                          icon: Icons.person_outline,
                          title: LocaleKeys.profile_personal_data.tr(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                            );
                          },
                        ),

                        _buildProfileItem(
                          icon: Icons.translate,
                          title: LocaleKeys.profile_language.tr(),
                          onTap: () {
                            _showLanguageBottomSheet(context);
                          },
                        ),
                        _buildProfileItem(
                          icon: Icons.report_gmailerrorred_outlined,
                          title: LocaleKeys.Authentication_TermsConditions.tr(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TermsConditionsScreen()),
                            );
                          },
                        ),
                        _buildProfileItem(
                          icon: Icons.delete_forever_outlined,
                          title: LocaleKeys.settings_delete_account.tr(),
                          onTap: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (_) => const DeleteConfirmDialog(),
                            );
                            if (confirmed == true) {

                              showDialog(
                                context: context,
                                builder: (_) => const DeleteSuccessDialog(),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          LocaleKeys.general_support.tr().toUpperCase(),
                          style: TextStyle(
                            color: Color(0xffFF5E5E),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        _buildProfileItem(
                          icon: Icons.phone_in_talk_outlined,
                          title: LocaleKeys.contactus_title.tr(),
                          subtitle: LocaleKeys.start_project_help_title.tr(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ContactUsForm()),
                            );
                          },
                        ),
                        _buildProfileItem(
                          icon: Icons.logout,
                          title: LocaleKeys.drawer_logout.tr(),
                          onTap: () async {
                            await SharedPreferencesUtils.removeData(key: AppValues.token);
                            await SharedPreferencesUtils.removeData(key: AppValues.user);
                            await SharedPreferencesUtils.removeData(key: AppValues.loggedIn);

                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                                    (route) => false,
                              );
                            }
                          },
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
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      builder: (context) {
        return const _LanguageBottomSheet();
      },
    );
  }

}

class _LanguageBottomSheet extends StatefulWidget {
  const _LanguageBottomSheet();

  @override
  State<_LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<_LanguageBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 24.h),
          Text(
            LocaleKeys.ChooseYourLanguage.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: Color(0xff1E1E1E),
            ),
          ),
          SizedBox(height: 24.h),
          _buildLanguageOption(
            flag: 'assets/svg/Egypt.svg', // Assuming this is the Arabic flag
            label: LocaleKeys.Arabic.tr(),
            isSelected: currentLocale.languageCode == 'ar',
            onTap: () {
              setState(() {
                context.setLocale(Locale('ar'));
              });
            },
          ),
          SizedBox(height: 12.h),
          _buildLanguageOption(
            flag: 'assets/svg/usa_flag.svg',
            label: LocaleKeys.English.tr(),
            isSelected: currentLocale.languageCode == 'en',
            onTap: () {
              setState(() {
                context.setLocale(Locale('en'));
              });
            },
          ),
          SizedBox(height: 32.h),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF3212D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                elevation: 0,
              ),
              child: Text(
                LocaleKeys.profile_select.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required String flag,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isSelected ? const Color(0xffF3212D) : const Color(0xffE9E9E9),
            width:isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Using SvgPicture to render the SVG flag image correctly
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: SvgPicture.asset(
                flag,
                width: 32.w,
                height: 24.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xff1E1E1E),
              ),
            ),
            const Spacer(),
            if (isSelected)
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: Color(0xffF3212D),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 14.sp,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

extension ProfileScreenExtensions on ProfileScreen {
  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: const Color(0xffF6F6F6),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: const Color(0xff8A8A8A), size: 22),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1E1E1E),
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Color(0xff8A8A8A),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Color(0xff1E1E1E), size: 16),
          ],
        ),
      ),
    );
  }
}
