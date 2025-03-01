import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WELCOME!', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.school, color: Colors.white, size: 40),
                  SizedBox(height: 10),
                  Text(
                    'Flashcard App',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categories'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCategoryScreen()),
                  
                );
              },
            ),

             ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                  
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/bg.jpg'), 
                fit: BoxFit.fill, 
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter, 
            child: Padding(
              padding: EdgeInsets.only(bottom:90), 
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 60),
                  ElevatedButton.icon(
                    icon: Icon(Icons.play_arrow),
                    label: Text('Get Started'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE1BEE7),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCategoryScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ABOUT',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Stack(
        children: [
          
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/bg2.jpg'), 
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Flashcard App',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'This flashcard app is built using Flutter to provide a smooth and seamless learning experience. '
                          'It allows you to create, edit, and manage flashcards easily, helping you organize study materials in a way that suits your learning style. '
                          'With a built-in progress tracking feature, you’ll receive insights on your performance at the end of each session, making it easier to identify areas for improvement.',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.purple,
                child: Center(
                  child: Text(
                    '© 2025 Villarta & Raotraot. All rights reserved.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}





class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController categoryController = TextEditingController();
  List<String> categories = [];
  final List<String> boxImages = [
    'assets/img/cat1.jpg',
    'assets/img/cat2.jpg',
    'assets/img/cat3.jpg',
    'assets/img/cat4.jpg',
    'assets/img/cat5.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }
// nag-load sa listahan sa categories gikan sa SharedPreferences
  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final storedCategories = prefs.getStringList('categories') ?? [];
    setState(() {
      categories = storedCategories;
    });
  }
//nag-save sa current categories list sa SharedPreferences
  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categories', categories);
  }
//nagdugang ug bag-ong category sa categories list ug nagsave sa updated list sa SharedPreferences
  void _addCategory(String category) {
    setState(() {
      categories.add(category);
    });
    _saveCategories();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddQuestionScreen(category: category)),
    );
  }

//function para sa pag delete sa category
  void _deleteCategory(String category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Category'),
          content: Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  categories.remove(category);
                });
                _saveCategories();
                Navigator.pop(context);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CATEGORIES', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.school, color: Colors.white, size: 40),
                  SizedBox(height: 10),
                  Text(
                    'Flashcard App',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categories'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCategoryScreen()),
                );
              },
            ),
          ],
        ),
      ),
      
      // mga design sa body
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/bg2.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: categories.isEmpty
                ? Center(
                    child: Text(
                      "No categories added yet",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: const Color.fromARGB(110, 118, 3, 159)),
                    ),
                  )

                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 2.00,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      String category = categories[index];
                      String boxImage = boxImages[index % boxImages.length];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SeeQuestionsScreen(category: category)),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(boxImage),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 5),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    category.toUpperCase(),
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _deleteCategory(category),
                                child: Icon(Icons.delete, color: Colors.red, size: 25),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

      

     floatingActionButton: SizedBox(
      width: 80,  
      height: 80,
      child: FloatingActionButton(
      onPressed: () {
      TextEditingController categoryController = TextEditingController();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add New Category'),
                content: TextField(
                  controller: categoryController,
                  autofocus: true,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      Navigator.pop(context);
                      _addCategory(value.trim());
                    }
                  },
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                  TextButton(
                    onPressed: () {
                      if (categoryController.text.trim().isNotEmpty) {
                        Navigator.pop(context);
                        _addCategory(categoryController.text.trim());
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
      Icons.add,
      size: 40,
      ),
      backgroundColor: const Color.fromARGB(255, 173, 34, 168),
        )
      )
    );
  }
}


class AddQuestionScreen extends StatefulWidget {
  final String category;
  AddQuestionScreen({required this.category});

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionsControllers = List.generate(4, (index) => TextEditingController());
  final TextEditingController answerController = TextEditingController();
  List<Map<String, dynamic>> questionsList = []; 

  @override
  void initState() {
    super.initState();
    _loadQuestions(); 
  }

