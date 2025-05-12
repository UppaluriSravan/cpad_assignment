// main.dart
// Flutter app for Back4App authentication and CRUD operations
// Author: [Your Name]
//
// This app allows users to sign up, log in, reset password, and perform CRUD operations
// on a 'Record' class (with name and age fields) stored in Back4App (Parse Server).

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  // Ensure Flutter bindings are initialized before async code
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Parse SDK with Back4App credentials
  await Parse().initialize(
    '27dnkCWgglNRDUDaq19hvGaWWNugFya1g7GqFttP', // Application ID
    'https://parseapi.back4app.com', // Server URL
    clientKey: 'NnvgiQpBe0NPMaSxDRWTSFwpHcv8J8C0UtkDE9L6', // Client Key
    autoSendSessionId: true,
    debug: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Root of the app, sets up theme and initial screen
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(), // Start with login/signup page
    );
  }
}

// LoginPage handles user login, signup, and password reset
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for input fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  // Login with username and password using ParseUser
  Future<void> login() async {
    // Check for empty fields before attempting login
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Please enter both username and password.';
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final user = ParseUser(username, password, null);
    final response = await user.login();
    setState(() {
      isLoading = false;
    });
    if (response.success) {
      // On success, go to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        errorMessage = response.error?.message ?? 'Login failed';
      });
    }
  }

  // Sign up with username, password, and email using ParseUser
  Future<void> signup() async {
    // Check for empty fields before attempting signup
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Please enter username, email, and password.';
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final email = emailController.text.trim();
    final user = ParseUser(username, password, email);
    final response = await user.signUp();
    setState(() {
      isLoading = false;
    });
    if (response.success) {
      // On success, go to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        errorMessage = response.error?.message ?? 'Signup failed';
      });
    }
  }

  // Request password reset email using ParseUser
  Future<void> resetPassword() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    final email = emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Please enter your email for password reset.';
      });
      return;
    }
    final user = ParseUser(null, null, email);
    final response = await user.requestPasswordReset();
    setState(() {
      isLoading = false;
    });
    if (response.success) {
      setState(() {
        errorMessage = 'Password reset email sent! Check your inbox.';
      });
    } else {
      setState(() {
        errorMessage = response.error?.message ?? 'Password reset failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Login/signup UI with input fields and buttons
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'CPAD Assignment',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 64, color: Colors.deepPurple),
                  const SizedBox(height: 16),
                  // Username input
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Email input
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Password input
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  // Error message
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  // Loading indicator
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: CircularProgressIndicator(),
                    )
                  else ...[
                    // Login and Sign Up buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              foregroundColor: Colors.white, // Set text color
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: signup,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.deepPurple),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              foregroundColor:
                                  Colors.deepPurple, // Set text color
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Password reset button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isLoading ? null : resetPassword,
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// HomePage handles CRUD operations for the Record class
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controllers for record input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';
  List<ParseObject> records = [];
  ParseObject? editingRecord;

  @override
  void initState() {
    super.initState();
    fetchRecords(); // Load records on page load
  }

  // Fetch all records from Back4App
  Future<void> fetchRecords() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    final query = QueryBuilder(ParseObject('Record'));
    final response = await query.query();
    setState(() {
      isLoading = false;
      if (response.success && response.results != null) {
        records = List<ParseObject>.from(response.results!);
      } else {
        errorMessage = response.error?.message ?? 'Failed to fetch records';
      }
    });
  }

  // Add a new record or update an existing one
  Future<void> addOrUpdateRecord() async {
    final name = nameController.text.trim();
    final ageText = ageController.text.trim();
    if (name.isEmpty || ageText.isEmpty || int.tryParse(ageText) == null) {
      setState(() {
        errorMessage = 'Please enter a valid name and numeric age.';
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    final age = int.parse(ageText);
    ParseObject record = editingRecord ?? ParseObject('Record');
    record.set('name', name);
    record.set('age', age);
    final response = await record.save();
    setState(() {
      isLoading = false;
    });
    if (response.success) {
      nameController.clear();
      ageController.clear();
      editingRecord = null;
      fetchRecords();
    } else {
      setState(() {
        errorMessage = response.error?.message ?? 'Failed to save record';
      });
    }
  }

  // Delete a record from Back4App
  Future<void> deleteRecord(ParseObject record) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    final response = await record.delete();
    setState(() {
      isLoading = false;
    });
    if (response.success) {
      fetchRecords();
    } else {
      setState(() {
        errorMessage = response.error?.message ?? 'Failed to delete record';
      });
    }
  }

  // Start editing a record (populate fields)
  void startEdit(ParseObject record) {
    setState(() {
      editingRecord = record;
      nameController.text = record.get<String>('name') ?? '';
      ageController.text = record.get<int>('age')?.toString() ?? '';
    });
  }

  // Logout the current user and return to login page
  Future<void> logout() async {
    setState(() {
      isLoading = true;
    });
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      await user.logout();
    }
    setState(() {
      isLoading = false;
    });
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // CRUD UI for records
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Records CRUD',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: isLoading ? null : logout,
          ),
        ],
      ),
      body: Center(
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Input fields for name and age
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: ageController,
                        decoration: InputDecoration(
                          labelText: 'Age (numeric)',
                          prefixIcon: Icon(Icons.numbers),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Add/Update and Cancel buttons
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: isLoading ? null : addOrUpdateRecord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        foregroundColor: Colors.white, // Set text color
                      ),
                      child: Text(
                        editingRecord == null ? 'Add' : 'Update',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    if (editingRecord != null)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            editingRecord = null;
                            nameController.clear();
                            ageController.clear();
                          });
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                  ],
                ),
                // Error message
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                // Loading indicator
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                const SizedBox(height: 16),
                // Records list title
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'All Records:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                // List of records
                Expanded(
                  child:
                      records.isEmpty
                          ? const Center(child: Text('No records found.'))
                          : ListView.separated(
                            itemCount: records.length,
                            separatorBuilder: (context, i) => const Divider(),
                            itemBuilder: (context, index) {
                              final record = records[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.deepPurple[100],
                                  child: Text(
                                    (record.get<String>('name') ?? 'N/A')
                                            .isNotEmpty
                                        ? (record.get<String>('name') ??
                                                'N/A')[0]
                                            .toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                title: Text(record.get<String>('name') ?? ''),
                                subtitle: Text(
                                  'Age: ${record.get<int>('age') ?? ''}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.deepPurple,
                                      ),
                                      onPressed: () => startEdit(record),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => deleteRecord(record),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// (Optional) Default Flutter counter page, not used in this app
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
