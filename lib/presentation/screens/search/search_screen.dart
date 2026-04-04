import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/email.dart';
import '../../blocs/email/email_cubit.dart';
import '../../blocs/email/email_state.dart';
import '../../widgets/email_tile.dart';
import '../../widgets/sender_avatar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  List<Email> _results = [];
  bool _hasSearched = false;

  // TODO: add debounce so we don't filter on every keystroke

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim().toLowerCase();
    print('search: $q');

    setState(() {
      _query = q;
      _hasSearched = q.isNotEmpty;
    });
  }

  List<Email> _filterEmails(List<Email> emails) {
    if (_query.isEmpty) {
      return [];
    }

    var filtered = emails.where((e) {
      bool a = e.subject.toLowerCase().contains(_query);
      bool b = e.senderName.toLowerCase().contains(_query);
      bool c = e.preview.toLowerCase().contains(_query);
      return a || b || c;
    }).toList();

    filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return filtered;
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // was going to show result count but didn't finish
  Widget _buildResultCount() {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
          title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search mail',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[500]),
            contentPadding: EdgeInsets.zero,
          ),
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
        ],
      ),
      body: BlocBuilder<EmailCubit, EmailState>(
        builder: (context, state) {
          if (state is! EmailLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          _results = _filterEmails(state.allEmails);

          if (!_hasSearched) {
            return _buildEmptySearch();
          }

          if (_results.isEmpty) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No results for "$_query"',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ]),
            );
          }

          return Column(
            children: [
              _buildResultCount(),
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (ctx, index) {
                    final email = _results[index];
                    return EmailTile(
                      email: email,
                      onTap: () => context.push('/email/${email.id}'),
                      onStarToggle: () {
                        context.read<EmailCubit>().toggleStar(email.id);
                      },
                      onDelete: () {},
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptySearch() {
    // TODO: show recent search history here
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text('Search your mail',
              style: TextStyle(fontSize: 18, color: Colors.grey[500])),
          const SizedBox(height: 4),
          Text('Try searching by sender or subject',
              style: TextStyle(fontSize: 13, color: Colors.grey[400])),
        ],
      ),
    );
  }
}