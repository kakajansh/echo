///
/// Event name formatter
///
class EventFormatter {
  /// Event namespace.
  dynamic namespace;

  /// Create a new class instance.
  EventFormatter (dynamic namespace) {
    this.setNamespace(namespace);
  }

  /// Format the given event name.
  String format(String event) {
    if (event.substring(0, 1) == '.' || event.substring(0, 1) == '\\') {
      return event.substring(1);
    } else if (this.namespace != null) {
      event = this.namespace + '.' + event;
    }

    return event.replaceAll(new RegExp(r'\.'), '\\');
  }

  /// Set the event namespace.
  void setNamespace(dynamic value) {
    this.namespace = value;
  }
}