import 'package:ecommerce_app/constants.dart';
import 'package:ecommerce_app/widgets/custom_btn.dart';
import 'package:ecommerce_app/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

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

  //create a new user account
  Future<String> _createAccount() async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail,
          password: _registerPassword
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
      _registerFormLoading=true;
    });

    //run the create account method
    String _createAccountFeedback=await  _createAccount();

// if the string is not null ,we got error while create account
    if(_createAccountFeedback!=null){
      _alertDialogBuilder(_createAccountFeedback);

      //set the form to regular state[not loading]
      setState(() {
        _registerFormLoading=false;
      });
    } else{
      //user is logged in
      Navigator.pop(context);
    }
  }

  //Default form loading state
  bool _registerFormLoading =false;

  //form input field values
  String _registerEmail="";
  String _registerPassword="";

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
                  child: Text("Create a new account",
                    textAlign: TextAlign.center,
                    style: Constants.boldHeading,
                  ),
                ),
                Column(
                  children:[
                    CustomInput(
                      hinText: "Email...",
                      onChanged: (value){
                        _registerEmail=value;
                      },
                      onSubmitted: (value){
                        _passwordFocusNode.requestFocus();

                      },
                      textInputAction: TextInputAction.next,
                    ),
                    CustomInput(
                      hinText:"Password...",
                      onChanged: (value){
                        _registerPassword=value;

                      },

                      focusNode: _passwordFocusNode,
                      isPasswordField: true,
                      onSubmitted: (value){
                        _submitForm();
                      },
                    ),
                    CustomButton(
                      text: "Signup",
                      onPressed: (){
                        //open the alert dialog button
                        //_alertDialogBuilder();
//                   setState(() {
//                     _registerFormLoading=true;
// });
                      _submitForm();

                      },
                      isLoading: _registerFormLoading,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0
                  ),
                  child: CustomButton(
                    text: "Back to Login",
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    outlineBtn: true,
                  ),
                ),
              ],
            ),
          ),
        )
    );;
  }
}