  // Load questions from shared preferences
  void _loadQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedQuestions = prefs.getString(widget.category);
    if (savedQuestions != null) {
      setState(() {
        questionsList = List<Map<String, dynamic>>.from(json.decode(savedQuestions));
      });
    }
  }

  // Save questions to shared preferences
  void _saveQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedQuestions = json.encode(questionsList);  
    prefs.setString(widget.category, encodedQuestions);  
  }

  // Add a new question
  void _addQuestion() {
    if (questionController.text.isNotEmpty &&
        optionsControllers.every((controller) => controller.text.isNotEmpty) &&
        answerController.text.isNotEmpty) {
      setState(() {
        questionsList.add({
          'question': questionController.text,
          'options': optionsControllers.map((e) => e.text).toList(),
          'correctAnswer': answerController.text,
        });
      });

      //para auto clear na ang pag add ug question 
      questionController.clear();
      answerController.clear();
      optionsControllers.forEach((controller) => controller.clear());
      _saveQuestions();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question Saved!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  // button para sa Start sa quiz
  void _startQuiz() {
    if (questionsList.isNotEmpty) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => PlayScreen(questions: questionsList),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add some questions first')),
      );
    }
  }

//button para mo navigate sa see question
  void _seeQuestions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeeQuestionsScreen(category: widget.category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Question', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categories'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddCategoryScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.visibility),
              title: Text('See Questions'),
              onTap: _seeQuestions, 
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/bg3.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              SizedBox(
                width: 900, 
                child: TextField(
                  controller: questionController,
                  decoration: InputDecoration(
                    labelText: 'Question',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: Colors.white.withOpacity(0.7),
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  ),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 900, 
                child: TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: Colors.white.withOpacity(0.7),
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  ),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(height: 10),
              ...List.generate(4, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(
                    width: 900, 
                    child: TextField(
                      controller: optionsControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Option ${index + 1}',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fillColor: Colors.white.withOpacity(0.7),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              }),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _addQuestion,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(fontSize: 14, ),
                  backgroundColor:  const Color.fromARGB(255, 235, 97, 219),
                ),
                child: Text('Save Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SeeQuestionsScreen extends StatefulWidget {
  final String category;
  SeeQuestionsScreen({required this.category});

  @override
  _SeeQuestionsScreenState createState() => _SeeQuestionsScreenState();
}

class _SeeQuestionsScreenState extends State<SeeQuestionsScreen> {
  List<Map<String, dynamic>> questionsList = [];
  final List<String> boxImages = [
    'assets/img/mini1.jpg',
    'assets/img/mini2.jpg',
    'assets/img/mini3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }
//para matawag nato ang question nga na save
  void _loadQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedQuestions = prefs.getString(widget.category);
    if (savedQuestions != null) {
      setState(() {
        questionsList = List<Map<String, dynamic>>.from(json.decode(savedQuestions));
      });
    }
  }
//para maka delete ang user
  void _deleteQuestion(int index) async {
    setState(() {
      questionsList.removeAt(index);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.category, json.encode(questionsList));
  }
//para maka add ug question
  void _addQuestion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddQuestionScreen(category: widget.category),
      ),
    );
  }
//mao ning function para maka start ug quiz
  void _startQuiz() {
    if (questionsList.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayScreen(
            questions: questionsList,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add some questions first')),
      );
    }
  }

  String _getBoxImage(int index) {
    return boxImages[index % boxImages.length];
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Question"),
          content: Text("Are you sure you want to delete this question?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteQuestion(index);
                Navigator.pop(context);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Questions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/bg2.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: questionsList.isEmpty
                    ? Center(
                        child: Text(
                          "No questions added yet",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(110, 118, 3, 159)),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: questionsList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _showDeleteDialog(index),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(_getBoxImage(index)),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    questionsList[index]['question'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: List.generate(4, (optionIndex) {
                                      return Text(
                                        "Option ${optionIndex + 1}: ${questionsList[index]['options'][optionIndex]}",
                                        style: TextStyle(fontSize: 15),
                                        textAlign: TextAlign.center,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _addQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 233, 43, 211),
                    ),
                    child: Text(
                      'Add Question',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _startQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 233, 43, 211),
                    ),
                    child: Text(
                      'Start Quiz',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class PlayScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;

  PlayScreen({required this.questions});

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  List<Map<String, dynamic>> shuffledQuestions = [];
  int currentQuestionIndex = 0;
  bool showAnswer = false;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  late Stopwatch stopwatch;
  bool isQuizFinished = false;
  late Timer countdownTimer;
  int remainingTime = 30; 

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
    stopwatch.start();

    // para ramdom ang pag display sa question 
    shuffledQuestions = List.from(widget.questions)..shuffle(Random());
    startCountdown(); 
  }

  //mag restart ang timer every question
  void startCountdown() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          nextQuestion(false); 
        }
      });
    });
  }
