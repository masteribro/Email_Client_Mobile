import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/email/email_cubit.dart';
import '../../blocs/email/email_state.dart';
import 'compose_field.dart';

class ComposeScreen extends StatefulWidget {
  final String? replyToEmail;
  final String? replyToName;
  final String? replySubject;

  const ComposeScreen({
    super.key,
    this.replyToEmail,
    this.replyToName,
    this.replySubject,
  });

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  late final TextEditingController _toController;
  late final TextEditingController _subjectController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _toController = TextEditingController(text: widget.replyToEmail ?? '');
    _subjectController =
        TextEditingController(text: widget.replySubject ?? '');
    _bodyController = TextEditingController();
  }

  @override
  void dispose() {
    _toController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _sendEmail() {
    final to = _toController.text.trim();
    if (to.isEmpty || !to.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid recipient email'),
          backgroundColor: Color(0xFFEA4335),
        ),
      );
      return;
    }

    final authState = context.read<AuthCubit>().state;
    final fromEmail = authState is AuthAuthenticated
        ? authState.user.email
        : 'ibrahim@mailbox.com';
    final fromName = authState is AuthAuthenticated
        ? authState.user.name
        : 'Ibrahim Mohammed Hassan';

    context.read<EmailCubit>().sendEmail(
          to: to,
          subject: _subjectController.text.trim(),
          body: _bodyController.text.trim(),
          fromEmail: fromEmail,
          fromName: fromName,
        );
  }

  void _showDiscardDialog() {
    final hasContent = _toController.text.isNotEmpty ||
        _subjectController.text.isNotEmpty ||
        _bodyController.text.isNotEmpty;

    if (!hasContent) {
      context.pop();
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard draft?'),
        content: const Text('This message will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.pop();
            },
            child: const Text('Discard',
                style: TextStyle(color: Color(0xFFEA4335))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fromEmail = (context.read<AuthCubit>().state is AuthAuthenticated)
        ? (context.read<AuthCubit>().state as AuthAuthenticated).user.email
        : 'ibrahim@mailbox.com';

    return BlocConsumer<EmailCubit, EmailState>(
      listenWhen: (prev, curr) =>
          curr is EmailSendSuccess || curr is EmailSendFailure,
      listener: (context, state) {
        if (state is EmailSendSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Message sent'),
                ],
              ),
              backgroundColor: Color(0xFF34A853),
            ),
          );
          context.pop();
        } else if (state is EmailSendFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.isNotEmpty
                  ? state.message
                  : 'Failed to send message. Please try again.'),
              backgroundColor: const Color(0xFFEA4335),
            ),
          );
        }
      },
      builder: (context, emailState) {
        final isSending = emailState is EmailSendInProgress;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: isSending ? null : _showDiscardDialog,
            ),
            title: const Text('New message'),
            actions: [
              if (isSending)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.send),
                  tooltip: 'Send',
                  onPressed: _sendEmail,
                ),
            ],
          ),
          body: Column(
            children: [
              const Divider(height: 1),
              ComposeField(
                prefix: 'From',
                child: Text(
                  fromEmail,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF5F6368),
                  ),
                ),
              ),
              const Divider(height: 1),
              ComposeField(
                prefix: 'To',
                child: TextField(
                  controller: _toController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Recipients',
                    hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
                  ),
                ),
              ),
              const Divider(height: 1),
              ComposeField(
                prefix: 'Subject',
                child: TextField(
                  controller: _subjectController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _bodyController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Compose email',
                      hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    tooltip: 'Attach file',
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Attachments not supported in demo')),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.link),
                    tooltip: 'Insert link',
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Links not supported in demo')),
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    icon: const Icon(Icons.send, size: 18),
                    label: const Text('Send'),
                    onPressed: isSending ? null : _sendEmail,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}