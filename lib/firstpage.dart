import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class firstPage extends StatefulWidget {


  final String param1;
  firstPage({Key? key, required this.param1}) : super(key: key);

  @override
  _firstPageState createState() => _firstPageState();
}


class _firstPageState extends State<firstPage> {
  var paramTextController =  TextEditingController();
  var newupdatedataController =  TextEditingController();

  List listData=[];


  getData()async{
    Dio dio = new Dio();
    Response Data = await dio.post('http://192.168.23.71/mobiletest/listrekod', data: {'anydata':""});

print(Data.toString());

    setState(() {
      var rawData =  json.decode(Data.toString());
      listData=rawData["data"];
    });
    print(listData);


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }


  Future bottomAttachment(idolddata,paramolddatda){
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 30,),
              Center(
                child: Text("Update data. old data : ${paramolddatda} "),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                child:

                TextField(

                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Data',
                    labelText: 'Data',
                  ),
                  controller:  newupdatedataController,
                ),
              ),
              SizedBox(height: 30,),
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.90,
                onPressed: (){
                  if(newupdatedataController.text!="")
                  {


                  }
                  else{

                    AlertDialog alert = AlertDialog(
                      title: Text("Warning"),
                      content: Text("Sila masukkan data"),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );

                    // show the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );

                  }
                },
                textColor: Colors.white,
                color:Colors.blue,
                padding: const EdgeInsets.all(2.0),
                child: const Text(
                  "Update Data",
                ),
              ),
              SizedBox(height: 30,),

            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //backgroundColor: Colors.transparent,
      body:
      Stack(
        children: [

          Container(

              decoration:  BoxDecoration(
                /* image:  DecorationImage(image: AssetImage("assets/waves3.png"),
                    fit: BoxFit.fitHeight,
                    colorFilter:  ColorFilter.mode(appBgColor.withOpacity(1), BlendMode.dstATop),
                  ),*/
                  color: Colors.white38,//Color(0xffeeeee4),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0))),
              child:  CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.red,//appBarColor,
                    pinned: true,
                    snap: true,
                    floating: true,
                    title:Text("first page"),
                  ),

                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                          Column(
                            children: [
                              Center(
                                child: Text(widget.param1,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 45),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                               // padding: EdgeInsets.symmetric(horizontal: 105),
                                child: TextField(
                                  keyboardType:  TextInputType.text,
                                  maxLines: 1,
                                  controller: paramTextController ,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'value1',
                                      hintText: 'value1'),
                                ),
                              ),
                              MaterialButton(
                                minWidth: MediaQuery.of(context).size.width/2,
                                color: Colors.blue,
                                child: Text("submit data"),
                                  onPressed:()async{
                                    Dio dio = new Dio();
                                    var response = await dio.post('http://192.168.23.71/mobiletest/addrekod', data: {'nokp':paramTextController.text,'nama': widget.param1});

                                    //showAlertDialog(BuildContext context) {



                                      // set up the AlertDialog
                                      AlertDialog alert = AlertDialog(
                                        title: Text("Info"),
                                        content: Text("Successfull add new record"),
                                        actions: [
                                          TextButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );

                                      // show the dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                   // }


                                  print("===============");
                                  print(response.toString());
                                  print("===============");



                              }),
                              Divider(),
                              listData.length>0 ?
                              Container(
                                height: 500,
                                child: ListView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(bottom: 40,top: 10,left: 10,right: 10),
                                    shrinkWrap: true,
                                    children: List.generate(listData.length,
                                            (index){
                                      return /*Row(
                                        children: [
                                          Conta
                                        ],
                                      );*/

                                        ListTile(
                                        title: Text("${listData[index]['ID_UMT']}"),
                                            leading: Text("${listData[index]['NAMA']}",style: TextStyle(fontSize: 12),), // for Right
                                            trailing: Icon(Icons.edit),
                                          onTap: (){
                                            bottomAttachment(listData[index]['ID'],listData[index]['NAMA']);
                                          },

                                        );



                                        }
                                    )
                                )
                              ):
                                  Container()


                            ],
                          ),

                      childCount: 1,
                    ),
                  )
                ],
              )
          ),


        ],
      ),
    );
  }



}