import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:replog/exercises_screen.dart';
import 'package:replog/main.dart';

class MuscleGridScreen extends StatefulWidget {
  const MuscleGridScreen({super.key});

  @override
  State<MuscleGridScreen> createState() => _MuscleGridScreenState();
}

class _MuscleGridScreenState extends State<MuscleGridScreen> {
  List<String> _muscles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMuscles();
  }

  Future<void> fetchMuscles() async {
    const String apiUrl =
        'https://exercisedb.p.rapidapi.com/exercises/bodyPartList?limit=100';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': 'rapidApiKey',
      'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          _muscles = List<String>.from(json.decode(response.body));
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load muscles');
      }
    } catch (error) {
      print('Error fetching muscles: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muscle Groups'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _muscles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExercisesScreen(bodyPart: _muscles[index]),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      child: Center(
                        child: Text(
                          _muscles[index].toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
