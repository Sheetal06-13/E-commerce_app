
import 'package:ecommerce_app/constants.dart';
import 'package:ecommerce_app/screens/register.dart';
import 'package:ecommerce_app/widgets/custom_btn.dart';
import 'package:ecommerce_app/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //build an error dialog to display some error
  Future<void> _alertDialogBuilder(String error) async{

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title:Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: <Widget>[
              FlatButton(child: Text("Close dialog"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  //user login
  Future<String> _loginAccount() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail,
          password: _loginPassword
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  //
  void _submitForm() async{

//Set the form to loading state
    setState(() {
      _loginFormLoading=true;
    });

    //run the create account method
    String _loginFeedback=await  _loginAccount();

// if the string is not null ,we got error while create account
    if(_loginFeedback!=null){
      _alertDialogBuilder(_loginFeedback);

      //set the form to regular state[not loading]
      setState(() {
        _loginFormLoading=false;
      });
    }
  }

  //Default form loading state
  bool _loginFormLoading =false;

  //form input field values
  String _loginEmail="";
  String _loginPassword="";

  FocusNode _passwordFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    _passwordFocusNode=FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text("Welcome User,\nLogin to your account",
              textAlign: TextAlign.center,
                style: Constants.boldHeading,
              ),
            ),
            Column(
              children:[
                CustomInput(
                  hinText: "Email...",
                  onChanged: (value){
                    _loginEmail=value;
                  },
                  onSubmitted: (value){
                    _passwordFocusNode.requestFocus();

                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  hinText:"Password...",
                  onChanged: (value){
                    _loginPassword=value;

                  },

                  focusNode: _passwordFocusNode,
                  isPasswordField: true,
                  onSubmitted: (value){
                    _submitForm();
                  },
                ),
                CustomButton(
                  text: "Login",
                  onPressed: (){
                    //open the alert dialog button
                    //_alertDialogBuilder();
//                   setState(() {
//                     _registerFormLoading=true;
// });
                    _submitForm();

                  },
                  isLoading: _loginFormLoading,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0
              ),
              child: CustomButton(
                text: "Create New Account",
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage())
                  );
                },
                outlineBtn: true,
              ),
            ),
          ],
          ),
        ),
      )
    );
  }
}
