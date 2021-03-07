class Contact{
  static const tblContact = 'contacts';
  static const colId = 'id';
  static const colName = 'name';
  static const colPhone = 'phone';

  int id;
  String name;
  String phone;

  Contact.fromMap(Map<String, dynamic> map){
    id = map[colId];
    name = map[colName];
    phone = map[colPhone];
  }

  Contact({this.id, this.name, this.phone});

  Map<String, dynamic> toMap(){
    var map = <String, dynamic> {colName: name, colPhone: phone};
    if(id!=null)map[colId] = id;
    return map;
  }
}
