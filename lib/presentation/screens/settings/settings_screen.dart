import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = false;
  bool _darkMode = false;
  bool _settingsChanged = false;

  final _signatureController = TextEditingController(
    text: 'Sent from MailBox',
  );

  // TODO: load these from shared prefs or something

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    // TODO: actually persist settings somewhere
    print('saving settings: darkMode=$_darkMode notifications=$_notificationsEnabled');
    setState(() => _settingsChanged = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
          actions: [
          if (_settingsChanged)
            TextButton(
              onPressed: _saveSettings,
              child: const Text('Save'),
            ),
        ],
      ),
      body: ListView(
        children: [

          _SectionHeader(title: 'Appearance'),
          SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: const Text('Switch to dark theme'),
            value: _darkMode,
            onChanged: (val) {
              print('dark mode toggled: $val');
              setState(() {
                _darkMode = val;
                _settingsChanged = true;
              });
            },
          ),
          const Divider(height: 1),

          _SectionHeader(title: 'Notifications'),
          SwitchListTile(
            title: const Text('Push notifications'),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() {
                _notificationsEnabled = val;
                _settingsChanged = true;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Sound'),
            value: _soundEnabled,
            onChanged: _notificationsEnabled
                ? (val) {
                    setState(() {
                      _soundEnabled = val;
                      _settingsChanged = true;
                    });
                  }
                : null,
          ),
          SwitchListTile(
            title: const Text('Vibration'),
            value: _vibrationEnabled,
            onChanged: _notificationsEnabled
                ? (val) {
                    setState(() {
                      _vibrationEnabled = val;
                      _settingsChanged = true;
                    });
                  }
                : null,
          ),
          const Divider(height: 1),

          _SectionHeader(title: 'Signature'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _signatureController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Add a signature...',
                helperText: 'Added to the end of outgoing emails',
              ),
              onChanged: (_) {
                setState(() {
                  _settingsChanged = true;
                });
              },
            ),
          ),
          const Divider(height: 1),

          _SectionHeader(title: 'Account'),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final user = state is AuthAuthenticated ? state.user : null;
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(user?.name ?? 'Unknown'),
                    subtitle: Text(user?.email ?? ''),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Sign out',
                        style: TextStyle(color: Colors.red)),
                    onTap: () {
                      context.read<AuthCubit>().logout();
                    },
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 48),
          Center(
            child: Text(
              'MailBox v1.0.0',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: Colors.grey[400]),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A73E8),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}