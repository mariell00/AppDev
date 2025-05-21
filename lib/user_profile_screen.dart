// lib/user_profile_screen.dart

import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Example data (replace with actual user data from your backend/state management)
  String _userName = "John Doe";
  String _userEmail = "john.doe@example.com";
  int _dailyCalorieGoal = 2000;
  String _dietaryPreference = "Vegetarian"; // e.g., "Vegetarian", "Keto", "None"
  bool _receiveNotifications = true;
  bool _isEditing = false; // To toggle between view and edit mode

  // Text controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _calorieGoalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _userName;
    _emailController.text = _userEmail;
    _calorieGoalController.text = _dailyCalorieGoal.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _calorieGoalController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _saveProfileChanges(); // Save changes when exiting edit mode
      }
    });
  }

  void _saveProfileChanges() {
    setState(() {
      // Update local state (in a real app, you'd send these to your backend)
      _userName = _nameController.text;
      _userEmail = _emailController.text;
      _dailyCalorieGoal = int.tryParse(_calorieGoalController.text) ?? _dailyCalorieGoal;

      // PUT HERE: Call your backend API to save user profile data
      // Example:
      // await BackendService.updateUserProfile({
      //   'name': _userName,
      //   'email': _userEmail,
      //   'calorieGoal': _dailyCalorieGoal,
      //   'dietaryPreference': _dietaryPreference,
      //   'receiveNotifications': _receiveNotifications,
      // });

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = theme.cardColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(color: theme.appBarTheme.foregroundColor),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            color: theme.appBarTheme.foregroundColor,
            onPressed: _toggleEditMode,
            tooltip: _isEditing ? 'Save Profile' : 'Edit Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Avatar and Name
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.green.withOpacity(0.2),
                    child: Icon(Icons.person, size: 60, color: Colors.green),
                  ),
                  const SizedBox(height: 16),
                  _isEditing
                      ? TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Your Name',
                            border: OutlineInputBorder(),
                            isDense: true, // Make it more compact
                          ),
                          style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          _userName,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                        ),
                  const SizedBox(height: 8),
                  _isEditing
                      ? TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          style: TextStyle(color: textColor, fontSize: 16),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.emailAddress,
                        )
                      : Text(
                          _userEmail,
                          style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7)),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Dietary Goals Section
            Text(
              'Dietary Goals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildProfileRow(
                    context,
                    Icons.local_fire_department,
                    'Daily Calorie Goal',
                    _isEditing
                        ? TextField(
                            controller: _calorieGoalController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: textColor),
                          )
                        : Text('$_dailyCalorieGoal kcal', style: TextStyle(color: textColor)),
                  ),
                  _buildProfileRow(
                    context,
                    Icons.category,
                    'Dietary Preference',
                    _isEditing
                        ? DropdownButton<String>(
                            value: _dietaryPreference,
                            dropdownColor: cardColor, // Match dropdown background to card
                            onChanged: (String? newValue) {
                              setState(() {
                                _dietaryPreference = newValue!;
                              });
                            },
                            items: <String>['None', 'Vegetarian', 'Vegan', 'Keto', 'Halal']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(color: textColor)),
                              );
                            }).toList(),
                            underline: SizedBox.shrink(), // Remove underline
                          )
                        : Text(_dietaryPreference, style: TextStyle(color: textColor)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Application Settings Section
            Text(
              'Application Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildProfileRow(
                context,
                Icons.notifications,
                'Receive Notifications',
                _isEditing
                    ? Switch(
                        value: _receiveNotifications,
                        onChanged: (bool value) {
                          setState(() {
                            _receiveNotifications = value;
                          });
                        },
                        activeColor: Colors.green,
                      )
                    : Text(_receiveNotifications ? 'On' : 'Off', style: TextStyle(color: textColor)),
              ),
            ),
            const SizedBox(height: 32),

            // Logout Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // PUT HERE: Implement Logout Logic
                  // For example, clear user session, navigate to login screen
                  print('Logout button pressed');
                  // Navigator.of(context).pushReplacementNamed('/login');
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text('Logout', style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build consistent profile rows
  Widget _buildProfileRow(BuildContext context, IconData icon, String title, Widget trailingWidget) {
    final theme = Theme.of(context);
    final iconColor = theme.iconTheme.color;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ],
          ),
          trailingWidget,
        ],
      ),
    );
  }
}