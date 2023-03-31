/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5

/// Login Exceptions
class UserNotFoundAuthException implements Exception {}
/// Wrong Password Exceptions
class WrongPasswordAuthException implements Exception {}

/// Register Exceptions
class WeakPasswordAuthException implements Exception {}
/// Account Use Exceptions
class EmailAlreadyInUseAuthException implements Exception {}
/// Invalid Email Authenticate Exceptions
class InvalidEmailAuthException implements Exception {}
/// Photo Not Update Exceptions
class PhotoNotUpdatedException implements Exception {}
/// Display Name Not Updated Exception
class DisplayNameNotUpdatedException implements Exception {}

/// Generic Exceptions
class GenericAuthException implements Exception {}
/// User Not logged In Exceptions
class UserNotLoggedInAuthException implements Exception {}
