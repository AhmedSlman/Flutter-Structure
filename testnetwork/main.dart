import 'package:flutter/material.dart';
import 'package:improved_dio_solution/core/network/dio_service.dart';
import 'package:improved_dio_solution/core/network/network_config.dart';
import 'package:improved_dio_solution/data/models/user_model.dart';
import 'package:improved_dio_solution/data/repositories/edit_profile_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dio Refactor Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final DioService _dioService;
  late final EditProfileRepository _editProfileRepository;

  String _statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    // Initialize DioService with a specific network configuration
    // You can choose between development, production, or testing configs
    _dioService = DioService(networkConfig: NetworkConfig.development);
    _editProfileRepository = EditProfileRepository(_dioService);
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _statusMessage = 'Fetching data...';
    });

    // Example 1: Get Supplier Rates
    final supplierRatesResult = await _editProfileRepository.getSupplierRates('some_supplier_id');
    supplierRatesResult.handle(
      onSuccess: (data) {
        setState(() {
          _statusMessage = 'Supplier Rates: ${data.rating} - ${data.comment}';
        });
        print('Supplier Rates: ${data.rating} - ${data.comment}');
      },
      onError: (error) {
        setState(() {
          _statusMessage = 'Error fetching supplier rates: ${error.message}';
        });
        print('Error fetching supplier rates: ${error.message}');
        // You can also access error.type, error.statusCode, etc.
      },
    );

    // Example 2: Get User Profile
    final userProfileResult = await _editProfileRepository.getProfile();
    userProfileResult.handle(
      onSuccess: (user) {
        setState(() {
          _statusMessage = 'User Profile: ${user.name} - ${user.email}';
        });
        print('User Profile: ${user.name} - ${user.email}');
      },
      onError: (error) {
        setState(() {
          _statusMessage = 'Error fetching user profile: ${error.message}';
        });
        print('Error fetching user profile: ${error.message}');
      },
    );

    // Example 3: Edit User Profile (dummy data)
    final dummyUser = UserModel(
      id: '123',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '1234567890',
    );
    final editProfileResult = await _editProfileRepository.editProfile(dummyUser);
    editProfileResult.handle(
      onSuccess: (updatedUser) {
        setState(() {
          _statusMessage = 'Profile updated: ${updatedUser.name}';
        });
        print('Profile updated: ${updatedUser.name}');
      },
      onError: (error) {
        setState(() {
          _statusMessage = 'Error updating profile: ${error.message}';
        });
        print('Error updating profile: ${error.message}');
        if (error.shouldLogout) {
          print('User should be logged out!');
          // Implement actual logout logic here
        }
      },
    );

    // Example 4: Confirm Mobile/Email
    final confirmResult = await _editProfileRepository.confirmMobileEmail(
      otp: '123456',
      email: 'test@example.com',
    );
    confirmResult.handle(
      onSuccess: (success) {
        setState(() {
          _statusMessage = 'Mobile/Email confirmation: $success';
        });
        print('Mobile/Email confirmation: $success');
      },
      onError: (error) {
        setState(() {
          _statusMessage = 'Error confirming mobile/email: ${error.message}';
        });
        print('Error confirming mobile/email: ${error.message}');
      },
    );

    // Example 5: Verify New Password
    final verifyPassResult = await _editProfileRepository.verifyNewPassword('some_code');
    verifyPassResult.handle(
      onSuccess: (success) {
        setState(() {
          _statusMessage = 'Password verification: $success';
        });
        print('Password verification: $success');
      },
      onError: (error) {
        setState(() {
          _statusMessage = 'Error verifying password: ${error.message}';
        });
        print('Error verifying password: ${error.message}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio Refactor Demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Network Request Status:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchData,
                child: const Text('Run All Examples Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


