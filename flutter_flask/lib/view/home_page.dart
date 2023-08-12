import 'package:flutter/material.dart';
import 'package:flutter_flask/models/user.dart';
import 'package:flutter_flask/services/userAPI.dart';
import 'package:flutter_flask/view/addUserForm.dart';
import 'package:flutter_flask/view/updateUserForm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<User>? users;
  var isLoaded = false;

  @override
  void initState(){
    super.initState();
    getRecord();
  }

  getRecord() async{
    users=await UserApi().getAllUser();
    if(users != null){
      setState(() {
        isLoaded = true;
      });
    }
  }

Future<void> showMessageDialog(String title,String msg) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(
              msg,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Python RestAPI FLutter"),),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(child: CircularProgressIndicator(),),
        child: ListView.builder(
        itemCount: users?.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(users![index].name),
            subtitle: Text(users![index].contact),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: ()async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> updateUserForm(users![index]))
                      ).then((data){
                        if (data != null) {
                          showMessageDialog("Success","$data Detail Updated Success.");
                          getRecord();
                        }
                      });
                }, icon: const Icon(Icons.edit, color: Colors.blue),),
                IconButton(onPressed: () async{
                  User user=await UserApi().deleteUSer(users![index].id);
                  showMessageDialog("Success", "$user Detail Deleted Success");
                  getRecord();
                }, icon: const Icon(Icons.delete, color: Colors.red,),),
              ],
            ),
            );
        }),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context)=> const addUserForm())
              ).then((data){
            if (data != null) {
              showMessageDialog("Success","$data Detail Added Success.");
              getRecord();
            }
          });
          },
          child: const Icon(Icons.add),
          ),
    );
  }
}