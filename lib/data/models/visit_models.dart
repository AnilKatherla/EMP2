class VisitRequest {
  final String storeName;
  final String ownerName;
  final String mobileNumber;
  final String visitType;
  final String status;
  final Map<String, double>? gps;
  final String? notes;
  final String? address;
  final String? city;
  final String? state;
  final String? pinCode;
  final Map<String, bool>? milestones;
  final List<String>? photos;
  final Map<String, dynamic>? visitForm;

  VisitRequest({
    required this.storeName,
    required this.ownerName,
    required this.mobileNumber,
    required this.visitType,
    required this.status,
    this.gps,
    this.notes,
    this.address,
    this.city,
    this.state,
    this.pinCode,
    this.milestones,
    this.photos,
    this.visitForm,
  });

  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'ownerName': ownerName,
      'mobileNumber': mobileNumber,
      'visitType': visitType,
      'status': status,
      if (gps != null) 'gps': gps,
      if (notes != null) 'notes': notes,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (pinCode != null) 'pinCode': pinCode,
      if (milestones != null) 'milestones': milestones,
      if (photos != null) 'photos': photos,
      if (visitForm != null) ...visitForm!,
    };
  }
}

class VisitResponse {
  final String id;
  final String storeName;
  final String status;
  final String visitType;
  final DateTime timestamp;
  final String? city;
  final String? address;
  final List<String> photos;

  VisitResponse({
    required this.id,
    required this.storeName,
    required this.status,
    required this.visitType,
    required this.timestamp,
    this.city,
    this.address,
    this.photos = const [],
  });

  factory VisitResponse.fromJson(Map<String, dynamic> json) {
    return VisitResponse(
      id: json['_id'] ?? '',
      storeName: json['storeName'] ?? 'Unknown Store',
      status: json['status'] ?? 'pending',
      visitType: json['visitType'] ?? 'store',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : (json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now()),
      city: json['city'],
      address: json['address'],
      photos: json['photos'] != null ? List<String>.from(json['photos']) : [],
    );
  }
}

class FollowUpResponse {
  final String id;
  final String storeName;
  final String ownerName;
  final String? mobileNumber;
  final String? address;
  final String status;
  final String priority;
  final DateTime nextFollowUpDate;
  final String reason;

  FollowUpResponse({
    required this.id,
    required this.storeName,
    required this.ownerName,
    this.mobileNumber,
    this.address,
    required this.status,
    required this.priority,
    required this.nextFollowUpDate,
    required this.reason,
  });

  factory FollowUpResponse.fromJson(Map<String, dynamic> json) {
    return FollowUpResponse(
      id: json['_id'] ?? '',
      storeName: json['storeName'] ?? 'Unknown',
      ownerName: json['ownerName'] ?? 'Unknown',
      mobileNumber: json['mobileNumber'],
      address: json['address'],
      status: json['status'] ?? 'pending',
      priority: json['priority'] ?? 'medium',
      nextFollowUpDate: json['nextFollowUpDate'] != null 
          ? DateTime.parse(json['nextFollowUpDate']) 
          : DateTime.now().add(const Duration(days: 3)),
      reason: json['reason'] ?? 'Routine follow-up',
    );
  }
}
