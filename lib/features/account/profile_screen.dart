import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/student_profile.dart';
import 'auth_form.dart';

/// The student's profile: name, education, exams they are preparing for and
/// district. Shown once after the first sign-in ([firstTime]), and from the Me tab.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.firstTime = false});
  final bool firstTime;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AuthFormMixin {
  late final StudentProfile _start = context.services.auth.profile ?? const StudentProfile();
  late final _name = TextEditingController(text: _start.fullName ?? '');
  late final _district = TextEditingController(text: _start.district ?? '');
  late Education? _education = _start.education;
  late final Set<ExamTarget> _exams = {..._start.exams};

  @override
  void dispose() {
    _name.dispose();
    _district.dispose();
    super.dispose();
  }

  Future<void> _save() => run(problem: _name.text.trim().isEmpty ? context.s.nameNeeded : null, () async {
    await context.services.auth.saveProfile(
      StudentProfile(fullName: _name.text.trim(), education: _education, exams: _exams, district: _district.text),
    );
    if (!mounted) return;
    if (!widget.firstTime) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.s.profileSaved)));
      Navigator.of(context).pop();
    }
    // First time: the app's first screen switches to the content by itself.
  });

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    Widget label(String text) => Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(text, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary)),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.firstTime ? s.setUpProfile : s.myProfile),
        automaticallyImplyLeading: !widget.firstTime,
        actions: const [LanguageSwitch(), SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              children: [
                if (widget.firstTime) ...[Text(s.profileHint, style: theme.textTheme.bodyLarge), const SizedBox(height: 20)],
                AuthField(controller: _name, label: s.fullName, hints: const [AutofillHints.name], maxLength: 80),
                label(s.education),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final e in Education.values)
                      ChoiceChip(
                        label: Text(e.name(lang)),
                        selected: _education == e,
                        onSelected: (on) => setState(() => _education = on ? e : null),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                label(s.examsPreparing),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final e in ExamTarget.values)
                      FilterChip(
                        label: Text(e.name(lang)),
                        selected: _exams.contains(e),
                        onSelected: (on) => setState(() => on ? _exams.add(e) : _exams.remove(e)),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                AuthField(controller: _district, label: s.district, maxLength: 60),
                messageLine(),
                const SizedBox(height: 12),
                FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: busy ? null : _save,
                  child: Text(widget.firstTime ? s.saveAndContinue : s.save),
                ),
                if (widget.firstTime) ...[
                  const SizedBox(height: 8),
                  TextButton(onPressed: busy ? null : context.services.auth.signOut, child: Text(s.signOut)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
