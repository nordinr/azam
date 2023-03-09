
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


Future<String> checkingConnection() async
{
  var statusReturn="";
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      statusReturn ="1";
      return statusReturn;
    }
  } on SocketException catch (_) {
    statusReturn ="0";
    return statusReturn;

  }
  return statusReturn;

}


dioHttpPostRequest(context,dataPost,action,loading,title,desc) async {
  print("masuk 1");
  var connection = await checkingConnection();
  if(connection=="1"){
    if(loading==1){
      screenLoadingx(context,title,desc,false,false,true);
    }
    dataPost.addAll({"apps_ver": apps_ver});

    if(action!="loginldap") {
      var tAccess = await getLocalMemory("sessiontAccess");
      var tRefresh = await getLocalMemory("sessiontRefresh");
      dataPost.addAll({"tAccess": tAccess});
      dataPost.addAll({"tRefresh": tRefresh});
    }
    // var bearerToken="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcGkudW10LmVkeS5teVwvZnVzaW9cL3B1YmxpYyIsInN1YiI6IjBiYTBjYTU3LTRjY2MtNTMwMi05NzdjLWMxZmNmNGNmMWVjNiIsImlhdCI6MTU5ODE1NTM3OCwiZXhwIjo0NzIyMjA2NTc4LCJuYW1lIjoiYnBhX21vYmlsZSJ9.moUazkrbuByTbAkc6UJMsIXDWM0AvP0jbJtoftPWvlk";
    const bearerToken= 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8xOTIuMTY4LjIwLjE5M1wvZnVzaW9cL3B1YmxpYyIsInN1YiI6IjdkM2YzZGQzLTVhODMtNTY5MC05ZGQ0LTRkM2Q2NGMzYjZmMiIsImlhdCI6MTYxNjU1ODIzOSwiZXhwIjo0NzQwNjk1ODM5LCJuYW1lIjoibW9ic3RhZiJ9.L9sDO6qBLdh2ejQu6OCA7SspZiyWIrMFDX0-mqJgnEk'; //dev

    BaseOptions options = new BaseOptions(
      connectTimeout: 30000,//5000,
      receiveTimeout: 30000,//3000,
    );
    Dio dio = new Dio(options);
    dio.options.headers["Authorization"] = "Bearer $bearerToken";
    try {
      print("masuk 2");
      print("$mainUrl$action");
      Response res = await dio.post(mainUrl+action, data:FormData.fromMap(dataPost),) ;
      print("masuk 3");
      var rawData = json.decode(res.toString());
      print(rawData);
      if(rawData['mesejlog']=="INVALIDVERSION"){
        print("masuk 4");
        screenLoadingx(context,"Error Message",rawData['mesejayat'].toString(),true,true,false);

        localMemoryData("string","matrik", "null");
        Navigator.of(context, rootNavigator: true).pop();
        if(action!="loginldap"){
          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => Signin()), (r) => false);
        }


      }
      else{
        print("masuk 5");
        if(action=="loginldap" && rawData['status']==true) {
          await localMemoryData("string","sessiontAccess", rawData['tAccess']);
          await localMemoryData("string","sessiontRefresh", rawData['tRefresh']);

          print("masuk 6");
        }else{
          print("masuk 6.0");
          if(rawData['mesejlog']!="INVALIDVERSION" && rawData['mesejlog']!="INVALIDLOGIN") {
            localMemoryData("string","sessiontAccess", rawData['tAccess']);
          }
        }


      }
      if(loading==1){
        Navigator.of(context, rootNavigator: true).pop();
      }
      rawData.addAll({"errorhandle": true});
      print("masuk 6.1");
      return rawData;


    }on DioError catch (e){
      var errorMessage = DioExceptions.fromDioError(e).toString();
      print("xxxxxxxxxxxxx");
      print(errorMessage);
      print(e.response);
      print("xxxxxxxxxxxxx");
      // var errorMessage = DioExceptions.fromDioError(e);

      if(loading==1){
        Navigator.of(context, rootNavigator: true).pop();
      }
      screenLoadingx(context,"Error Message",errorMessage.toString(),true,true,false);
      return "errorException";
    }



  }else{
    screenLoadingx(context,"Error Message","No internet connection".toString(),true,true,false);
    return "errorException";
  }






}


Future<void> screenLoadingx(BuildContext context,title,desc,bool isclose,bool overlay,bool spin) async {
  Alert(
      context: context,

      content: Padding(padding: EdgeInsets.only(top:0),
        child: spin==true ?
        Column(
          children: [
            Image.asset(
              "assets/umt2.gif",
              height: 200.0,
              width: 200.0,
            ),
            Text(title,style:TextStyle(fontFamily: 'raleway', fontWeight: FontWeight.bold)),
            Text(desc,style:TextStyle(fontFamily: 'raleway', fontSize: 15.0)),
          ],
        )

            :Text("~~"),
      ),
      style: AlertStyle(
          isCloseButton: isclose,
          isOverlayTapDismiss: overlay,
          titleStyle: TextStyle(fontFamily: 'raleway', fontWeight: FontWeight.bold),
          descStyle: TextStyle(fontFamily: 'raleway', fontSize: 15.0),
          alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))
      ),
      buttons: []
  ).show();

}
