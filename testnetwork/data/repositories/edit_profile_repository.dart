

import '../../core/network/api_response.dart';
import '../../core/network/dio_service.dart';
import '../../core/network/error_handler.dart';
import '../../core/network/network_config.dart';
import '../models/rating_model.dart';
import '../models/user_model.dart';

/// Repository for handling profile-related operations
class EditProfileRepository {
  final DioService _dioService;

  EditProfileRepository(this._dioService);

  /// Get supplier ratings with comprehensive error handling
  Future<NetworkResult<RatingModel>> getSupplierRates(String supplierId) async {
    try {
      final response = await _dioService.get<RatingModel>(
        url: "order_reviews",
        queryParameters: {'supplier_id': supplierId},
        parser: (json) => RatingModel.fromJson(json['data']),
        config: const RequestConfig(
          loading: true,
          enableCache: true,
          cacheDuration: Duration(minutes: 10),
        ),
      );

      return response.fold(
        onSuccess: (data) => NetworkResult.success(data),
        onError: (error) => NetworkResult.failure(error),
      );
    } catch (e, stackTrace) {
      final networkException = NetworkErrorHandler.handleGeneralException(e, stackTrace);
      return NetworkResult.failure(networkException);
    }
  }

  /// Get user profile with error handling
  Future<NetworkResult<UserModel>> getProfile() async {
    try {
      final response = await _dioService.get<UserModel>(
        url: "get-profile",
        parser: (json) => UserModel.fromJson(json['data']),
        config: const RequestConfig(
          enableCache: true,
          cacheDuration: Duration(minutes: 5),
        ),
      );

      return response.fold(
        onSuccess: (data) => NetworkResult.success(data),
        onError: (error) => NetworkResult.failure(error),
      );
    } catch (e, stackTrace) {
      final networkException = NetworkErrorHandler.handleGeneralException(e, stackTrace);
      return NetworkResult.failure(networkException);
    }
  }

  /// Edit user profile with comprehensive error handling
  Future<NetworkResult<UserModel>> editProfile(UserModel userModel) async {
    try {
      final body = await userModel.toJson();
      
      final response = await _dioService.post<UserModel>(
        url: "edit-profile",
        body: body,
        parser: (json) => UserModel.fromJson(json['data']),
        config: const RequestConfig(
          loading: true,
          isForm: true,
          enableRetry: true,
          maxRetries: 2,
        ),
      );

      return response.fold(
        onSuccess: (data) => NetworkResult.success(data),
        onError: (error) => NetworkResult.failure(error),
      );
    } catch (e, stackTrace) {
      final networkException = NetworkErrorHandler.handleGeneralException(e, stackTrace);
      return NetworkResult.failure(networkException);
    }
  }

  /// Confirm mobile/email with OTP
  Future<NetworkResult<bool>> confirmMobileEmail({
    required String otp,
    String? email,
    String? phone,
  }) async {
    try {
      final response = await _dioService.post<bool>(
        url: "verify-profile-update-otp",
        body: {
          "otp": otp,
          if (email != null) "email": email,
          if (phone != null) "personal_phone": phone,
        },
        parser: (json) => json['status'] == true,
        config: const RequestConfig(
          loading: true,
          isForm: true,
        ),
      );

      return response.fold(
        onSuccess: (data) => NetworkResult.success(data),
        onError: (error) => NetworkResult.failure(error),
      );
    } catch (e, stackTrace) {
      final networkException = NetworkErrorHandler.handleGeneralException(e, stackTrace);
      return NetworkResult.failure(networkException);
    }
  }

  /// Verify new password with code
  Future<NetworkResult<bool>> verifyNewPassword(String code) async {
    try {
      final response = await _dioService.post<bool>(
        url: "password/reset",
        body: {"code": code},
        parser: (json) => json['status'] == true,
        config: const RequestConfig(
          loading: true,
          isForm: true,
        ),
      );

      return response.fold(
        onSuccess: (data) => NetworkResult.success(data),
        onError: (error) => NetworkResult.failure(error),
      );
    } catch (e, stackTrace) {
      final networkException = NetworkErrorHandler.handleGeneralException(e, stackTrace);
      return NetworkResult.failure(networkException);
    }
  }
}

/// Extension methods for easier error handling in UI
extension NetworkResultExtensions<T> on NetworkResult<T> {
  /// Handle the result with success and error callbacks
  void handle({
    required void Function(T data) onSuccess,
    required void Function(NetworkException error) onError,
  }) {
    fold(
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// Get data or null if error
  T? get dataOrNull => isSuccess ? data : null;

  /// Get error message or null if success
  String? get errorMessage => isSuccess ? null : error?.message;

  /// Check if error should trigger logout
  bool get shouldLogout => !isSuccess && error != null && NetworkErrorHandler.shouldLogout(error!);
}

/// Extension methods for ApiResponse
extension ApiResponseExtensions<T> on ApiResponse<T> {
  /// Convert ApiResponse to NetworkResult
  NetworkResult<T> toNetworkResult() {
    if (isSuccess && data != null) {
      return NetworkResult.success(data!);
    } else {
      return NetworkResult.failure(error!);
    }
  }

  /// Fold pattern for ApiResponse
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(NetworkException error) onError,
  }) {
    if (isSuccess && data != null) {
      return onSuccess(data!);
    } else {
      return onError(error!);
    }
  }
}

