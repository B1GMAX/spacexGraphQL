import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bloc.dart';
import 'information.dart';

class Screen extends StatelessWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<Bloc>(
      create: (context) => Bloc(),
      dispose: (context, bloc) => bloc.dispose(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('SpaceX'),
          ),
          body: StreamBuilder<List<Information>>(
              initialData: [],
              stream: context.read<Bloc>().stream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 70.0, left: 16.0, right: 16.0, bottom: 16.0),
                      child: TextField(
                        controller: context.read<Bloc>().textEditingController,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data![index].missionName),
                            subtitle: Text(snapshot.data![index].details),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
        );
      },
    );
  }
}
