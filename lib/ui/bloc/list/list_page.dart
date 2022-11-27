import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/list/list_bloc.dart';
import 'package:get_it/get_it.dart';

import '../tokenManager/TokenManager.dart';

class ListPageBloc extends StatefulWidget {
  const ListPageBloc({super.key});

  @override
  State<ListPageBloc> createState() => _ListPageBlocState();
}

class _ListPageBlocState extends State<ListPageBloc> {
  var dio = GetIt.I<Dio>();
  var tokenMngr = GetIt.I<TokeManager>();

  @override
  void initState() {
    final loginBloc = context.read<ListBloc>();
    loginBloc.add(ListLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.key),
              onPressed: () async {
                dio.options.headers["Authorization"] = "";
                Navigator.pushReplacementNamed(context, "/");
                await tokenMngr.clearSaved();
              },
            ),
            const Text("Users",)
          ],
        ),
      ),
      body: buildWithScaffold(context),
    );
  }

  Widget buildWithScaffold(BuildContext context) {
    return BlocConsumer<ListBloc, ListState>(
        listener: (context, state) {
          if (state is ListError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
        },
        builder: (ctx, state) {
          if (state is ListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ListLoaded) {
            return list(ctx, state);
          }
          return Container();
        }
    );
  }

  Widget list(BuildContext context, ListLoaded state) {
    var media = MediaQuery.of(context);

    // for performance
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (BuildContext context, int index) => Center(
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: state.users[index].avatarUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 50,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                state.users[index].name,
                style: const TextStyle(fontSize: 30),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      itemCount: state.users.length,
    );
  }
}
