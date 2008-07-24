package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import org.tuskit.business.MeetingParticipantDelegate;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.components.admin_box.AdminState;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import org.tuskit.model.User;
    import org.tuskit.model.Meeting;
    import org.tuskit.model.MeetingParticipant;
    
    
    public class ListMeetingParticipantsCommand implements ICommand, IResponder {

	    private var _meeting:Meeting;

        public function ListMeetingParticipants():void {    
        }

        public function execute(event : CairngormEvent) : void {
        	_meeting = event.data;
            var delegate : MeetingParticipantDelegate = new MeetingParticipantDelegate(this);
            delegate.listMeetingParticipants(_meeting);
        }

        public function result(event : Object) : void {
            var result:XMLList = XMLList(event.result).children();
            var model : TuskitModelLocator = TuskitModelLocator.getInstance();
 			model.setMeetingParticipants(result);
 			model.isInTransitionState = false;
        }
    
        public function fault(event : Object) : void {
            //tuskit.debug("CreateSessionCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Cannot get list of meeting participants");
        }
    }
}