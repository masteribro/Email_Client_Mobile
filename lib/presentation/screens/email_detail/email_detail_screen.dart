import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../blocs/email/email_cubit.dart';
import '../../blocs/email/email_state.dart';
import 'email_body.dart';
import 'reply_bar.dart';

class EmailDetailScreen extends StatefulWidget {
  final String emailId;

  const EmailDetailScreen({super.key, required this.emailId});

  @override
  State<EmailDetailScreen> createState() => _EmailDetailScreenState();
}

class _EmailDetailScreenState extends State<EmailDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmailCubit>().markRead(widget.emailId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailCubit, EmailState>(
      builder: (context, state) {
        final email = state.emailById(widget.emailId);
        if (email == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text(AppStrings.emailNotFound)),
          );
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  email.isStarred ? Icons.star : Icons.star_border,
                  color: email.isStarred ? const Color(0xFFF4B400) : null,
                ),
                tooltip: email.isStarred
                    ? AppStrings.unstarTooltip
                    : AppStrings.starTooltip,
                onPressed: () =>
                    context.read<EmailCubit>().toggleStar(widget.emailId),
              ),
              IconButton(
                icon: Icon(
                  email.isRead
                      ? Icons.mark_email_unread_outlined
                      : Icons.mark_email_read_outlined,
                ),
                tooltip: email.isRead
                    ? AppStrings.markAsUnread
                    : AppStrings.markAsRead,
                onPressed: () =>
                    context.read<EmailCubit>().toggleRead(widget.emailId),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: AppStrings.moveToTrash,
                onPressed: () {
                  context.read<EmailCubit>().moveToTrash(widget.emailId);
                  context.pop();
                },
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: EmailBody(email: email),
          bottomNavigationBar: ReplyBar(email: email),
        );
      },
    );
  }
}