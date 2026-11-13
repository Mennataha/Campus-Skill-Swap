import 'package:flutter/material.dart';
import 'package:skillswap/core/theme/app_colors.dart';
import 'package:skillswap/core/theme/app_text_styles.dart';
import 'package:skillswap/core/widgets/custom_button.dart';
import 'package:skillswap/core/widgets/custom_text_field.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked=false;
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
               SizedBox(height: 25,),
               Card(
                 child:Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: Column(
                     spacing: 16,
                     children: [
                       CustomTextField(label: 'Email', hint: 'example123@gmail.com',prefixIcon: Icon(Icons.email,color: AppColors.primaryDark,),keyboardType: TextInputType.emailAddress,),
                       CustomTextField(label: 'Password', hint: 'Secret_pass45',prefixIcon: Icon(Icons.lock_outline_rounded,color: AppColors.primaryDark,),obscureText: true,suffixIcon: IconButton(onPressed: (){}, icon:Icon(Icons.password) ),),

                       Row(
                         children: [
                           Checkbox(value: isChecked,
                               onChanged: (bool? newValue){setState(() {
                             isChecked= newValue!;
                           });}),
                           Text('Remember me',style: AppTextStyles.bodyMedium,)
                         ],
                       ),
                       CustomButton(label: 'Log In', onPressed: (){} , variant:CustomButtonVariant.primary ,trailingIcon: Icons.arrow_forward,),
                       Row(
                         spacing: 12,
                         children: [
                           Expanded(child: Divider(color: AppColors.border,thickness: 1,)),
                           Text('or continue with',style: AppTextStyles.bodySmall,),
                           Expanded(child: Divider(color: AppColors.border,thickness: 1,)),
                         ],
                       ),
                       CustomButton(label:'Google', onPressed: (){},variant: CustomButtonVariant.secondary,)
                     ],
                   ),
                 )
               ),
               SizedBox(height: 80,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New here?',style: AppTextStyles.bodyMedium,),
                  TextButton(onPressed: (){}, child: Text('Sign up',style: TextStyle(fontSize: 16,color:AppColors.primary,fontWeight: FontWeight.bold,)))
                ],
              )
             ],
           ),
         ),
       ),
    );
  }
}
