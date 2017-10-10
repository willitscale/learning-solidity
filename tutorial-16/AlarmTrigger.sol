pragma solidity ^0.4.0;

interface AlarmWakeUp {
    function callback(bytes _data) public;
}

contract AlarmService {
    
    struct TimeEvent {
        address addr;
        bytes data;
    }
    
    mapping(uint => TimeEvent[]) private _events;
    
    function set(uint _time) 
        public 
        returns (bool) {
        TimeEvent _timeEvent;
        _timeEvent.addr = msg.sender;
        _timeEvent.data = msg.data;
        _events[_time].push(_timeEvent);
    }
    
    function call(uint _time) 
        public {
        TimeEvent[] timeEvents = _events[_time];
        for(uint i = 0; i < timeEvents.length; i++) {
            AlarmWakeUp(timeEvents[i].addr).callback(timeEvents[i].data);
        }
    }
}

contract AlarmTrigger is AlarmWakeUp {
    
    AlarmService private _alarmService;
    
    function AlarmTrigger() {
        _alarmService = new AlarmService();
    }
    
    function callback(bytes _data) 
        public {
        // Do something
    }
    
    function setAlarm() 
        public {
        _alarmService.set(block.timestamp+60);
    }
    
}