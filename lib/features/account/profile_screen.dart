import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/student_profile.dart';
import 'auth_form.dart';

/// The student's profile: name, education, exams they are preparing for and
/// district. Shown once after the first sign-in ([firstTime]) as a form. After
/// that it opens as a finished bio card, with an Edit button for changes.
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

  /// The form shows at registration, or when no profile has been saved yet.
  /// Otherwise the saved profile shows as a read-only bio card.
  late bool _editing = widget.firstTime || !_start.isComplete;
  late final SecurityQuestion? _savedQuestion = context.services.auth.securityQuestion;
  late SecurityQuestion? _question = _savedQuestion;
  final _answer = TextEditingController();

  /// A new question and answer must be saved when none exists yet, or when
  /// the student changes them.
  bool get _questionChanging => _savedQuestion == null || _question != _savedQuestion || _answer.text.trim().isNotEmpty;

  @override
  void dispose() {
    _name.dispose();
    _district.dispose();
    _answer.dispose();
    super.dispose();
  }

  Future<void> _save() => run(
    problem: _name.text.trim().isEmpty
        ? context.s.nameNeeded
        : (_questionChanging ? checkSecurityAnswer(context.s, _question, _answer.text) : null),
    () async {
      final auth = context.services.auth;
      final changeQuestion = _questionChanging;
      await auth.saveProfile(StudentProfile(fullName: _name.text.trim(), education: _education, exams: _exams, district: _district.text));
      if (changeQuestion) await auth.setSecurityQuestion(_question!, _answer.text);
      if (!mounted) return;
      if (!widget.firstTime) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.s.profileSaved)));
        _answer.clear();
        setState(() => _editing = false);
      }
      // First time: the app's first screen switches to the content by itself.
    },
  );

  /// Leaves the form without saving, putting back what was saved before.
  void _cancelEdit() {
    final p = context.services.auth.profile ?? _start;
    setState(() {
      _name.text = p.fullName ?? '';
      _district.text = p.district ?? '';
      _education = p.education;
      _exams
        ..clear()
        ..addAll(p.exams);
      _question = _savedQuestion;
      _answer.clear();
      message = null;
      _editing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_editing) return _bio(context);
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
                SecurityQuestionFields(
                  question: _question,
                  answer: _answer,
                  onQuestion: (q) => setState(() => _question = q),
                  answerHint: _savedQuestion == null ? null : s.changeAnswerHint,
                ),
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
                ] else if (context.services.auth.profile?.isComplete ?? false) ...[
                  const SizedBox(height: 8),
                  TextButton(onPressed: busy ? null : _cancelEdit, child: Text(s.cancel)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The saved profile as a finished, read-only bio card.
  Widget _bio(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final auth = context.services.auth;
    final p = auth.profile ?? _start;
    final name = (p.fullName ?? '').trim();
    final email = auth.user?.email ?? '';
    final initials = name.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).take(2).map((w) => w.characters.first.toUpperCase()).join();
    final district = (p.district ?? '').trim();

    Widget detail(IconData icon, String title, Widget value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 4),
                value,
              ],
            ),
          ),
        ],
      ),
    );
    Text plain(String? text) => Text(
      (text ?? '').isEmpty ? s.notSet : text!,
      style: theme.textTheme.bodyLarge?.copyWith(color: (text ?? '').isEmpty ? theme.colorScheme.onSurfaceVariant : null),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(s.myProfile),
        actions: [
          IconButton(tooltip: s.editProfile, icon: const Icon(Icons.edit_outlined), onPressed: () => setState(() => _editing = true)),
          const LanguageSwitch(),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: theme.colorScheme.surfaceContainerHigh,
                            foregroundColor: theme.colorScheme.onSurface,
                            child: initials.isEmpty
                                ? const Icon(Icons.person_outline, size: 40)
                                : Text(initials, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(name.isEmpty ? s.notSet : name, textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
                        if (email.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            email,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                        const SizedBox(height: 12),
                        const Divider(),
                        detail(Icons.school_outlined, s.education, plain(p.education?.name(lang))),
                        detail(
                          Icons.flag_outlined,
                          s.preparingFor,
                          p.exams.isEmpty
                              ? plain(null)
                              : Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    for (final e in ExamTarget.values)
                                      if (p.exams.contains(e))
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: theme.colorScheme.outlineVariant),
                                          ),
                                          child: Text(e.name(lang), style: theme.textTheme.bodyMedium),
                                        ),
                                  ],
                                ),
                        ),
                        detail(Icons.place_outlined, s.districtTown, plain(district)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: () => setState(() => _editing = true),
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(s.editProfile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
