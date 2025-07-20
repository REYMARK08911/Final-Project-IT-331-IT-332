import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const SmartFrameApp());
}

class SmartFrameApp extends StatefulWidget {
  const SmartFrameApp({super.key});

  @override
  State<SmartFrameApp> createState() => _SmartFrameAppState();
}

class _SmartFrameAppState extends State<SmartFrameApp> {
  final ValueNotifier<bool> _isLoggedIn = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isLoggedIn.dispose();
    super.dispose();
  }

  void _signIn() {
    _isLoggedIn.value = true;
    print('User signed in!');
  }

  void _signUp() {
    print('User signed up! Redirecting to Login...');
  }

  void _signOut() {
    _isLoggedIn.value = false;
    print('User signed out!');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartFrame',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          elevation: 0,
          titleTextStyle:
              TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A1A),
          selectedItemColor: Color(0xFFFDD835),
          unselectedItemColor: Colors.grey,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF2C2C2C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFDD835),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
                color: Colors.white54, width: 1.5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor:
                const Color(0xFFFDD835),
          ),
        ),
        listTileTheme: ListTileThemeData(
          textColor: Colors.white,
          iconColor: Colors.grey[400],
        ),
      ),
      home: AuthWrapper(
        isLoggedIn: _isLoggedIn,
        onSignIn: _signIn,
        onSignUp: _signUp,
        onSignOut: _signOut,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final ValueNotifier<bool> isLoggedIn;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;
  final VoidCallback onSignOut;

  const AuthWrapper({
    super.key,
    required this.isLoggedIn,
    required this.onSignIn,
    required this.onSignUp,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoggedIn,
      builder: (context, loggedIn, child) {
        if (loggedIn) {
          return MainNavigationWrapper(onSignOut: onSignOut);
        } else {
          return Navigator(
            pages: [
              MaterialPage(
                key: const ValueKey('WelcomePage'),
                child: WelcomeScreen(
                  onSignInRedirect: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(
                          onSignIn: onSignIn,
                          onSignUpRedirect: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(
                                  onSignUp: onSignUp,
                                  onSignInRedirect: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  onSignUpRedirect: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(
                          onSignUp: onSignUp,
                          onSignInRedirect: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(
                                  onSignIn: onSignIn,
                                  onSignUpRedirect: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => SignUpScreen(onSignUp: onSignUp, onSignInRedirect: () => Navigator.of(context).pop())),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            onDidRemovePage: (route) {
              // Handle page removal logic if needed
            },
          );
        }
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onSignInRedirect;
  final VoidCallback onSignUpRedirect;

  const WelcomeScreen({
    super.key,
    required this.onSignInRedirect,
    required this.onSignUpRedirect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.accessibility_new,
                size: 80,
                color: Color(0xFFFDD835),
              ),
              const SizedBox(height: 10),
              const Text(
                'SmartFrame',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your Intelligent Walking Companion',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 60),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.shield_outlined,
                          color: Colors.green, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Safe Navigation',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.favorite_border,
                          color: Colors.red, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Health Tracking',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSignInRedirect,
                  child: const Text('Sign In'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onSignUpRedirect,
                  child: const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Navigate confidently with voice guidance, obstacle\ndetection, and emergency support.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final VoidCallback onSignIn;
  final VoidCallback onSignUpRedirect;

  const LoginScreen({
    super.key,
    required this.onSignIn,
    required this.onSignUpRedirect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.login,
                size: 80,
                color: Color(0xFFFDD835),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                ),
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSignIn,
                  child: const Text('Log In'),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: onSignUpRedirect,
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  final VoidCallback onSignUp;
  final VoidCallback onSignInRedirect;

  const SignUpScreen({
    super.key,
    required this.onSignUp,
    required this.onSignInRedirect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_add,
                size: 80,
                color: Color(0xFFFDD835),
              ),
              const SizedBox(height: 20),
              const Text(
                'Create Your Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                ),
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Create a password',
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.lock_reset, color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onSignUp();
                    onSignInRedirect();
                  },
                  child: const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: onSignInRedirect,
                child: const Text(
                  "Already have an account? Log In",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  final VoidCallback onSignOut;

  const MainNavigationWrapper({super.key, required this.onSignOut});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;
  late final FlutterTts tts = FlutterTts();
  Position? currentPosition;
  bool _isNavigating = false;
  String _systemStatus = "All Systems Operational";
  String _selectedMode = "Standby";
  final int _steps = 3247;
  final double _distance = 2.1;
  final int _heartRate = 78;
  bool _voiceGuidance = true;
  bool _audioFeedback = true;
  bool _hapticFeedback = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _requestPermissions();
    await _getCurrentLocation();
    await _speakWelcomeMessage();
    await tts.setLanguage("en-US");
    await tts.setSpeechRate(0.5);
  }

  Future<void> _requestPermissions() async {
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    if (await Permission.sms.isDenied) {
      await Permission.sms.request();
    }
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _speakWelcomeMessage() async {
    if (_voiceGuidance) {
      await tts.speak("Welcome to SmartFrame. Your intelligent walking companion.");
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (_voiceGuidance) {
        await tts.speak("Location services are disabled. Please enable them.");
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (_voiceGuidance) {
          await tts.speak("Location permissions are required for navigation.");
        }
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      setState(() {
        currentPosition = position;
      });

      if (_voiceGuidance) {
        await tts.speak("Your current location has been updated.");
      }
    } catch (e) {
      if (_voiceGuidance) {
        await tts.speak("Unable to get current location. Please try again.");
      }
    }
  }

  final List<Widget> _pages = [];

  @override
  Widget build(BuildContext context) {
    _pages.clear();
    _pages.addAll([
      HomeScreen(
        systemStatus: _systemStatus,
        voiceGuidance: _voiceGuidance,
        startNavigation: _startNavigation,
        stopNavigation: _stopNavigation,
        isNavigating: _isNavigating,
        selectedMode: _selectedMode,
        selectNavigationMode: _selectNavigationMode,
        checkHealth: _checkHealth,
        triggerEmergency: _triggerEmergency,
        showPerformance: _showPerformance,
        callEmergencyContact: _callEmergencyContact,
        steps: _steps,
        distance: _distance,
        heartRate: _heartRate,
        currentPosition: currentPosition,
        dailyStepGoal: 10000,
      ),
      NavigationScreen(
        isNavigating: _isNavigating,
        selectedMode: _selectedMode,
        startNavigation: _startNavigation,
        stopNavigation: _stopNavigation,
        selectNavigationMode: _selectNavigationMode,
        voiceGuidance: _voiceGuidance,
      ),
      HealthScreen(
        steps: _steps,
        distance: _distance,
        heartRate: _heartRate,
        checkHealth: _checkHealth,
      ),
      EmergencyScreen(
  triggerEmergency: _triggerEmergency,
  callEmergencyContact: _callEmergencyContact,
  voiceGuidance: _voiceGuidance, // Assuming _voiceGuidance is now _voiceGuidanceEnabled based on previous fixes
  onShareLocation: () { // Corrected parameter name
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing location... (not implemented)')),
    );
  },
  onAccessMedicalInfo: () { // Corrected parameter name
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Accessing medical info... (not implemented)')),
    );
  },
  onSendSafetyConfirmation: () { // Corrected parameter name
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sending safety confirmation... (not implemented)')),
    );
  },
),
      SettingsScreen(
        voiceGuidance: _voiceGuidance,
        audioFeedback: _audioFeedback,
        hapticFeedback: _hapticFeedback,
        onSettingsChanged: (voice, audio, haptic) {
          setState(() {
            _voiceGuidance = voice;
            _audioFeedback = audio;
            _hapticFeedback = haptic;
          });
        },
        onSignOut: widget.onSignOut,
      ),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.navigation),
            label: 'Navigate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Health',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Future<void> _startNavigation() async {
    setState(() {
      _isNavigating = true;
      _systemStatus = "Navigation Active";
      _selectedMode = "Indoor Navigation";
    });

    if (_voiceGuidance) {
      await tts.speak(
          "Navigation started. Hold the frame with both hands and maintain a small pace. The frame will scan the environment and guide you safely.");
    }
  }

  Future<void> _stopNavigation() async {
    setState(() {
      _isNavigating = false;
      _systemStatus = "All Systems Operational";
      _selectedMode = "Standby";
    });

    if (_voiceGuidance) {
      await tts.speak("Navigation stopped. You are now in standby mode.");
    }
  }

  Future<void> _selectNavigationMode(String mode) async {
    setState(() {
      _selectedMode = mode;
    });

    if (_voiceGuidance) {
      await tts.speak("Selected $mode. ${_getModeDescription(mode)}");
    }
  }

  String _getModeDescription(String mode) {
    switch (mode) {
      case 'Indoor Navigation':
        return 'Using ultrasonic sensors for indoor obstacle detection';
      case 'Outdoor Navigation':
        return 'Using GPS and camera for outdoor path finding';
      case 'Assisted Mode':
        return 'Caregiver-assisted navigation mode activated';
      default:
        return '';
    }
  }

  Future<void> _triggerEmergency() async {
    setState(() {
      _systemStatus = "Emergency Alert Activated";
    });

    if (_voiceGuidance) {
      await tts.speak(
          "Emergency alert activated. Your caregiver has been notified with your current location.");
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Alert Sent'),
        content: const Text(
            'Your emergency contacts have been notified with your current location.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkHealth() async {
    if (_voiceGuidance) {
      await tts.speak(
          "Health status: Heart rate $_heartRate beats per minute, ${_heartRate > 100 ? 'elevated' : 'normal'}. You've walked $_steps steps today, covering ${_distance.toStringAsFixed(1)} kilometers.");
    }
  }

  Future<void> _showPerformance() async {
    if (_voiceGuidance) {
      await tts.speak(
          "Performance metrics: Average walking speed 1.2 meters per second. Battery level at 85 percent.");
    }
  }

  Future<void> _callEmergencyContact() async {
    if (_voiceGuidance) {
      await tts.speak("Calling primary emergency contact. Please wait.");
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calling Emergency Contact'),
        content: const Text('Connecting to Triage at +0.0577 123456...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel Call'),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String systemStatus;
  final bool voiceGuidance;
  final VoidCallback startNavigation;
  final VoidCallback stopNavigation;
  final bool isNavigating;
  final String selectedMode;
  final Function(String) selectNavigationMode;
  final VoidCallback checkHealth;
  final VoidCallback triggerEmergency;
  final VoidCallback showPerformance;
  final VoidCallback callEmergencyContact;
  final int steps;
  final double distance;
  final int heartRate;
  final Position? currentPosition;
  final int dailyStepGoal;

  const HomeScreen({
    super.key,
    required this.systemStatus,
    required this.voiceGuidance,
    required this.startNavigation,
    required this.stopNavigation,
    required this.isNavigating,
    required this.selectedMode,
    required this.selectNavigationMode,
    required this.checkHealth,
    required this.triggerEmergency,
    required this.showPerformance,
    required this.callEmergencyContact,
    required this.steps,
    required this.distance,
    required this.heartRate,
    this.currentPosition,
    required this.dailyStepGoal,
  });

  @override
  Widget build(BuildContext context) {
    final String currentTime = DateFormat('h:mm a').format(DateTime.now());
    final String currentDate = DateFormat('EEEE, MMM d').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              currentTime,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                child: Text(
                  currentDate,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVoiceCommandsCard(context),
            const SizedBox(height: 20),
            
            _buildSystemStatusCard(context),
            const SizedBox(height: 20),
            
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildQuickActionButton(
                  context,
                  icon: Icons.directions_walk,
                  label: 'Start Walk',
                  description: 'Voice-guided navigation',
                  color: Colors.lightGreen[600],
                  onTap: isNavigating ? stopNavigation : startNavigation,
                ),
                _buildQuickActionButton(
                  context,
                  icon: Icons.emergency,
                  label: 'Emergency Call',
                  description: 'Call for help',
                  color: Colors.red[600],
                  onTap: callEmergencyContact,
                ),
                _buildQuickActionButton(
                  context,
                  icon: Icons.favorite,
                  label: 'Health Check',
                  description: 'View your stats',
                  color: Colors.blue[600],
                  onTap: checkHealth,
                ),
                _buildQuickActionButton(
                  context,
                  icon: Icons.settings,
                  label: 'Settings',
                  description: 'Adjust preferences',
                  color: Colors.orange[600],
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigate to Settings screen via Bottom Navigation Bar')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Text(
              'Daily Tip',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDailyTipCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceCommandsCard(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2C),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 30),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  Colors.orange[700]!.withAlpha(51), // Used withAlpha
                  const Color(0xFF2C2C2C),
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mic,
                size: 40,
                color: Colors.orange[700],
              ),
            ),
            const SizedBox(height: 10),
            
            const Text(
              'VOICE COMMANDS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            
            Text(
              'Tap to speak',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withAlpha(179),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatusCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green[700]?.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.check_circle,
                size: 24,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Status',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    systemStatus,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required Color? color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyTipCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Hold the frame with both hands and maintain a steady pace. The frame will alert you to obstacles and guide you safely.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

class NavigationScreen extends StatelessWidget {
  final bool isNavigating;
  final String selectedMode;
  final VoidCallback startNavigation;
  final VoidCallback stopNavigation;
  final Function(String) selectNavigationMode;
  final bool voiceGuidance;

  const NavigationScreen({
    super.key,
    required this.isNavigating,
    required this.selectedMode,
    required this.startNavigation,
    required this.stopNavigation,
    required this.selectNavigationMode,
    required this.voiceGuidance,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Assistant'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildStatusCard(context),
            const SizedBox(height: 30),
            _buildNavigationModesSection(context),
            const SizedBox(height: 30),
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.navigation,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Current Mode:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              selectedMode,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getModeColor(context, selectedMode),
              ),
            ),
            const SizedBox(height: 15),
            LinearProgressIndicator(
              value: isNavigating ? 0.8 : 0.0,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getModeColor(context, selectedMode),
              ),
              minHeight: 6,
            ),
          ],
        ),
      ),
    );
  }

  Color _getModeColor(BuildContext context, String mode) {
    switch (mode) {
      case 'Indoor Navigation':
        return Colors.blue;
      case 'Outdoor Navigation':
        return Colors.green;
      case 'Assisted Mode':
        return Colors.purple;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  List<Widget> _buildModeCards(BuildContext context) {
    final modes = [
      {
        'title': 'Indoor Navigation',
        'description': 'Ultrasonic obstacle detection',
        'icon': Icons.home,
        'color': Colors.blue
      },
      {
        'title': 'Outdoor Navigation',
        'description': 'GPS and camera guidance',
        'icon': Icons.directions,
        'color': Colors.green
      },
      {
        'title': 'Assisted Mode',
        'description': 'Caregiver-assisted navigation',
        'icon': Icons.accessible,
        'color': Colors.purple
      },
    ];

    return modes.map((mode) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: _buildModeCard(
          context,
          title: mode['title'] as String,
          description: mode['description'] as String,
          icon: mode['icon'] as IconData,
          color: mode['color'] as Color,
        ),
      );
    }).toList();
  }

  Widget _buildNavigationModesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Navigation Modes:',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        ..._buildModeCards(context),
      ],
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: selectedMode == title 
          ? Color.alphaBlend(
              color.withAlpha(38), // Fixed: Replaced withOpacity(0.15) with withAlpha(38)
              Theme.of(context).cardColor,
            )
          : Theme.of(context).cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => selectNavigationMode(title),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color.alphaBlend(
                    color.withAlpha(51),
                    Theme.of(context).cardColor,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.check_circle,
                color: selectedMode == title ? color : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: isNavigating 
              ? Colors.red[700] 
              : Colors.green[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isNavigating ? stopNavigation : startNavigation,
        child: Text(
          isNavigating ? 'STOP NAVIGATION' : 'START NAVIGATION',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class HealthScreen extends StatelessWidget {
  final int steps;
  final double distance;
  final int heartRate;
  final VoidCallback checkHealth;
  final int dailyStepGoal;
  final int walkingTime;
  final int walkingGoal;
  final int caloriesBurned;

  const HealthScreen({
    super.key,
    required this.steps,
    required this.distance,
    required this.heartRate,
    required this.checkHealth,
    this.dailyStepGoal = 10000,
    this.walkingTime = 45,
    this.walkingGoal = 60,
    this.caloriesBurned = 156,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed the AppBar to eliminate the duplicate "Health Tracking" title.
      // The main title and subtitle in the body are now the primary display.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center the children horizontally
          children: [
            const Text(
              'Health Tracking',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Center the text itself
            ),
            const SizedBox(height: 4),
            const Text(
              'Monitor your daily activity',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center, // Center the text itself
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.volume_up),
                label: const Text('Speak Health Summary'),
                onPressed: checkHealth,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildHealthMetricCard(
              icon: Icons.favorite,
              iconColor: Colors.red[400], // Red color for Heart Rate icon
              title: 'Heart Rate',
              value: heartRate.toString(),
              unit: 'BPM',
              status: _getHeartRateStatus(heartRate),
              statusColor: _getHeartRateColor(heartRate),
              isHeartRate: true,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildHealthMetricCard(
                  icon: Icons.directions_walk,
                  iconColor: Colors.lightGreen[400], // Green color for Steps icon
                  title: 'Steps Today',
                  value: NumberFormat('#,###').format(steps),
                  unit: 'steps',
                  progress: steps / dailyStepGoal,
                  goal: 'Goal: ${NumberFormat('#,###').format(dailyStepGoal)} steps',
                ),
                _buildHealthMetricCard(
                  icon: Icons.timer,
                  iconColor: Colors.blue[400], // Blue color for Walking Time icon
                  title: 'Walking Time',
                  value: walkingTime.toString(),
                  unit: 'minutes',
                  progress: walkingTime / walkingGoal,
                  goal: 'Goal: $walkingGoal minutes',
                ),
                _buildHealthMetricCard(
                  icon: Icons.map,
                  iconColor: Colors.purple[400], // Purple color for Distance icon
                  title: 'Distance',
                  value: distance.toStringAsFixed(1),
                  unit: 'km',
                ),
                _buildHealthMetricCard(
                  icon: Icons.local_fire_department,
                  iconColor: Colors.orange[400], // Orange color for Calories Burned icon
                  title: 'Calories Burned',
                  value: caloriesBurned.toString(),
                  unit: 'kcal',
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Weekly Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Weekly activity chart would appear here',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMetricCard({
    required IconData icon,
    required Color? iconColor, // Parameter for icon color
    required String title,
    required String value,
    required String unit,
    String? status,
    Color? statusColor,
    double? progress,
    String? goal,
    bool isHeartRate = false,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Changed to CrossAxisAlignment.center to center content within the card
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center icon and title in the row
              children: [
                Icon(
                  icon,
                  color: iconColor, // Use the iconColor parameter
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: isHeartRate ? 48 : 32,
                fontWeight: FontWeight.bold,
                color: isHeartRate ? Colors.red : Colors.white,
              ),
              textAlign: TextAlign.center, // Ensure value is centered
            ),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center, // Ensure unit is centered
            ),
            if (status != null) ...[
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  fontSize: 16,
                  color: statusColor ?? Colors.grey,
                ),
                textAlign: TextAlign.center, // Ensure status is centered
              ),
            ],
            if (progress != null && goal != null) ...[
              const SizedBox(height: 8),
              // LinearProgressIndicator takes full width, no need to center
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[700],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 4),
              Text(
                goal,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center, // Ensure goal is centered
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getHeartRateStatus(int heartRate) {
    if (heartRate < 60) return 'Below Normal';
    if (heartRate > 100) return 'Elevated';
    return 'Normal Range';
  }

  Color _getHeartRateColor(int heartRate) {
    if (heartRate < 60) return Colors.blue;
    if (heartRate > 100) return Colors.orange;
    return Colors.green;
  }
}

class EmergencyScreen extends StatelessWidget {
  final VoidCallback triggerEmergency;
  final VoidCallback callEmergencyContact;
  final bool voiceGuidance;
  final VoidCallback onShareLocation;
  final VoidCallback onAccessMedicalInfo;
  final VoidCallback onSendSafetyConfirmation;

  const EmergencyScreen({
    super.key,
    required this.triggerEmergency,
    required this.callEmergencyContact,
    required this.voiceGuidance,
    required this.onShareLocation,
    required this.onAccessMedicalInfo,
    required this.onSendSafetyConfirmation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Assistance'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning, color: Colors.white.withOpacity(0.8), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Quick access to help and support',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.call, size: 30, color: Colors.white), // Explicitly set to white for consistency
                label: const Text(
                  'EMERGENCY CALL',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: callEmergencyContact,
              ),
            ),
            const SizedBox(height: 30),

            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildQuickActionCard(
                  context,
                  icon: Icons.location_on,
                  label: 'Share Location',
                  description: 'Send current location to contacts',
                  onTap: onShareLocation,
                  iconColor: Colors.blue, // Added color
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.medical_services,
                  label: 'Medical Info',
                  description: 'Access medical information',
                  onTap: onAccessMedicalInfo,
                  iconColor: Colors.red, // Added color
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.person,
                  label: "I'm Safe",
                  description: 'Send safety confirmation',
                  onTap: onSendSafetyConfirmation,
                  iconColor: Colors.green, // Added color
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.warning,
                  label: 'Activate Alert',
                  description: 'Trigger emergency alert',
                  onTap: triggerEmergency,
                  iconColor: Colors.orange, // Added color
                ),
              ],
            ),
            const SizedBox(height: 30),

            Text(
              'Emergency Contacts',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.yellow[700]?.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, color: Colors.yellow[700]),
                ),
                title: const Text(
                  'Primary Contact',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Family\n+639771431686',
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Icon(Icons.call, color: Theme.of(context).colorScheme.primary),
                onTap: callEmergencyContact,
              ),
            ),
            const SizedBox(height: 20),
            // Add other emergency contacts here if needed
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback onTap,
    Color? iconColor, // Added iconColor parameter
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: iconColor ?? Colors.white, // Use iconColor if provided, else default to white
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final bool voiceGuidance;
  final bool audioFeedback;
  final bool hapticFeedback;
  final Function(bool voice, bool audio, bool haptic) onSettingsChanged;
  final VoidCallback onSignOut;

  const SettingsScreen({
    super.key,
    required this.voiceGuidance,
    required this.audioFeedback,
    required this.hapticFeedback,
    required this.onSettingsChanged,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildUserProfileCard(context),
          const SizedBox(height: 24),
          _buildSettingsSection(
            context,
            title: "General",
            children: [
              _buildSettingSwitch(
                context,
                title: "Voice Guidance",
                value: voiceGuidance,
                icon: Icons.volume_up,
                onChanged: (value) => onSettingsChanged(value, audioFeedback, hapticFeedback),
              ),
              _buildSettingItem(
                context,
                title: "Language",
                value: "English (US)",
                icon: Icons.language,
                onTap: () => _showNotImplemented(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsSection(
            context,
            title: "Feedback",
            children: [
              _buildSettingSwitch(
                context,
                title: "Audio Feedback",
                value: audioFeedback,
                icon: Icons.audio_file,
                onChanged: (value) => onSettingsChanged(voiceGuidance, value, hapticFeedback),
              ),
              _buildSettingSwitch(
                context,
                title: "Haptic Feedback",
                value: hapticFeedback,
                icon: Icons.vibration,
                onChanged: (value) => onSettingsChanged(voiceGuidance, audioFeedback, value),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsSection(
            context,
            title: "Navigation",
            children: [
              _buildSettingItem(
                context,
                title: "Default Mode",
                value: "Indoor",
                icon: Icons.home,
                onTap: () => _showNotImplemented(context),
              ),
              _buildSettingItem(
                context,
                title: "Obstacle Sensitivity",
                value: "High",
                icon: Icons.warning,
                onTap: () => _showNotImplemented(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsSection(
            context,
            title: "Account",
            children: [
              _buildSettingItem(
                context,
                title: "Emergency Contacts",
                icon: Icons.emergency,
                onTap: () => _showNotImplemented(context),
              ),
              _buildSignOutButton(context),
            ],
          ),
          const SizedBox(height: 24),
          _buildAppInfo(context),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFDD835).withOpacity(0.2),
              ),
              child: Icon(
                Icons.person,
                size: 30,
                color: const Color(0xFFFDD835),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reymark Reyes",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Configure your SmartFrame experience",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          elevation: 4,
          color: const Color(0xFF2C2C2C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingSwitch(BuildContext context, {
    required String title,
    required bool value,
    required IconData icon,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFFDD835),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, {
    required String title,
    String? value,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
      ),
      trailing: value != null 
          ? Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
            )
          : const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: onTap,
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout, color: Colors.red[400]),
      title: Text(
        "Sign Out",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.red[400],
            ),
      ),
      onTap: () => _showSignOutDialog(context),
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Column(
      children: [
        Text(
          "SmartFrame v1.0.0",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white54,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          "© ${DateTime.now().year} SmartFrame Inc.",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white54,
              ),
        ),
      ],
    );
  }

  void _showNotImplemented(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feature not implemented yet')),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text(
          'Sign Out',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              onSignOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
