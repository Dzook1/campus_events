import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Manually-defined Firebase config
const firebaseConfig = {
  'apiKey': "AIzaSyAL7veSxCJ2qCiovx5BpoJep7KCXwOEhqM",
  'authDomain': "campus-events-9b03a.firebaseapp.com",
  'projectId': "campus-events-9b03a",
  'storageBucket': "campus-events-9b03a.firebasestorage.app",
  'messagingSenderId': "333380838618",
  'appId': "1:333380838618:web:1fc34cd2e7dd8b6d86b1e3",
  'measurementId': "G-0J0CJVQP7W"
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: firebaseConfig['apiKey']!,
      authDomain: firebaseConfig['authDomain']!,
      projectId: firebaseConfig['projectId']!,
      storageBucket: firebaseConfig['storageBucket']!,
      messagingSenderId: firebaseConfig['messagingSenderId']!,
      appId: firebaseConfig['appId']!,
      measurementId: firebaseConfig['measurementId']!,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void toggleForm() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void handleAuth() {
    final username = _emailController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter username and password")),
      );
      return;
    }

    if (isLogin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TravelPage(username: username)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup Successful")),
      );
    }

    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? "Login" : "Signup"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/handglobe.jpg", height: 300),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleAuth,
              child: Text(isLogin ? "Login" : "Signup"),
            ),
            TextButton(
              onPressed: toggleForm,
              child: Text(isLogin
                  ? "Don't have an account? Signup"
                  : "Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}

class TravelPage extends StatefulWidget {
  final String username;
  final String profileImage = "assets/images/profile.jpg";

  const TravelPage({super.key, required this.username});

  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  List<Map<String, String>> travelDestinations = [
    {
      'imagePath': "assets/images/tokyocity.jpg",
      'title': "Tokyo, Japan",
      'description': "A vibrant city blending tradition with futuristic vibes.",
      'price': "1000",
      'reviews': "4.5 stars from 1200 reviews",
      'location': "Tokyo, Japan",
      'travelTime': "12 hours",
    },
    {
      'imagePath': "assets/images/francetower.jpg",
      'title': "Paris, France",
      'description': "City of Light, Eiffel Tower, museums and pastries.",
      'price': "900",
      'reviews': "4.7 stars from 1500 reviews",
      'location': "Paris, France",
      'travelTime': "8 hours",
    },
    {
      'imagePath': "assets/images/italcol.jpg",
      'title': "Italy",
      'description': "Historic monuments, beautiful countryside, and Italian cuisine.",
      'price': "1200",
      'reviews': "4.6 stars from 800 reviews",
      'location': "Rome, Italy",
      'travelTime': "10 hours",
    },
  ];

  List<Map<String, String>> filteredDestinations = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDestinations = List.from(travelDestinations);
    searchController.addListener(_filterDestinations);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterDestinations);
    searchController.dispose();
    super.dispose();
  }

  void _filterDestinations() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredDestinations = travelDestinations
          .where((destination) =>
              destination['title']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                widget.profileImage,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Text("Hello, " + widget.username),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      widget.profileImage,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Hello, " + widget.username,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Search destinations",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            ...filteredDestinations.map((destination) {
              return travelCard(
                context,
                imagePath: destination['imagePath']!,
                title: destination['title']!,
                description: destination['description']!,
                price: double.parse(destination['price']!),
                reviews: destination['reviews']!,
                location: destination['location']!,
                travelTime: destination['travelTime']!,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget travelCard(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String description,
    required double price,
    required String reviews,
    required String location,
    required String travelTime,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(description),
                SizedBox(height: 8),
                Text("From \$$price • $reviews"),
                Text("Location: $location • Travel Time: $travelTime"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
