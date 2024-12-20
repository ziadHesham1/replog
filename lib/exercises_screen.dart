import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:replog/main.dart';
import 'exercise_model.dart'; // Import your ExerciseModel

class ExercisesScreen extends StatefulWidget {
  final String bodyPart;

  const ExercisesScreen({super.key, required this.bodyPart});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  Set<String> targets = {};
  static const int _pageSize = 10;

  final PagingController<int, ExerciseModel> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      fetchExercises(pageKey);
    });
  }

  Future<void> fetchExercises(int pageKey) async {
    final String apiUrl =
        'https://exercisedb.p.rapidapi.com/exercises/bodyPart/${widget.bodyPart}?limit=$_pageSize&offset=${(pageKey - 1) * _pageSize}&sortby=target';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': 'rapidApiKey', // Replace with your RapidAPI key
      'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // Deserialize JSON into a list of ExerciseModel objects
        final List<ExerciseModel> newExercises =
            jsonList.map((json) => ExerciseModel.fromJson(json)).toList();

        // Extract unique target muscle groups
        targets = newExercises.map((exercise) => exercise.target).toSet();

        final isLastPage = newExercises.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newExercises);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newExercises, nextPageKey);
        }
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (error) {
      _pagingController.error = error;
      print('Error fetching exercises: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.bodyPart} Exercises'),
      ),
      body: PagedGridView<int, ExerciseModel>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<ExerciseModel>(
          itemBuilder: (context, exercise, index) {
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: exercise.gifUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(exercise.name),
                  Text(
                    'Target: ${exercise.target}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Target: ${exercise.equipment}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
