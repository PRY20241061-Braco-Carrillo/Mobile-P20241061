class Roles {
//  static const String admin = "ROLE_ADMIN";
//  static const String waiter = "ROLE_WAITER";
//  static const String chef = "ROLE_CHEF";
  static const String client = "ROLE_CLIENT";
}

class ResponseCodes {
  static const Map<String, String> codes = <String, String>{
    "DEFAULT_ERROR": "An unexpected error occurred.",
    "BAD_REQUEST": "Bad request. Please check your data.",
    "UNAUTHORIZED": "Unauthorized access.",
    "FORBIDDEN": "Access forbidden.",
    "NOT_FOUND": "Resource not found.",
    "INTERNAL_SERVER_ERROR": "Internal server error.",
    "SERVICE_UNAVAILABLE": "Service currently unavailable.",
    "GATEWAY_TIMEOUT": "Gateway timeout error.",
    "CONFLICT": "Data conflict error.",
    "NOT_IMPLEMENTED": "Not implemented error.",
    "BAD_GATEWAY": "Bad gateway error.",
    "UNKNOWN_ERROR": "Unknown error occurred.",
    "CREATED": "Operation Successful: Created.",
    "UPDATED": "Operation Successful: Updated.",
    "DELETED": "Operation Successful: Deleted.",
    "SUCCESS": "Operation Successful.",
  };

  static String getMessage(String code) {
    return codes[code] ?? codes["UNKNOWN_ERROR"]!;
  }
}
