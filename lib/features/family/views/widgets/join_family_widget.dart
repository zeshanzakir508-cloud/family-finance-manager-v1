import 'package:flutter/material.dart';

/// Join family widget for quick join from home
class JoinFamilyWidget extends StatelessWidget {
  final VoidCallback onJoinPressed;

  const JoinFamilyWidget({super.key, required this.onJoinPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Join a Family',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Enter an invitation code to join an existing family.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter invitation code',
                      prefixIcon: Icon(Icons.code),
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 6,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onJoinPressed,
                  child: const Text('Join'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
