import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';
import '../models/repo_model.dart';

class RepoService {
  final SupabaseClient _client = SupabaseService.client;

  /// Fetch repos for feed (paginated)
  Future<List<RepoModel>> fetchFeed({
    int page = 1,
    int pageSize = 10,
    List<String>? techFilter,
    String? difficulty,
    String? size,
  }) async {
    try {
      var query = _client
          .from('repositories')
          .select()
          .order('stars', ascending: false)
          .range((page - 1) * pageSize, page * pageSize - 1);

      final response = await query;
      return (response as List)
          .map((json) => RepoModel.fromJson(json))
          .toList();
    } catch (e) {
      return _fetchFromGitHubApi(page, pageSize, techFilter, difficulty, size);
    }
  }

  Future<List<RepoModel>> _fetchFromGitHubApi(int page, int pageSize, List<String>? techFilter, String? difficulty, String? size) async {
    try {
      final token = dotenv.env['GITHUB_API_TOKEN'];
      final Map<String, String> headers = {
        'Accept': 'application/vnd.github.v3+json',
      };
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token'; // Removed 'token ' prefix as 'Bearer ' is standard, but GitHub accepts 'token ' or 'Bearer '
      }

      // Build search query with filters
      String q = '';
      
      // Parse Size
      if (size == '<1K Stars') {
        q += 'stars:<1000';
      } else if (size == '1K-10K Stars') {
        q += 'stars:1000..10000';
      } else if (size == '>10K Stars') {
        q += 'stars:>10000';
      } else {
        q += 'stars:>500'; // Default baseline
      }

      // Parse Tech Stack
      if (techFilter != null && techFilter.isNotEmpty) {
        q += ' language:${techFilter.first}';
      }

      // Parse Difficulty (using labels as heuristics)
      if (difficulty == 'Beginner') {
        q += ' label:"good first issue"';
      } else if (difficulty == 'Intermediate') {
        q += ' label:"help wanted"';
      }

      final url = Uri.parse(
          'https://api.github.com/search/repositories?q=$q&sort=stars&order=desc&per_page=$pageSize&page=$page');
      
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;
        
        return items.map((item) {
          return RepoModel(
            id: item['id'].toString(),
            name: item['name'] ?? '',
            owner: item['owner']['login'] ?? '',
            description: item['description'] ?? 'No description provided.',
            longDescription: null,
            stars: item['stargazers_count'] ?? 0,
            forks: item['forks_count'] ?? 0,
            watchers: item['watchers_count'] ?? 0,
            techStack: item['language'] != null ? [item['language']] : [],
            isVerified: false,
            isPublic: !(item['private'] ?? false),
            license: item['license']?['name'],
            version: item['default_branch'],
            commitGrowth: null,
            githubUrl: item['html_url'],
          );
        }).toList();
      } else {
        return _getDemoRepos();
      }
    } catch (_) {
      return _getDemoRepos();
    }
  }
  Future<RepoModel?> fetchById(String id) async {
    try {
      final response = await _client
          .from('repositories')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (response != null) return RepoModel.fromJson(response);
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Save repo to user's saved list
  Future<void> saveRepo(String userId, String repoId) async {
    try {
      await _client.from('saved_items').insert({
        'user_id': userId,
        'item_id': repoId,
        'item_type': 'repo',
      });
    } catch (e) {
      // silently fail
    }
  }

  /// Remove repo from saved list
  Future<void> unsaveRepo(String userId, String repoId) async {
    try {
      await _client
          .from('saved_items')
          .delete()
          .eq('user_id', userId)
          .eq('item_id', repoId);
    } catch (e) {
      // silently fail
    }
  }

  /// Get saved repos for user
  Future<List<RepoModel>> getSavedRepos(String userId) async {
    try {
      final response = await _client
          .from('saved_items')
          .select('item_id, repositories(*)')
          .eq('user_id', userId)
          .eq('item_type', 'repo');
      return (response as List)
          .map((json) => RepoModel.fromJson(json['repositories']))
          .toList();
    } catch (e) {
      return _getDemoSaved();
    }
  }

  // Demo data for testing without Supabase
  static List<RepoModel> _getDemoRepos() {
    return [
      RepoModel(
        id: '1',
        name: 'react',
        owner: 'facebook',
        description: 'The library for web and native user interfaces',
        longDescription: 'React lets you build user interfaces out of individual pieces called components. Create your own React components like Thumbnail, LikeButton, and Video. Then combine them into entire screens, pages, and apps.',
        stars: 214000,
        forks: 44000,
        watchers: 6700,
        techStack: ['React', 'JavaScript'],
        isVerified: true,
        isPublic: true,
        license: 'MIT License',
        version: 'v18.2.0',
        commitGrowth: 12,
        githubUrl: 'https://github.com/facebook/react',
        readmeSnippet: 'React is a JavaScript library for building user interfaces.\n\nDeclarative: React makes it painless to create interactive UIs.',
      ),
      RepoModel(
        id: '2',
        name: 'tensorflow',
        owner: 'tensorflow',
        description: 'An Open Source Machine Learning Framework for Everyone',
        longDescription: 'TensorFlow is an end-to-end open source platform for machine learning. It has a comprehensive, flexible ecosystem of tools, libraries, and community resources.',
        stars: 180000,
        forks: 74000,
        watchers: 8900,
        techStack: ['Python', 'C++', 'CUDA'],
        isVerified: true,
        isPublic: true,
        license: 'Apache-2.0',
        version: 'v2.15.0',
        commitGrowth: 8,
        githubUrl: 'https://github.com/tensorflow/tensorflow',
      ),
      RepoModel(
        id: '3',
        name: 'next.js',
        owner: 'vercel',
        description: 'The React Framework for the Web',
        longDescription: 'Next.js enables you to create full-stack web applications by extending the latest React features, and integrating powerful Rust-based JavaScript tooling.',
        stars: 118000,
        forks: 25000,
        watchers: 1300,
        techStack: ['TypeScript', 'React', 'Rust'],
        isVerified: true,
        isPublic: true,
        license: 'MIT License',
        version: 'v14.1.0',
        commitGrowth: 24,
        githubUrl: 'https://github.com/vercel/next.js',
      ),
      RepoModel(
        id: '4',
        name: 'vscode',
        owner: 'microsoft',
        description: 'Visual Studio Code editor open source repository',
        longDescription: 'Visual Studio Code is a code editor redefined and optimized for building and debugging modern web and cloud applications.',
        stars: 155000,
        forks: 27000,
        watchers: 3300,
        techStack: ['TypeScript', 'JavaScript', 'CSS'],
        isVerified: true,
        isPublic: true,
        license: 'MIT License',
        version: 'v1.86.0',
        commitGrowth: 15,
        githubUrl: 'https://github.com/microsoft/vscode',
      ),
      RepoModel(
        id: '5',
        name: 'flutter',
        owner: 'flutter',
        description: 'Flutter makes it easy to build beautiful apps',
        longDescription: 'Flutter is Google\'s SDK for crafting beautiful, fast user experiences for mobile, web, and desktop from a single codebase.',
        stars: 160000,
        forks: 26000,
        watchers: 3600,
        techStack: ['Dart', 'C++', 'Java'],
        isVerified: true,
        isPublic: true,
        license: 'BSD-3-Clause',
        version: 'v3.19.0',
        commitGrowth: 18,
        githubUrl: 'https://github.com/flutter/flutter',
      ),
      RepoModel(
        id: '6',
        name: 'tailwindcss',
        owner: 'tailwindlabs',
        description: 'A utility-first CSS framework for rapid UI development',
        stars: 76000,
        forks: 3900,
        watchers: 750,
        techStack: ['CSS', 'JavaScript', 'PostCSS'],
        isVerified: true,
        isPublic: true,
        license: 'MIT License',
        version: 'v3.4.1',
        commitGrowth: 10,
        githubUrl: 'https://github.com/tailwindlabs/tailwindcss',
      ),
    ];
  }

  static List<RepoModel> _getDemoSaved() {
    return _getDemoRepos().take(5).toList();
  }
}
