class BadRequestException implements Exception {
  String? desc;

  BadRequestException([this.desc]);
}

class UnauthorizedException implements Exception {}

class NotFoundException implements Exception {}

class InternalServerErrorException implements Exception {}
