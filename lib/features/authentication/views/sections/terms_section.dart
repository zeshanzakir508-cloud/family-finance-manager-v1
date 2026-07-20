import 'package:flutter/material.dart';

/// Terms and conditions section widget.
class TermsSection extends StatefulWidget {
  final Function(bool) onTermsAccepted;
  final Function(bool) onPrivacyAccepted;

  const TermsSection({
    super.key,
    required this.onTermsAccepted,
    required this.onPrivacyAccepted,
  });

  @override
  State<TermsSection> createState() => _TermsSectionState();
}

class _TermsSectionState extends State<TermsSection> {
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Terms Checkbox
        CheckboxListTile(
          value: _termsAccepted,
          onChanged: (value) {
            setState(() {
              _termsAccepted = value ?? false;
            });
            widget.onTermsAccepted(_termsAccepted);
          },
          title: Row(
            children: [
              const Text('I agree to the '),
              GestureDetector(
                onTap: () {
                  // TODO: Show terms of service
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terms of Service will be shown here'),
                    ),
                  );
                },
                child: Text(
                  'Terms of Service',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),

        // Privacy Checkbox
        CheckboxListTile(
          value: _privacyAccepted,
          onChanged: (value) {
            setState(() {
              _privacyAccepted = value ?? false;
            });
            widget.onPrivacyAccepted(_privacyAccepted);
          },
          title: Row(
            children: [
              const Text('I agree to the '),
              GestureDetector(
                onTap: () {
                  // TODO: Show privacy policy
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Privacy Policy will be shown here'),
                    ),
                  );
                },
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}
