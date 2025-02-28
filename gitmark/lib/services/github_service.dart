import 'package:dio/dio.dart';
import 'dart:io' if (dart.library.html) 'dart:html';
import '../models/repository.dart';
import '../models/content_item.dart';

class GitHubService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.github.com',
    headers: {
      'Accept': 'application/vnd.github.v3+json',
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // 可以添加GitHub令牌来增加API限制
  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'token $token';
  }

  // 检查网络连接状态
  Future<bool> checkNetworkConnection() async {
    try {
      // 使用简单的ping请求检查连接
      final response = await _dio.get('https://api.github.com/zen',
          options: Options(
            validateStatus: (_) => true,
            receiveTimeout: const Duration(seconds: 5),
            sendTimeout: const Duration(seconds: 5),
          ));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // // 获取仓库信息
  Future<Repository> getRepository(String owner, String repo) async {
    try {
      // 首先检查网络连接
      final isConnected = await checkNetworkConnection();
      if (!isConnected) {
        throw Exception('网络连接不可用，请检查您的网络设置');
      }
      
      final response = await _dio.get('/repos/$owner/$repo');
      return Repository.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('连接到GitHub失败: 请检查您的网络连接');
      } else if (e.response != null) {
        if (e.response!.statusCode == 403) {
          throw Exception('API请求限制: 请稍后再试或添加GitHub令牌');
        } else if (e.response!.statusCode == 404) {
          throw Exception('找不到仓库: 请确认仓库地址是否正确');
        }
      }
      throw Exception('获取仓库信息失败: ${e.message}');
    } catch (e) {
      throw Exception('获取仓库信息失败: $e');
    }
  }


  // 获取分支列表
  Future<List<String>> getBranches(String owner, String repo) async {
    if (!await checkNetworkConnection()) {
      throw Exception('Network connection is not available');
    }

    try {
      final response = await _dio.get('/repos/$owner/$repo/branches');
      return (response.data as List)
          .map((branch) => branch['name'] as String)
          .toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('连接到GitHub失败: 请检查您的网络连接和应用权限设置');
      } else if (e.response != null) {
        if (e.response!.statusCode == 403) {
          throw Exception('API请求限制: 请稍后再试或添加GitHub令牌');
        } else if (e.response!.statusCode == 404) {
          throw Exception('找不到仓库: 请确认仓库地址是否正确');
        }
      }
      throw Exception('获取仓库信息失败: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get branches: $e');
    }
  }

  // 获取目录内容
  Future<List<ContentItem>> getContents(
    String owner,
    String repo,
    String path,
    String branch,
  ) async {
    if (!await checkNetworkConnection()) {
      throw Exception('Network connection is not available');
    }
    try {
      String encodedPath = Uri.encodeFull(path);
      final response = await _dio.get(
        '/repos/$owner/$repo/contents/$encodedPath',
        queryParameters: {'ref': branch},
      );
      
      if (response.data is List) {
        return (response.data as List)
            .map((item) => ContentItem.fromJson(item))
            .toList();
      } else {
        // 单个文件的情况
        return [ContentItem.fromJson(response.data)];
      }
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionError) {
          throw Exception('连接到GitHub失败: 请检查您的网络连接和应用权限设置');
        } else if (e.response != null) {
          if (e.response!.statusCode == 403) {
            throw Exception('API请求限制: 请稍后再试或添加GitHub令牌');
          } else if (e.response!.statusCode == 404) {
            throw Exception('找不到仓库: 请确认仓库地址是否正确');
          }
        }
        throw Exception('获取仓库信息失败: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get contents: $e');
    }
  }

  // 获取文件内容
  Future<String> getFileContent(String downloadUrl) async {
    if (!await checkNetworkConnection()) {
      throw Exception('Network connection is not available');
    }
    try {
      final response = await _dio.get(downloadUrl);
      return response.data.toString();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('连接到GitHub失败: 请检查您的网络连接和应用权限设置');
      } else if (e.response != null) {
        if (e.response!.statusCode == 403) {
          throw Exception('API请求限制: 请稍后再试或添加GitHub令牌');
        } else if (e.response!.statusCode == 404) {
          throw Exception('找不到仓库: 请确认仓库地址是否正确');
        }
      }
      throw Exception('获取仓库信息失败: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get file content: $e');
    }
  }

  // 获取README内容
  Future<String> getReadmeContent(
    String owner,
    String repo,
    String branch,
  ) async {
    if (!await checkNetworkConnection()) {
      throw Exception('Network connection is not available');
    }
    try {
      final response = await _dio.get(
        '/repos/$owner/$repo/readme',
        queryParameters: {'ref': branch},
      );
      
      final downloadUrl = response.data['download_url'];
      return await getFileContent(downloadUrl);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('连接到GitHub失败: 请检查您的网络连接和应用权限设置');
      } else if (e.response != null) {
        if (e.response!.statusCode == 403) {
          throw Exception('API请求限制: 请稍后再试或添加GitHub令牌');
        } else if (e.response!.statusCode == 404) {
          throw Exception('找不到仓库: 请确认仓库地址是否正确');
        }
      }
      throw Exception('获取仓库信息失败: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get README: $e');
    }
  }
}