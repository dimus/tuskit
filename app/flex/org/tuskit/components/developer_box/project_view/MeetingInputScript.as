import flash.events.EventDispatcher;
import flash.events.MouseEvent;

import mx.utils.UIDUtil;

import org.tuskit.control.EventNames;
import org.tuskit.model.Meeting;
import org.tuskit.model.ProjectMember;
import org.tuskit.model.TuskitModelLocator;
import org.tuskit.util.CairngormUtils;

[Bindable]
private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();

[Bindable]
public var meeting:Meeting;


public static const EDIT_STATE:int = 1;
public static const CREATE_STATE:int = 2;

[Bindable]
public var meetingInputState:int;

private function removeMeetingInput():void {
	_model.hasPopupWindow=false;
	TuskitModelLocator.popupWorld.removeAllChildren();
}


private function setMeeting():Meeting{
	var m:Meeting = new Meeting();
	m.meetingName = meetingName.text;
	m.meetingDate = meetingDate.selectedDate;
	m.length =meetingLength.value;
	m.notes = notes.text;
	return m;
}

public function createMeeting(e:MouseEvent):void {
	var m:Meeting = setMeeting();
	CairngormUtils.dispatchEvent(EventNames.CREATE_MEETING, m);
	removeMeetingInput();
}

public function updateMeeting(e:MouseEvent):void {
	var m:Meeting = setMeeting();
	CairngormUtils.dispatchEvent(EventNames.UPDATE_MEETING,m);
	removeMeetingInput();
}

private function init():void {

	_model.getProjectMembers(meeting.iteration.project);

	if (meetingInputState == EDIT_STATE) {
		this.title = "Update Meeting";
		InputButton.label = "Update";
		InputButton.addEventListener(MouseEvent.CLICK, updateMeeting);
	}
	else {
		this.title = "Add Meeting";
		InputButton.label = "Create";
		InputButton.addEventListener(MouseEvent.CLICK, createMeeting);
	}
}

private function getUserName(item:ProjectMember, column:DataGridColumn):String {
	return item.user.full_name
}

private function sortByUserName(item1:ProjectMember, item2:ProjectMember):int {
	if (item1.user.last_name > item2.user.last_name) return 1
	else if (item1.user.last_name < item2.user.last_name) return -1
	else return 0;
}