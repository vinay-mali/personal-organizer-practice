import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Organiser',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  static const String KEYNAME = "tasks";
  TextEditingController task = TextEditingController();
  List<String> tasks = [];
  @override
  void dispose() {
    task.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

   return GestureDetector(
     onTap: (){FocusScope.of(context).unfocus();},
     child: Scaffold(
       appBar: AppBar(
         title: Center(child: Text("Personal Organizer",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 27),)),
         backgroundColor: Colors.deepPurple,
       ),
       body: Column(
         children: [
           Padding(
             padding: const EdgeInsets.only(top: 5,left: 260),
             child: OutlinedButton(onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => AboutMe()));
             }, child: Text("About",style: TextStyle(fontWeight: FontWeight.bold),),style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.deepPurple,width: 2),),)),
           Padding(
             padding: const EdgeInsets.only(left: 35,right: 35,top: 20,bottom: 25),
             child: TextField(
               controller: task,
               decoration: InputDecoration(
                 hintText: "Add Task",
                 enabledBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(8),
                   borderSide: BorderSide(
                     color: Colors.deepPurple, width: 2
                   ),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(8),
                   borderSide: BorderSide(color: Colors.purpleAccent,width: 2.5
               ),
             ),
           ),)
           ),
           ElevatedButton(onPressed: (){
             String utask = task.text.trim();
             if(utask.isEmpty){
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Task")));
               return;}
             bool exixts = false;
             for(int i=0;i<tasks.length;i++){
               if(tasks[i].toLowerCase()==utask.toLowerCase()){
                 exixts = true;
                 break;
               }
             }
             if(exixts){
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task Already Exists")));
               return;
             }
             tasks.add(utask);
             task.clear();
             setState(() {

             });
             saveProducts();

           }, child: Text("Add Task",style: TextStyle(color: Colors.white,fontSize: 20),),style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple)),
           Expanded(child: ListView.separated(itemBuilder: (context, index) {
             return ListTile(
               title: Text("${index+1}.  ${tasks[index]}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
                 trailing: IconButton(onPressed: (){tasks.removeAt(index); setState(() {
                 }); saveProducts();}, icon: Icon(Icons.delete,color: Colors.red,)),
             );}, separatorBuilder: (context, index) => Divider(thickness: 2,), itemCount: tasks.length)),

         ],
       )
     ),
   );
  }
  Future<void> loadProducts()async{
    final prefs = await SharedPreferences.getInstance();
    List<String> savedTasks = prefs.getStringList(KEYNAME)??[];
    setState(() {
      tasks = savedTasks;
    });
  }
  Future<void> saveProducts()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(KEYNAME, tasks);
  }

}
class AboutMe extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 27),),
        backgroundColor: Colors.deepPurple,),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Hello Everyone!\nThis app is created by Vinay Mali.",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("The app is made for Personal organising, it can be used to make quick lists and remember till you manually delete it. It can be used anywhere anytime. The app is totally offline and safe. Keep using and have a nice day.",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Back",style: TextStyle(fontSize: 20),)),
          )
        ],
      ),
    );
  }

}




