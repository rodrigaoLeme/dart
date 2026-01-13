class CepModel {
  final String? objectId;
  final String cep;
  final String? logradouro;
  final String? complemento;
  final String? bairro;
  final String localidade;
  final String uf;

  const CepModel({
    required this.cep,
    required this.uf,
    required this.localidade,
    this.objectId,
    this.complemento,
    this.logradouro,
    this.bairro,
  });

  factory CepModel.empty() => const CepModel(cep: '', uf: '', localidade: '');

  factory CepModel.fromJson(Map<String, dynamic> json) => CepModel(
        cep: json['cep'] as String,
        logradouro: json['logradouro'] as String?,
        bairro: json['bairro'] as String?,
        localidade: json['localidade'] as String,
        uf: json['uf'] as String,
        objectId: json['objectId'] as String?,
        complemento: json['complemento'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'objectId': objectId,
        'cep': cep,
        'logradouro': logradouro,
        'complemento': complemento,
        'bairro': bairro,
        'localidade': localidade,
        'uf': uf,
      };

  CepModel copyWith({
    String? cep,
    String? logradouro,
    String? bairro,
    String? localidade,
    String? uf,
    String? objectId,
    String? complemento,
  }) {
    return CepModel(
      objectId: objectId ?? this.objectId,
      cep: cep ?? this.cep,
      logradouro: logradouro ?? this.logradouro,
      bairro: bairro ?? this.bairro,
      complemento: complemento ?? this.complemento,
      localidade: localidade ?? this.localidade,
      uf: uf ?? this.uf,
    );
  }
}
