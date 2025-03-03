enum OrderStatus {
  postado,
  disponivelRetirada,
  emPreparo,
  rotaEntrega,
  entregue,
  devolvido,
  ausente;

  String get value {
    switch (this) {
      case OrderStatus.postado:
        return 'POSTADO';
      case OrderStatus.disponivelRetirada:
        return 'DISPONIVEL_RETIRADA';
      case OrderStatus.emPreparo:
        return 'EM_PREPARO';
      case OrderStatus.rotaEntrega:
        return 'ROTA_ENTREGA';
      case OrderStatus.entregue:
        return 'ENTREGUE';
      case OrderStatus.devolvido:
        return 'DEVOLVIDO';
      case OrderStatus.ausente:
        return 'AUSENTE';
    }
  }
}
