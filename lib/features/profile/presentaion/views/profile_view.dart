import 'package:flutter/material.dart';
import 'package:task/features/login/presentaion/views/login_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/features/profile/data/cubit/profile_cubit.dart';
import 'package:task/core/helper/storage_helper.dart'; // For clearing token

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    _fetchProfile(); // Initial fetch when the screen is opened
  }

  Future<void> _fetchProfile() async {
    await context.read<ProfileCubit>().getProfile();
  }

  Future<void> _logout() async {
    // Clear the access token
    await StorageHelper.instance.delete('accessToken');

    // Navigate to the login screen after clearing the token
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7F3FF),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4A90E2), // Baby blue app bar
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) => current is ProfileSuccessState,
        listener: (context, state) {
          // Handle success or failure states if needed
        },
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4A90E2),
              ),
            );
          }
          if (state is ProfileSuccessState) {
            return RefreshIndicator(
              onRefresh: _fetchProfile, // Trigger fetch on pull-to-refresh
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300], // Placeholder color
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Color(0xFF4A90E2), // Baby blue icon color
                        ),
                      ),
                      const SizedBox(height: 20),

                      // User Information
                      _buildProfileInfo('Name',
                          state.profileModel?.data?.rows?[0].fullName ?? ''),
                      const SizedBox(height: 20),
                      _buildProfileInfo('Email',
                          state.profileModel?.data?.rows?[0].email ?? ''),
                      const SizedBox(height: 20),
                      _buildProfileInfo('Phone Number',
                          state.profileModel?.data?.rows?[0].phoneNumber ?? ''),
                      const SizedBox(height: 40),

                      // Logout Button
                      ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF4A90E2), // Baby blue button color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15), // Padding inside the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  // Helper method to build profile info fields with text fields
  Widget _buildProfileInfo(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20), // Margin for spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A90E2), // Baby blue text
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15), // Rounded corners
              border: Border.all(
                  color: const Color(0xFF4A90E2), width: 2), // Border color
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // Changes position of shadow
                ),
              ],
            ),
            child: TextFormField(
              initialValue: value,
              readOnly: true, // Make the text field read-only
              decoration: InputDecoration(
                border: InputBorder.none, // Remove default border
                hintText: 'Enter your $label', // Hint text
                hintStyle:
                    TextStyle(color: Colors.grey[400]), // Hint text color
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
