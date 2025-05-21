// lib/user_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Needed for date formatting

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Example data (replace with actual user data from your backend/state management)
  String _userName = "sbuser1234"; // Matches design
  String _userEmail = "smartbiteuser1234@gmail.com"; // Matches design
  String _profilePhotoUrl = ''; // Placeholder for a real photo URL
  double _heightFeet = 5; // Initial height in feet
  double _heightInches = 9.5; // Initial height in inches
  String _sex = "Male"; // Matches design
  DateTime _dateOfBirth = DateTime(2000, 1, 1); // Matches design

  bool _isEditing = false; // To toggle between view and edit mode

  // Text controllers for input fields
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _userName;
  }

  @override
  void dispose() {
    _nameController.dispose();
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
      // For other fields, update them directly from their respective dialogs/pickers

      // PUT HERE: Call your backend API to save user profile data
      // Example:
      // await BackendService.updateUserProfile({
      //   'name': _userName,
      //   'heightFeet': _heightFeet,
      //   'heightInches': _heightInches,
      //   'sex': _sex,
      //   'dateOfBirth': _dateOfBirth.toIso8601String(),
      // });

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    });
  }

  // Dialog for changing username
  void _showChangeUsernameDialog() {
    final TextEditingController newUsernameController = TextEditingController(text: _userName);
    final TextEditingController passwordController = TextEditingController(); // For confirmation

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
        final cardColor = theme.cardColor;

        return AlertDialog(
          backgroundColor: cardColor,
          title: Text('Change Username', style: TextStyle(color: textColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newUsernameController,
                decoration: InputDecoration(
                  labelText: 'New username',
                  labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor.withOpacity(0.5))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.primaryColor)),
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password (for confirmation)',
                  labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor.withOpacity(0.5))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.primaryColor)),
                ),
                style: TextStyle(color: textColor),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: theme.primaryColor)),
            ),
            TextButton(
              onPressed: () {
                // Implement username change logic here
                setState(() {
                  _userName = newUsernameController.text;
                  _nameController.text = _userName; // Update controller to reflect change
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Username changed to ${_userName}!')),
                );
                Navigator.pop(context);
              },
              child: Text('Save', style: TextStyle(color: theme.primaryColor)),
            ),
          ],
        );
      },
    );
  }

  // Dialog for choosing photo (Take Photo / Choose Existing Photo)
  void _showPhotoOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
        final cardColor = theme.cardColor;

        return AlertDialog(
          backgroundColor: cardColor,
          title: Text('Profile Photo', style: TextStyle(color: textColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Take Photo', style: TextStyle(color: textColor)),
                onTap: () {
                  // Implement take photo logic (e.g., using image_picker)
                  print('Take Photo');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Choose Existing Photo', style: TextStyle(color: textColor)),
                onTap: () {
                  // Implement choose photo logic (e.g., using image_picker)
                  print('Choose Existing Photo');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: theme.primaryColor)),
            ),
          ],
        );
      },
    );
  }

  // Dialog for height input
  void _showHeightDialog() {
    double currentFeet = _heightFeet;
    double currentInches = _heightInches;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
        final cardColor = theme.cardColor;

        return AlertDialog(
          backgroundColor: cardColor,
          title: Text('Set Height', style: TextStyle(color: textColor)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 70,
                child: TextField(
                  controller: TextEditingController(text: currentFeet.toInt().toString()),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'ft',
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5))
                  ),
                  onChanged: (value) {
                    currentFeet = double.tryParse(value) ?? currentFeet;
                  },
                ),
              ),
              Text('\'', style: TextStyle(color: textColor, fontSize: 24)),
              const SizedBox(width: 10),
              SizedBox(
                width: 70,
                child: TextField(
                  controller: TextEditingController(text: currentInches.toStringAsFixed(1)),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'in',
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5))
                  ),
                  onChanged: (value) {
                    currentInches = double.tryParse(value) ?? currentInches;
                  },
                ),
              ),
              Text('\"', style: TextStyle(color: textColor, fontSize: 24)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: theme.primaryColor)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _heightFeet = currentFeet;
                  _heightInches = currentInches;
                });
                Navigator.pop(context);
              },
              child: Text('Set', style: TextStyle(color: theme.primaryColor)),
            ),
          ],
        );
      },
    );
  }

  // Dialog for sex selection
  void _showSexDialog() {
    String selectedSex = _sex;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
        final cardColor = theme.cardColor;

        return AlertDialog(
          backgroundColor: cardColor,
          title: Text('Select Sex', style: TextStyle(color: textColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('Male', style: TextStyle(color: textColor)),
                value: 'Male',
                groupValue: selectedSex,
                onChanged: (value) {
                  setState(() {
                    selectedSex = value!;
                  });
                  Navigator.pop(context); // Close immediately after selection
                  setState(() {
                    _sex = selectedSex;
                  });
                },
                activeColor: theme.primaryColor,
              ),
              RadioListTile<String>(
                title: Text('Female', style: TextStyle(color: textColor)),
                value: 'Female',
                groupValue: selectedSex,
                onChanged: (value) {
                  setState(() {
                    selectedSex = value!;
                  });
                  Navigator.pop(context); // Close immediately after selection
                  setState(() {
                    _sex = selectedSex;
                  });
                },
                activeColor: theme.primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }

  // Date picker for Date of Birth
  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        // Customize the date picker theme
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black, // Date text color
              surface: Theme.of(context).cardColor, // Dialog background color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  // Dialog for changing password
  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController reenterPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
        final cardColor = theme.cardColor;

        return AlertDialog(
          backgroundColor: cardColor,
          title: Text('Change Password', style: TextStyle(color: textColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor.withOpacity(0.5))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.primaryColor)),
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor.withOpacity(0.5))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.primaryColor)),
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reenterPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Reenter New Password',
                  labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor.withOpacity(0.5))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.primaryColor)),
                ),
                style: TextStyle(color: textColor),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: theme.primaryColor)),
            ),
            TextButton(
              onPressed: () {
                // Implement password change logic here
                // Check if new passwords match, call backend etc.
                if (newPasswordController.text == reenterPasswordController.text && newPasswordController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password changed successfully!')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match or are empty.')),
                  );
                }
              },
              child: Text('Save', style: TextStyle(color: theme.primaryColor)),
            ),
          ],
        );
      },
    );
  }

  // Dialog for delete account confirmation
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
        final cardColor = theme.cardColor;

        return AlertDialog(
          backgroundColor: cardColor,
          title: Text('Delete Account', style: TextStyle(color: Colors.red)),
          content: Text('Are you sure you want to delete your account? This action cannot be undone.', style: TextStyle(color: textColor)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: theme.primaryColor)),
            ),
            TextButton(
              onPressed: () {
                // Implement actual account deletion logic
                print('Account deleted');
                Navigator.pop(context);
                // Navigate to login/splash screen
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Helper method to build consistent profile rows
  Widget _buildProfileRow(BuildContext context, {required String title, required Widget valueWidget, VoidCallback? onTap}) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // Ensures the whole row is tappable
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: valueWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the action buttons (Change Password, Delete, Logout)
  Widget _buildActionButton(BuildContext context, {required String title, required VoidCallback onPressed, Color? color}) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: color ?? theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: color != null ? Colors.white : textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
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
          'Profile', // Changed to "Profile" based on design
          style: TextStyle(color: theme.appBarTheme.foregroundColor),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton( // Back arrow
          icon: Icon(Icons.arrow_back, color: theme.appBarTheme.foregroundColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // We will use the edit icon within the username field if _isEditing is true
          // or rely on explicit 'Save' within dialogs for other fields.
          // The main app bar doesn't need a top-level edit/save toggle here
          // as interactions are mostly through tapping specific fields.
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Avatar and Name/Email (Top Section)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _isEditing ? _showPhotoOptionsDialog : null, // Only allow tap if editing
                    child: CircleAvatar(
                      radius: 40, // Smaller radius as in design
                      backgroundColor: Colors.green.withOpacity(0.2),
                      backgroundImage: _profilePhotoUrl.isNotEmpty ? NetworkImage(_profilePhotoUrl) : null,
                      child: _profilePhotoUrl.isEmpty
                          ? Icon(Icons.person, size: 40, color: Colors.green)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileRow(
                    context,
                    title: 'User Name',
                    valueWidget: _isEditing
                        ? GestureDetector(
                            onTap: _showChangeUsernameDialog,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _userName,
                                style: TextStyle(color: Colors.green, fontSize: 16), // Green text
                              ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _userName,
                              style: TextStyle(color: Colors.green, fontSize: 16), // Green text
                            ),
                          ),
                    onTap: _isEditing ? _showChangeUsernameDialog : null,
                  ),
                  _buildProfileRow(
                    context,
                    title: 'Email',
                    valueWidget: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _userEmail,
                        style: TextStyle(color: Colors.green, fontSize: 16), // Green text
                      ),
                    ),
                    onTap: null, // Email is generally not editable from profile
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Personal Information Section (Height, Sex, DOB)
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
                    title: 'Height',
                    valueWidget: _isEditing
                        ? GestureDetector(
                            onTap: _showHeightDialog,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${_heightFeet.toInt()}\' ${_heightInches.toStringAsFixed(1)}\"',
                                style: TextStyle(color: Colors.green, fontSize: 16), // Green text
                              ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${_heightFeet.toInt()}\' ${_heightInches.toStringAsFixed(1)}\"',
                              style: TextStyle(color: Colors.green, fontSize: 16), // Green text
                            ),
                          ),
                    onTap: _isEditing ? _showHeightDialog : null,
                  ),
                  _buildProfileRow(
                    context,
                    title: 'Sex',
                    valueWidget: _isEditing
                        ? GestureDetector(
                            onTap: _showSexDialog,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _sex,
                                style: TextStyle(color: Colors.green, fontSize: 16), // Green text
                              ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _sex,
                              style: TextStyle(color: Colors.green, fontSize: 16), // Green text
                            ),
                          ),
                    onTap: _isEditing ? _showSexDialog : null,
                  ),
                  _buildProfileRow(
                    context,
                    title: 'Date of Birth',
                    valueWidget: _isEditing
                        ? GestureDetector(
                            onTap: () => _selectDateOfBirth(context),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                DateFormat('MMM d, yyyy').format(_dateOfBirth),
                                style: TextStyle(color: Colors.green, fontSize: 16), // Green text
                              ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              DateFormat('MMM d, yyyy').format(_dateOfBirth),
                              style: TextStyle(color: Colors.green, fontSize: 16), // Green text
                            ),
                          ),
                    onTap: _isEditing ? () => _selectDateOfBirth(context) : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons (Change Password, Delete Account, Logout)
            _buildActionButton(
              context,
              title: 'Change Password',
              onPressed: _showChangePasswordDialog,
            ),
            _buildActionButton(
              context,
              title: 'Delete Account',
              onPressed: _showDeleteAccountDialog,
              color: Colors.redAccent, // Red for destructive action
            ),
            _buildActionButton(
              context,
              title: 'Logout',
              onPressed: () {
                // Implement actual logout logic
                print('User logged out');
                // For now, simply pop to demonstrate flow.
                // In a real app, you'd navigate to a login/onboarding screen.
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              color: Colors.redAccent, // Consistent with Logout design
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleEditMode,
        backgroundColor: Colors.green,
        child: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.white),
      ),
    );
  }
}