import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/email/email_cubit.dart';
import '../../blocs/email/email_state.dart';
import 'compose_field.dart';

class _Attachment {
  final String name;
  final int bytes;

  const _Attachment({required this.name, required this.bytes});

  String get sizeLabel {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData get icon {
    final ext = name.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic'].contains(ext)) {
      return Icons.image_outlined;
    }
    if (['mp4', 'mov', 'avi', 'mkv'].contains(ext)) {
      return Icons.videocam_outlined;
    }
    if (['mp3', 'wav', 'aac', 'm4a'].contains(ext)) {
      return Icons.audiotrack_outlined;
    }
    if (ext == 'pdf') return Icons.picture_as_pdf_outlined;
    if (['doc', 'docx'].contains(ext)) return Icons.description_outlined;
    if (['xls', 'xlsx'].contains(ext)) return Icons.table_chart_outlined;
    if (['zip', 'rar', '7z'].contains(ext)) return Icons.folder_zip_outlined;
    return Icons.insert_drive_file_outlined;
  }
}

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
  final List<_Attachment> _attachments = [];

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
          content: Text(AppStrings.invalidRecipient),
          backgroundColor: AppColors.error,
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

    // Append attachment names to body for demo purposes
    String body = _bodyController.text.trim();
    if (_attachments.isNotEmpty) {
      final names = _attachments.map((a) => '📎 ${a.name}').join('\n');
      body = body.isEmpty ? names : '$body\n\n$names';
    }

    context.read<EmailCubit>().sendEmail(
          to: to,
          subject: _subjectController.text.trim(),
          body: body,
          fromEmail: fromEmail,
          fromName: fromName,
        );
  }

  void _showDiscardDialog() {
    final hasContent = _toController.text.isNotEmpty ||
        _subjectController.text.isNotEmpty ||
        _bodyController.text.isNotEmpty ||
        _attachments.isNotEmpty;

    if (!hasContent) {
      context.pop();
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.discardDraft),
        content: const Text(AppStrings.discardMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.pop();
            },
            child: const Text(AppStrings.discard,
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      if (result != null && mounted) {
        setState(() {
          for (final file in result.files) {
            if (!_attachments.any((a) => a.name == file.name)) {
              _attachments.add(
                _Attachment(name: file.name, bytes: file.size),
              );
            }
          }
        });
      }
    } catch (_) {
      // User cancelled or permission denied — do nothing
    }
  }

  void _showInsertLinkDialog() {
    final urlCtrl = TextEditingController();
    final textCtrl = TextEditingController();

    // Pre-fill display text with any selected body text
    final sel = _bodyController.selection;
    if (sel.isValid && !sel.isCollapsed) {
      textCtrl.text =
          _bodyController.text.substring(sel.start, sel.end);
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.insertLink),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlCtrl,
              autofocus: true,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: AppStrings.urlLabel,
                hintText: 'https://',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textCtrl,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: AppStrings.displayTextLabel,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              final url = urlCtrl.text.trim();
              if (url.isEmpty) return;
              final display = textCtrl.text.trim();
              Navigator.pop(ctx);
              _insertLink(url, display);
            },
            child: const Text(AppStrings.insert),
          ),
        ],
      ),
    ).then((_) {
      urlCtrl.dispose();
      textCtrl.dispose();
    });
  }

  void _insertLink(String url, String displayText) {
    final linkText =
        displayText.isNotEmpty ? '[$displayText]($url)' : url;
    final sel = _bodyController.selection;
    final pos =
        sel.isValid ? sel.baseOffset : _bodyController.text.length;
    final current = _bodyController.text;
    _bodyController.value = TextEditingValue(
      text: current.substring(0, pos) +
          linkText +
          current.substring(pos),
      selection: TextSelection.collapsed(offset: pos + linkText.length),
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
                  Text(AppStrings.messageSent),
                ],
              ),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        } else if (state is EmailSendFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.isNotEmpty
                  ? state.message
                  : AppStrings.sendFailed),
              backgroundColor: AppColors.error,
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
            title: const Text(AppStrings.newMessage),
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
                  tooltip: AppStrings.send,
                  onPressed: _sendEmail,
                ),
            ],
          ),
          body: Column(
            children: [
              const Divider(height: 1),
              ComposeField(
                prefix: AppStrings.from,
                child: Text(
                  fromEmail,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Divider(height: 1),
              ComposeField(
                prefix: AppStrings.to,
                child: TextField(
                  controller: _toController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: AppStrings.recipients,
                    hintStyle: TextStyle(color: AppColors.textHint),
                  ),
                ),
              ),
              const Divider(height: 1),
              ComposeField(
                prefix: AppStrings.subject,
                child: TextField(
                  controller: _subjectController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TextStyle(color: AppColors.textHint),
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
                      hintText: AppStrings.composeHint,
                      hintStyle: TextStyle(color: AppColors.textHint),
                    ),
                  ),
                ),
              ),
              // Attachments list
              if (_attachments.isNotEmpty) _AttachmentsList(
                attachments: _attachments,
                onRemove: (a) => setState(() => _attachments.remove(a)),
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
                  top: BorderSide(color: AppColors.divider, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.attach_file),
                        if (_attachments.isNotEmpty)
                          Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${_attachments.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    tooltip: AppStrings.attachFile,
                    onPressed: isSending ? null : _pickFiles,
                  ),
                  IconButton(
                    icon: const Icon(Icons.link),
                    tooltip: AppStrings.insertLink,
                    onPressed: isSending ? null : _showInsertLinkDialog,
                  ),
                  const Spacer(),
                  TextButton.icon(
                    icon: const Icon(Icons.send, size: 18),
                    label: const Text(AppStrings.send),
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

class _AttachmentsList extends StatelessWidget {
  final List<_Attachment> attachments;
  final ValueChanged<_Attachment> onRemove;

  const _AttachmentsList({
    required this.attachments,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 140),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: attachments.length,
        itemBuilder: (_, i) => _AttachmentChip(
          attachment: attachments[i],
          onRemove: () => onRemove(attachments[i]),
        ),
      ),
    );
  }
}

class _AttachmentChip extends StatelessWidget {
  final _Attachment attachment;
  final VoidCallback onRemove;

  const _AttachmentChip({
    required this.attachment,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(attachment.icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              attachment.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            attachment.sizeLabel,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close,
                size: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}