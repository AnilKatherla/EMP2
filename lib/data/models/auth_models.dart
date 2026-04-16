class LoginRequest {
  final String identifier;
  final String password;

  LoginRequest({required this.identifier, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'password': password,
    };
  }
}

class LoginResponse {
  final String token;
  final String userId;
  final String message;

  LoginResponse({
    required this.token,
    required this.userId,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      userId: json['userId'],
      message: json['message'],
    );
  }
}

class ForgotPasswordRequest {
  final String identifier;

  ForgotPasswordRequest({required this.identifier});

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
    };
  }
}

class ForgotPasswordResponse {
  final String message;
  final String otpId; // For tracking OTP session

  ForgotPasswordResponse({
    required this.message,
    required this.otpId,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      message: json['message'],
      otpId: json['otpId'],
    );
  }
}

class VerifyOtpRequest {
  final String identifier;
  final String otp;

  VerifyOtpRequest({required this.identifier, required this.otp});

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'otp': otp,
    };
  }
}

class VerifyOtpResponse {
  final String token;
  final String message;

  VerifyOtpResponse({
    required this.token,
    required this.message,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      token: json['token'],
      message: json['message'],
    );
  }
}

class ChangePasswordRequest {
  final String newPassword;

  ChangePasswordRequest({required this.newPassword});

  Map<String, dynamic> toJson() {
    return {
      'newPassword': newPassword,
    };
  }
}

class ChangePasswordResponse {
  final String message;

  ChangePasswordResponse({required this.message});

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      message: json['message'],
    );
  }
}

/// Convenience model used by OTPScreen to pass OTP data to the ViewModel.
class OTPModel {
  final String email;
  final String otp;

  OTPModel({required this.email, required this.otp});
}

/// Convenience model used by ResetPasswordScreen to pass data to the ViewModel.
class ResetPasswordModel {
  final String email;
  final String newPassword;

  ResetPasswordModel({required this.email, required this.newPassword});
}