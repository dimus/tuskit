import lib.TuskitLib;
import mx.containers.Canvas;
import org.tuskit.model.Meeting;
import org.tuskit.util.CairngormUtils;
import org.tuskit.control.EventNames;
import mx.collections.ArrayCollection;
import org.tuskit.model.TuskitModelLocator;
import org.tuskit.model.MeetingParticipant;
import org.tuskit.components.developer_box.project_view.MeetingInput;
import flash.events.MouseEvent;

public static function setMeetingInputPopup(meeting:Meeting):MeetingInput {
	var model:TuskitModelLocator = TuskitModelLocator.getInstance();
	model.hasPopupWindow=true;
	var pop:Canvas = TuskitModelLocator.popupWorld;
	var mi:MeetingInput = new MeetingInput();
	mi.meeting = meeting;
	mi.width = 600;
	mi.height=pop.height - 60;
	mi.x = pop.width/2 - mi.width/2;
	mi.y = 30; //pop.height/2 - mi.height/2;
	return mi;
}

[Bindable]
public var meeting:Meeting;

[Bindable]
private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();


private function init():void {
	_model.getMeetingParticipants(meeting);
}

private function editMeeting():void {
	var mi:MeetingInput = MeetingView.setMeetingInputPopup(meeting);
	var pop:Canvas = TuskitModelLocator.popupWorld;
	mi.meetingInputState = MeetingInput.EDIT_STATE;
	pop.addChild(mi);		
}




private function participantsToString(trigger:Boolean):String {
	var participants:Array = [];
	for each (var participant:MeetingParticipant in meeting.meetingParticipants) {
		participants.push(participant.user.first_name + " " + participant.user.last_name);
	}
	return participants.join(", ");
}