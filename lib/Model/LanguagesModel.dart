class LanguagesModel{

  int iD ;
  String name;

  LanguagesModel({this.iD,this.name});

  factory LanguagesModel.fromMap(object){
    return LanguagesModel(
      iD: object['id'],
      name: object['name']
    );
  }

}