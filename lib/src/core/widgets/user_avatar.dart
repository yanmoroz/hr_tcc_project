import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:shimmer/shimmer.dart';

import '../base_types/result.dart';
import '../di/service_locator.dart';
import '../files/files_service.dart';
import '../theme/theme.dart';
import '../utils/color_utils.dart';
import '../utils/string_utils.dart';
import '../value_objects/system_type.dart';
import '../value_objects/tcc_image_destination_type.dart';

/// Cache for user profile photos.
///
/// Stores downloaded photos and deduplicates in-flight requests.
class UserPhotoCache {
  UserPhotoCache._();

  static final UserPhotoCache instance = UserPhotoCache._();

  final Map<String, Uint8List> _cache = {};
  final Map<String, Future<Result<Uint8List>>> _pendingRequests = {};
  final Set<String> _failedKeys = {};

  /// Generates a cache key from parameters.
  static String _buildKey({
    required SystemType systemType,
    required String userId,
    String? uriFile,
  }) {
    return '${systemType.value}:$userId:${uriFile ?? ''}';
  }

  /// Gets a cached photo or fetches it if not cached.
  ///
  /// Returns cached result immediately if available.
  /// Deduplicates concurrent requests for the same photo.
  Future<Result<Uint8List>> getOrFetch({
    required SystemType systemType,
    required String userId,
    String? uriFile,
  }) async {
    final key = _buildKey(
      systemType: systemType,
      userId: userId,
      uriFile: uriFile,
    );

    // Return cached photo if available
    if (_cache.containsKey(key)) {
      return Right(_cache[key]!);
    }

    // Return error for previously failed requests
    if (_failedKeys.contains(key)) {
      return Left(Exception('Photo not available'));
    }

    // Return existing pending request if one is in progress
    if (_pendingRequests.containsKey(key)) {
      return _pendingRequests[key]!;
    }

    // Start new request
    final future = sl<FilesService>().downloadFile(
      systemType: systemType,
      download: false,
      imageDestination: TccImageDestinationType.person,
      destinationId: userId,
      uriFile: uriFile,
    ).then((result) {
      _pendingRequests.remove(key);
      result.fold(
        (error) => _failedKeys.add(key),
        (bytes) => _cache[key] = bytes,
      );
      return result;
    });

    _pendingRequests[key] = future;
    return future;
  }

  /// Clears all cached photos and failed markers.
  void clear() {
    _cache.clear();
    _pendingRequests.clear();
    _failedKeys.clear();
  }

  /// Removes a specific user's cached photo.
  void invalidate({
    required SystemType systemType,
    required String userId,
    String? uriFile,
  }) {
    final key = _buildKey(
      systemType: systemType,
      userId: userId,
      uriFile: uriFile,
    );
    _cache.remove(key);
    _failedKeys.remove(key);
  }
}

/// Creates a future to download a user's profile photo with caching.
///
/// Returns null if [photoExists] is false or [userId] is null.
/// Uses [UserPhotoCache] to cache results and deduplicate requests.
Future<Result<Uint8List>>? createUserPhotoFuture({
  required SystemType systemType,
  required bool photoExists,
  required String? userId,
  String? uriFile,
}) {
  if (!photoExists || userId == null) return null;

  return UserPhotoCache.instance.getOrFetch(
    systemType: systemType,
    userId: userId,
    uriFile: uriFile,
  );
}

/// A circular avatar widget that displays a user photo or initials.
///
/// Shows shimmer loading state while fetching photo, displays the photo
/// if available, or falls back to initials with colored background.
class UserAvatar extends StatefulWidget {
  /// The initials to display when no photo is available.
  final String initials;

  /// Identifier used to determine the background color.
  final String colorIdentifier;

  /// The radius of the avatar. Defaults to 20.
  final double radius;

  /// Future that resolves to the photo bytes.
  /// If null, only initials are shown.
  final Future<Result<Uint8List>>? photoFuture;

  const UserAvatar({
    super.key,
    required this.initials,
    required this.colorIdentifier,
    this.radius = 20,
    this.photoFuture,
  });

  /// Creates an avatar from a full name string.
  ///
  /// Uses the [fullName] as both the source for initials and the color identifier.
  factory UserAvatar.fromFullName({
    Key? key,
    required String fullName,
    double radius = 20,
    Future<Result<Uint8List>>? photoFuture,
  }) {
    return UserAvatar(
      key: key,
      initials: getInitialsFromFullName(fullName),
      colorIdentifier: fullName,
      radius: radius,
      photoFuture: photoFuture,
    );
  }

  /// Creates an avatar from first and last name.
  ///
  /// Uses the [id] as the color identifier for consistent coloring.
  factory UserAvatar.fromName({
    Key? key,
    required String firstName,
    required String lastName,
    required String id,
    double radius = 20,
    Future<Result<Uint8List>>? photoFuture,
  }) {
    return UserAvatar(
      key: key,
      initials: getInitials(firstName, lastName),
      colorIdentifier: id,
      radius: radius,
      photoFuture: photoFuture,
    );
  }

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  Uint8List? _photoBytes;
  bool _isLoading = false;

  TextStyle get _textStyle {
    if (widget.radius >= 20) {
      return AppTypography.textSemibold1.white;
    }
    return AppTypography.textSemibold2.white;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildShimmer();
    }

    if (_photoBytes != null) {
      return _buildPhotoAvatar();
    }

    return _buildInitialsAvatar();
  }

  @override
  void didUpdateWidget(UserAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoFuture != widget.photoFuture) {
      _loadPhoto();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPhoto();
  }

  Widget _buildInitialsAvatar() {
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: getAvatarColor(widget.colorIdentifier),
      child: Text(widget.initials, style: _textStyle),
    );
  }

  Widget _buildPhotoAvatar() {
    return CircleAvatar(
      radius: widget.radius,
      backgroundImage: MemoryImage(_photoBytes!),
      backgroundColor: getAvatarColor(widget.colorIdentifier),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.grey200,
      highlightColor: AppColors.grey100,
      child: Container(
        width: widget.radius * 2,
        height: widget.radius * 2,
        decoration: BoxDecoration(
          color: AppColors.grey200,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Future<void> _loadPhoto() async {
    if (widget.photoFuture == null) {
      setState(() {
        _isLoading = false;
        _photoBytes = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await widget.photoFuture!;

    if (!mounted) return;

    result.fold(
      (error) {
        setState(() {
          _isLoading = false;
          _photoBytes = null;
        });
      },
      (bytes) {
        setState(() {
          _isLoading = false;
          _photoBytes = bytes;
        });
      },
    );
  }
}
