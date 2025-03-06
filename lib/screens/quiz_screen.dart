import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswerSelected = false;
  int? _selectedAnswerIndex;
  int _timeLeft = 10; // Timer for each question
  bool _isTimerActive = true;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Which blood type is known as the universal donor?',
      'answers': ['A+', 'B-', 'O-', 'AB+'],
      'correctAnswer': 2,
      'explanation': 'O- is the universal donor because it lacks A, B, and Rh antigens.',
    },
    {
      'question': 'Which blood type can receive blood from any other type?',
      'answers': ['O+', 'AB+', 'B-', 'A-'],
      'correctAnswer': 1,
      'explanation': 'AB+ is the universal recipient because it has all A, B, and Rh antigens.',
    },
    // Add more questions here
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_timeLeft > 0 && _isTimerActive) {
        setState(() => _timeLeft--);
        _startTimer();
      } else if (_timeLeft == 0) {
        _moveToNextQuestion();
      }
    });
  }

  void _moveToNextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _isAnswerSelected = false;
      _selectedAnswerIndex = null;
      _timeLeft = 10;
      _isTimerActive = true;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Type Compatibility Quiz'),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 4,
      ),
      body: _currentQuestionIndex < _questions.length
          ? _buildQuestionWidget()
          : _buildResultWidget(),
    );
  }

  Widget _buildQuestionWidget() {
    final question = _questions[_currentQuestionIndex];
    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
            SizedBox(height: 20),

            // Timer
            Text(
              'Time Left: $_timeLeft seconds',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 20),

            // Question Text
            Text(
              question['question'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 20),

            // Answer Buttons
            ...question['answers'].asMap().entries.map((entry) {
              final index = entry.key;
              final answer = entry.value;
              final isCorrect = index == question['correctAnswer'];
              final isSelected = index == _selectedAnswerIndex;

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        child: Text(answer),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isAnswerSelected
                              ? (isSelected
                              ? (isCorrect ? Colors.green : Colors.red)
                              : Colors.white)
                              : Colors.white,
                          foregroundColor: _isAnswerSelected
                              ? (isSelected ? Colors.white : Colors.black)
                              : Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (!_isAnswerSelected) {
                            setState(() {
                              _selectedAnswerIndex = index;
                              _isAnswerSelected = true;
                              _isTimerActive = false;
                              if (isCorrect) _score++;
                            });

                            // Show explanation
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(question['explanation']),
                                duration: Duration(seconds: 2),
                              ),
                            );

                            // Move to the next question after a delay
                            Future.delayed(Duration(seconds: 2), () {
                              _moveToNextQuestion();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events,
            size: 100,
            color: Colors.red,
          ),
          SizedBox(height: 20),
          Text(
            'Quiz Completed!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Your Score: $_score / ${_questions.length}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text(
              'Restart Quiz',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: _restartQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _isAnswerSelected = false;
      _selectedAnswerIndex = null;
      _timeLeft = 10;
      _isTimerActive = true;
    });
    _startTimer();
  }
}