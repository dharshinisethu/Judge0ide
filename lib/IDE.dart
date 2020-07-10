import 'package:flutter/material.dart';
import 'package:judge0_IDE/API/APIHandler.dart';
import 'package:judge0_IDE/Model/LanguagesModel.dart';
import 'package:judge0_IDE/Model/OutputModel.dart';

class IDE extends StatefulWidget {
  @override
  _IDEState createState() => _IDEState();
}

class _IDEState extends State<IDE> {


  bool isLoading = true, hasOutputError = false;
  List<LanguagesModel> languages ;
  LanguagesModel selectedLanguage;
  String output = '';


  TextEditingController codeAreaController = TextEditingController();

  @override
  void initState() {

     APIHandler.getLanguages().then((data){

      languages = data;

      selectedLanguage = languages[0];

       setState(() {
         isLoading = false;
       });

     });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('judge0 IDE',style: TextStyle(color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: !isLoading ?
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: chooseLanguage(),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(children: [Icon(Icons.send,color: Colors.white,),Text('  RUN',style: TextStyle(color: Colors.white),)],),
                    ),
                    onPressed: ()async{
                      setState(() {
                        isLoading = true;
                      });
                      String token = await APIHandler.createSubmission(codeAreaController.text, selectedLanguage.iD);
                      print(' Token : $token');
                      var codeOutput = await APIHandler.getSubmission(token);

                      print(codeOutput);
                      setState(() {
                        isLoading = false;
                        StringBuffer outputBuffer = StringBuffer();
                        if(codeOutput.compileOutput !=null || codeOutput.stderr!=null){
                          hasOutputError = true;
                          if(codeOutput.compileOutput !=null){
                            outputBuffer.write('Compiler output : \n');
                            outputBuffer.write(codeOutput.compileOutput);
                            outputBuffer.write('\n');
                          }else{
                            outputBuffer.write('error : ');
                            outputBuffer.write('\n');
                            outputBuffer.write(codeOutput.stderr);

                            output = outputBuffer.toString();
                          }

                        }else{
                          hasOutputError = false;
                          outputBuffer.write(codeOutput.stdout);
                          output = outputBuffer.toString();
                        }
                      });
                    },
                  ),

                ],
              ),

              SizedBox(height: 30,),
             Row(
               children: [
                 Expanded(child: codeArea()),
                 Expanded(child: outPutArea())
               ],
             )
            ],
          ) : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget chooseLanguage(){

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Choose language :  ',style: TextStyle(fontSize: 18),),
        DropdownButton<LanguagesModel>(
          value: selectedLanguage,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.blue),
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          onChanged: (value) {
            setState(() {
              selectedLanguage = value;
            });
          },
          items: languages
              .map<DropdownMenuItem<LanguagesModel>>((LanguagesModel value) {
            return DropdownMenuItem<LanguagesModel>(
              value: value,
              child: Text(value.name),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget codeArea(){

    return Theme(
      data: new ThemeData(
        primaryColor: Colors.black,
        primaryColorDark: Colors.black,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left:8.0,right:8.0,top: 10),
          child: Container(
            height: MediaQuery.of(context).size.height/1.3,
            child: TextField(
              controller: codeAreaController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown)
                  ),
                  labelText: 'Code here',
              ),
            ),
          ),
        ),
      ),
    );

  }

  Widget outPutArea(){

    return Container(
      height: MediaQuery.of(context).size.height/1.3,
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[700])
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(' OutPut : \n \n $output',style: TextStyle(color: hasOutputError?Colors.red:Colors.black),),
        ),
      ),
    );

  }

}