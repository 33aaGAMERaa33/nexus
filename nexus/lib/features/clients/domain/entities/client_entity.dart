import 'package:flutter/material.dart';

enum PurchaseStatus { 
  purchased(
    value: "purchased", 
    translate: "Comprou",
    textColor: Color(0xFF60EA93),
    containerColor: Color(0xFF064425),
  ), 

  noResponse(
    value: "no_response", 
    translate: "Sem resposta",
    textColor: Color(0xFFF99E2B),
    containerColor: Color(0xFF3F3201),
  ), 

  notPurchased(
    value: "not_purchased", 
    translate: "Não comprou",
    textColor: Color(0xFFC11302),
    containerColor: Color(0xFF430202),
  );

  final String value;
  final Color textColor;
  final String translate;
  final Color containerColor;

  const new({
    required this.value, 
    required this.translate,
    required this.textColor,
    required this.containerColor
  });
}

class ClientEntity {
  final String uuid;

  final String name;
  final String phone;

  final PurchaseStatus purchaseStatus;
  
  final DateTime createdAt;
  final DateTime updatedAt;

  const new({
    required this.uuid, 
    required this.name, 
    required this.phone, 
    required this.createdAt, 
    required this.updatedAt,
    required this.purchaseStatus, 
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ClientEntity && uuid == other.uuid;
  }

  @override
  int get hashCode => uuid.hashCode;
}