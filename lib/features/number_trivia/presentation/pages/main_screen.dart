import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/controllers/controller.dart';
import 'package:flutter_clean_architecture/injection_container.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: GetBuilder<Controller>(
        init: di<Controller>(),
        builder: (_) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: GetBuilder<Controller>(
                        id: 'loading',
                        builder: (l) {
                          if (l.isLoading)
                            return Center(
                              child: CircularProgressIndicator(),
                            );

                          return Center(
                            child: GetBuilder<Controller>(
                                id: 'message',
                                builder: (m) {
                                  return Text(
                                    m.message,
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  );
                                }),
                          );
                        }),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      TextField(),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text('btn'),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _.getRandomNumber,
                              child: Text('Random'),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
