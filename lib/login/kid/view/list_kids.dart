import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jueguito2/login/kid/view/add_kid.dart';

import '../../../other screens/splash_screen.dart';
import '../../login/cubit/auth_cubit.dart';
import '../../login/cubit/my_user_cubit.dart';
import '../../login/model/user.dart';
import '../../login/provider/my_user_repository.dart';
import 'estadisticas.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static Widget create(BuildContext context) {
    return const MainScreen();
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyUserCubit(MyUserRepository())..getMyUser(),
      child: BlocBuilder<MyUserCubit, MyUserState>(builder: (_, state) {
        if (state is MyUserReadyState) {
          MyUser me = state.user;
          return ListKids(me);
        }
        return const SplashScreen();
      }),
    );
  }
}

// ignore: must_be_immutable
class ListKids extends StatefulWidget {
  MyUser me;
  ListKids(this.me, {Key? key}) : super(key: key);

  @override
  State<ListKids> createState() => _ListKidsState();
}

class _ListKidsState extends State<ListKids> {
  Widget bottonKid(String name, String id) {
    // Map<String, dynamic> kidData = {};
    // getKid(id).then((value) => kidData = value);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () {}, child: Text(name)),
          const SizedBox(width: 10),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FlBarChartExample(widget.me.id, id, name)));
              },
              child: const Icon(Icons.list)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola ${widget.me.name}'),
        actions: [
          IconButton(
              onPressed: () {
                context.read<MyUserCubit>().getMyUser();
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddKid()));
                },
                child: const Text('Agregar nuevo niño')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Tienes ${widget.me.kids?.length} niños en tu lista'),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              for (var i = 0; i < widget.me.kids!.length; i++)
                bottonKid(widget.me.kids![i]['name'], widget.me.kids![i]['id']),
            ],
          ),
        ],
      ),
    );
  }
}
