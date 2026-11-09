import 'package:flutter/material.dart';
import 'package:skillswap/core/theme/app_colors.dart';
import 'package:skillswap/core/theme/app_text_styles.dart';
import 'package:skillswap/core/widgets/custom_text_field.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
         child: Padding(padding:EdgeInsets.symmetric(horizontal: 16),
           child: Column(
             children: [
               SizedBox(height: 80,
                 width: 80,
                 child: Card(
                   elevation: 4.0,
                     color: AppColors.surface,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(16),),
                   child:Image.asset('images/skill_link_logo.png'),
                 ),
               ),
               SizedBox(height: 22,),
               Text('Welcome back!',style:AppTextStyles.heading1),
               SizedBox(height:5,),
               Text('Log in to pick up where you left off',style:AppTextStyles.bodyMedium),
               Card(
                 child:CustomTextField(label: 'Email', hint: 'example123@gmail.com',suffixIcon: Icon(Icons.email,color: AppColors.primaryDark,),)
               )

             ],
           ),
         ),
       ),
    );
  }
}