// function kung asa mapadulung ang answer
  void nextQuestion(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        correctAnswers++;
      } else {
        wrongAnswers++;
      }
      remainingTime = 30; 
      countdownTimer.cancel(); 
      startCountdown(); 

      if (currentQuestionIndex < shuffledQuestions.length - 1) {
        currentQuestionIndex++;
        showAnswer = false; 
      } else {

        // pag human answer sa quiz mo dritso na dayun sya sa progress screen
        isQuizFinished = true;
        stopwatch.stop();
        countdownTimer.cancel();

        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProgressScreen(
                correctAnswers: correctAnswers,
                wrongAnswers: wrongAnswers,
                elapsedTime: stopwatch.elapsed.inSeconds.toString(),
                progress: 1.0,
              ),
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    countdownTimer.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentQuestion = shuffledQuestions[currentQuestionIndex];
    var questionText = currentQuestion['question'];
    var options = currentQuestion['options'];
    var correctAnswer = currentQuestion['correctAnswer'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Play Screen', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/bg2.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Container(
            height: 600,
            width: 400,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFC2185B),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300,
                  height: 180,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showAnswer = !showAnswer;
                      });
                    },
                    child: showAnswer
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Answer: $correctAnswer',
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                              SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () {
                                  nextQuestion(true);
                                },
                                child: Text('Next'),
                              ),
                            ],
                          )
                        : Text(
                            questionText,
                            style: TextStyle(fontSize: 20, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
                SizedBox(height: 20),
                if (!showAnswer)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 170,
                        child: ElevatedButton(
                          onPressed: () {
                            bool isCorrect = options[index] == correctAnswer;
                            nextQuestion(isCorrect);
                          },
                          child: Text(options[index], style: TextStyle(fontSize: 16)),
                        ),
                      );
                    }),
                  ),
                if (isQuizFinished)
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Quiz Finished!',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                if (!isQuizFinished)
                  Text(
                    'Remaining Time: $remainingTime s',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







class ProgressScreen extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;
  final String elapsedTime;
  final double progress;

  ProgressScreen({
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.elapsedTime,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    int totalAnswers = correctAnswers + wrongAnswers;
    double percentage = totalAnswers > 0 ? (correctAnswers / totalAnswers) * 100 : 0;

    return Scaffold(
      appBar: AppBar(title: Text('Quiz Progress', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categories'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddCategoryScreen()));
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/bg2.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          
         
          Padding( 
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: <Widget>[
                    _buildStatBox(Icons.check_circle, 'Correct', correctAnswers, Colors.green),
                    SizedBox(width: 20),
                    _buildStatBox(Icons.timer, 'Time', int.parse(elapsedTime), Colors.blue),
                    SizedBox(width: 20), 
                    _buildStatBox(Icons.cancel, 'Wrong', wrongAnswers, Colors.red),
                  ],
                ),
                SizedBox(height: 60),
                Align(
                  alignment: Alignment.center,
                  child: _buildPercentageBox(percentage),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatBox(IconData icon, String title, int value, Color color) {
    return Container(
      width: 380,
      padding: EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 50),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            '$value',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageBox(double percentage) {
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue, width: 3),
      ),
      child: Column(
        children: [
          Icon(Icons.pie_chart, color: Colors.blue, size: 50),
          SizedBox(height: 12),
          Text(
            'Correct Answer Percentage',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 110,
                height: 100,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                  strokeWidth: 12,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}