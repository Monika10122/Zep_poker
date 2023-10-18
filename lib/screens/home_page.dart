import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/logic/auth.dart';
import '/screens/madjong.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
  title: const Text('Madjong'),
  actions: <Widget>[
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<User?>(
        stream: Auth().authStateChanges,
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user != null) {
              return Row(
                children: [
                  Text(
                    user.isAnonymous ? 'Anonymus' : user.email ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white70
                            ),
                          ),
                    onPressed: () {
                      Auth().signOut();
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              );
            } else {
              return const Text(
                'Anonymus',
                style: TextStyle(fontSize: 14),
              );
            }
          }
          return const SizedBox();
        },
      ),
    ),
  ],
),

      body: ZepPokerGame() ,
    );
  }
}
