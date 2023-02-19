import 'dart:convert';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, dynamic>> fetchRandomJoke() async {
    final response = await http
        .get(Uri.parse('https://official-joke-api.appspot.com/random_joke'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch random joke');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Joke'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchRandomJoke(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              final joke = snapshot.data;
              final setup = joke!['setup'];
              final punchline = joke['punchline'];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlipCard(
                    flipOnTouch: true,
                    direction: FlipDirection.HORIZONTAL,
                    front: Card(
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          children: [
                            const Text(
                              'Joke',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '$setup',
                              style: const TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                    back: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              const Text(
                                'Punch line',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '$punchline',
                                style: const TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          fetchRandomJoke();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'Get Random Joke',
                      ))
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
