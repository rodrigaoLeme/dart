Map<String, dynamic> convertToMap(dynamic data) {
  return {
    'objectId': data['objectId'].toString(),
    'cep': data['cep'].toString(),
    'logradouro': data['logradouro'].toString(),
    'complemento': data['complemento'].toString(),
    'bairro': data['bairro'].toString(),
    'localidade': data['localidade'].toString(),
    'uf': data['uf'].toString(),
    'createdAt': data['createdAt'].toString(),
    'updatedAt': data['updatedAt'].toString()
  };
}

Map<String, dynamic> convertToMap2(dynamic data) {
  return {
    'cep': data['cep'] as String,
    'logradouro': data['logradouro'] as String?,
    'complemento': data['complemento'] as String?,
    'bairro': data['bairro'] as String?,
    'localidade': data['localidade'] as String,
    'uf': data['uf'] as String
  };
}

Map<String, dynamic> hasErrorAsMap() {
  return {'error': true};
}

bool cepExists(Map<String, dynamic> json) {
  final hasError = json['error'];

  if (hasError == true) {
    return false;
  }

  return true;
}

String formatCep(String cep) {
  try {
    var firstFiveNumber = cep.substring(0, 5);
    var lastThreeNumber = cep.substring(5);
    var formattedCep = '$firstFiveNumber-$lastThreeNumber';

    return formattedCep;
  } on RangeError {
    throw const FormatException('O CEP deve ter 8 caracteres!');
  }
}
