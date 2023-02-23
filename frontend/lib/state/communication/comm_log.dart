class CommunicationLog {
  static final CommunicationLog _instance = CommunicationLog._internal();
  CommunicationLog._internal();
  factory CommunicationLog() => _instance;
}
