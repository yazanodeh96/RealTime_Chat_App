import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/services/api_service.dart';
import 'package:chatapp/view/chat_screen.dart';
import 'package:chatapp/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/providers/chat_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 171, 71, 189),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Color.fromARGB(255, 235, 188, 184),
            onPressed: () async {
              final authController = AuthController(ApiService());
              await authController.logout();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
      body: chatProvider.users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chatProvider.users.length,
              itemBuilder: (context, index) {
                final user = chatProvider.users[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        (user.firstName?.isNotEmpty == true
                            ? user.firstName![0]
                            : '?'),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title:
                        Text('${user.firstName ?? ''} ${user.lastName ?? ''}'),
                    subtitle: Text(user.email ?? ''),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider.value(
                                      value: Provider.of<ChatProvider>(context),
                                      child: ChatScreen(user: user))));
                    },
                  ),
                );
              },
            ),
    );
  }
}



// import 'package:chatapp/controller/auth_controller.dart';
// // import 'package:chatapp/controller/chat_controller.dart';
// // import 'package:chatapp/model/user.dart';
// import 'package:chatapp/services/api_service.dart';
// import 'package:chatapp/view/chat_screen.dart';
// import 'package:chatapp/view/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/user_provider.dart';
// import '../providers/chat_provider.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Home Page',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 171, 71, 189),
//         elevation: 10.0,
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.logout,
//               color: Color.fromARGB(255, 235, 188, 184),
//             ),
//             onPressed: () async {
              // final authController = AuthController(ApiService());
              // await authController.logout();
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => LoginScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Consumer<UserProvider>(
//         builder: (context, userProvider, child) {
//           // print( userProvider.users);
//           if (userProvider.users.isEmpty) {
//             return Center(child: CircularProgressIndicator());
//           } else if (userProvider.hasError) {
//             return Center(child: Text('Error: ${userProvider.errorMessage}'));
//           } else if (userProvider.users.isEmpty) {
//             return Center(child: Text('No users found'));
//           } else {
//             final users = userProvider.users;
//             return ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 final user = users[index];
//                 return ListTile(
//                   title: Text('${user.firstName} ${user.lastName}'),
//                   subtitle: Text(user.email),
//                   onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ChangeNotifierProvider.value(
                    //       value: Provider.of<ChatProvider>(context),
                    //       child: ChatScreen(user: user),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Provider.of<UserProvider>(context, listen: false).fetchUsers();
//         },
//         child: Icon(Icons.refresh),
//       ),
//     );
//   }
// }



