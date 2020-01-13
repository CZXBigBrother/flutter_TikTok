typedef void EventCallback(arg);

class EventBusService {
  EventBusService._internal();
  static EventBusService _singleton = EventBusService._internal();
  factory EventBusService() => _singleton;
  var _emap = Map<Object, List<EventCallback>>();

  //添加订阅者
  void on(eventName, EventCallback f) {
    if (eventName == null || f == null) return;
    _emap[eventName] ??= List<EventCallback>();
    _emap[eventName].add(f);
  }

  //移除订阅者
  void off(eventName, [EventCallback f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  //触发事件，事件触发后该事件所有订阅者会被调用
  void emit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }

  // static const keyStopVideo = "keyStopVideo";
}

var eventBus = EventBusService();

const String keyStopVideo = "keyStopVideo";
const String keyPlayVideo = "keyPlayVideo";
const String keyLoginState = "keyLoginState";
