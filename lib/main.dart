import 'package:crud_application/models/contact.dart';
import 'package:crud_application/utils/database_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Contact',
      theme: ThemeData(
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'My Contact'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  Contact _contact = Contact();
  List <Contact> _contactLists = [];
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();
  final _ctrlPhone = TextEditingController();
  @override
  void initState(){
    super.initState();
    setState((){
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshContactLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(widget.title,
          style: TextStyle(color: Colors.green),)
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _form(), _list()
          ],
        ),
      ),
    );
  }
  _form()=>Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(vertical:15, horizontal:30),
    child: Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _ctrlName,
            decoration: InputDecoration(
              labelText: 'Full Name'
            ),
            onSaved: (val) => setState(()=>_contact.name = val),
            validator: (val) => (val.length==0 ? 'This field is required ':null),
          ),
          TextFormField(
            controller: _ctrlPhone,
            decoration: InputDecoration(
              labelText: 'Phone'
            ),
            onSaved: (val) => setState(()=>_contact.phone = val),
            validator: (val) => (val.length<10 ? 'At leat 10 digits':null),
          ), 
          Container(
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
            onPressed:() => _onSubmit(),
            child: Text('Submit'),
            color: Colors.green,
            textColor: Colors.white,)
          )
        ]
      ),
    ),
  );
  _list()=> Expanded(
    child: Card(
      margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemBuilder: (context, index){
          return Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.green,
                  size:40.0 
                ),          
                title: Text(
                  _contactLists[index].name.toUpperCase(),
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _contactLists[index].phone.toUpperCase(),
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),  
                ),      
                onTap: (){
                  setState(() {
                    _contact = _contactLists[index];
                    _ctrlName.text = _contactLists[index].name;
                    _ctrlPhone.text = _contactLists[index].phone;
                  });
                }
              ),
              Divider(
                height:0.5
              )
            ],
          );
        },
        itemCount: _contactLists.length,
      )
    )
  );

  _refreshContactLists() async{
    List<Contact> x = await _dbHelper.fetchContacts();
    setState(() {
      _contactLists = x;
    });
  }

  _onSubmit() async{
    var form = _formKey.currentState;
    if(form.validate()){
      if(_contact.id==null) await _dbHelper.insertContact(_contact);
      else await _dbHelper.updateContact(_contact);
      await _dbHelper.insertContact(_contact);
      _refreshContactLists();
      _resetForm();
    }
  }
  
  _resetForm(){
    setState(() {
      _formKey.currentState.reset();
      _ctrlName.clear();
      _ctrlPhone.clear();
      _contact.id=null;
    });
  }
}
