import 'package:complete_advanced_flutter/app/extensions.dart';
import 'package:complete_advanced_flutter/data/responses/responses.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';

const EMPTY = "";
const ZERO = 0;

extension CustomerResponseMapper on CustomerResponse {
  Customer toDomain() {
    return Customer(
      id.orEmpty() ?? EMPTY,
      name.orEmpty(),
      numberOfNotification.orZero() ?? ZERO,
    );
  }
}

extension ContactsResponseMapper on ContactsResponse {
  Contacts toDomain() {
    return Contacts(
      phone.orEmpty() ?? EMPTY,
      link.orEmpty() ?? EMPTY,
      email.orEmpty() ?? EMPTY,
    );
  }
}

extension AuthenticationResponseMapper on AuthenticationResponse {
  Authentication toDomain() {
    return Authentication(
      customer!.toDomain(),
      contacts!.toDomain(),
    );
  }
}
