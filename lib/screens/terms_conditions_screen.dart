import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<bool> _isExpanded = List.generate(9, (index) => false);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.gavel,
                            color: Colors.blue.shade700,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Terms and Conditions',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Last updated: ${DateTime.now().year}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildExpandableSection(
                        index: 0,
                        title: '1. Acceptance of Terms',
                        content: 'By accessing and using this quiz application, you accept and agree to be bound by the terms and provision of this agreement.',
                        icon: Icons.check_circle,
                      ),
                      _buildExpandableSection(
                        index: 1,
                        title: '2. Use License',
                        content: 'Permission is granted to temporarily download one copy of the quiz app for personal, non-commercial transitory viewing only.',
                        icon: Icons.description,
                      ),
                      _buildExpandableSection(
                        index: 2,
                        title: '3. Disclaimer',
                        content: 'The materials in this quiz app are provided on an \'as is\' basis. We make no warranties, expressed or implied, and hereby disclaim and negate all other warranties including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.',
                        icon: Icons.warning,
                      ),
                      _buildExpandableSection(
                        index: 3,
                        title: '4. Limitations',
                        content: 'In no event shall the quiz app developers or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials in the quiz app.',
                        icon: Icons.block,
                      ),
                      _buildExpandableSection(
                        index: 4,
                        title: '5. Accuracy of Materials',
                        content: 'The materials appearing in the quiz app could include technical, typographical, or photographic errors. We do not warrant that any of the materials in the quiz app are accurate, complete, or current.',
                        icon: Icons.fact_check,
                      ),
                      _buildExpandableSection(
                        index: 5,
                        title: '6. Links',
                        content: 'We have not reviewed all of the sites linked to our quiz app and are not responsible for the contents of any such linked site.',
                        icon: Icons.link,
                      ),
                      _buildExpandableSection(
                        index: 6,
                        title: '7. Modifications',
                        content: 'We may revise these terms of service for its quiz app at any time without notice. By using this quiz app, you are agreeing to be bound by the then current version of these terms of service.',
                        icon: Icons.edit,
                      ),
                      _buildExpandableSection(
                        index: 7,
                        title: '8. Privacy Policy',
                        content: 'Your privacy is important to us. We collect minimal data necessary for the app functionality and do not share personal information with third parties.',
                        icon: Icons.privacy_tip,
                      ),
                      _buildExpandableSection(
                        index: 8,
                        title: '9. Contact Information',
                        content: 'If you have any questions about these Terms and Conditions, please contact us through the Contact Us section in the app.',
                        icon: Icons.contact_support,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'By using this quiz application, you acknowledge that you have read and understood these terms and conditions and agree to be bound by them.',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('I Understand'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required int index,
    required String title,
    required String content,
    required IconData icon,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: _isExpanded[index] ? Colors.blue.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isExpanded[index] ? Colors.blue.shade200 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: ExpansionTile(
        leading: Icon(
          icon,
          color: _isExpanded[index] ? Colors.blue.shade700 : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _isExpanded[index] ? Colors.blue.shade700 : Colors.black87,
          ),
        ),
        trailing: AnimatedRotation(
          turns: _isExpanded[index] ? 0.5 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Icon(
            Icons.expand_more,
            color: _isExpanded[index] ? Colors.blue.shade700 : Colors.grey.shade600,
          ),
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded[index] = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
