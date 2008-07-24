import lib.TuskitLib;

import org.tuskit.components.developer_box.DeveloperState;
import org.tuskit.control.EventNames;
import org.tuskit.model.Iteration;
import org.tuskit.model.Project;
import org.tuskit.model.Meeting;
import org.tuskit.model.TuskitModelLocator;
import org.tuskit.util.CairngormUtils;
import mx.containers.Accordion;
import mx.controls.Spacer;
import mx.controls.LinkButton;

import mx.utils.UIDUtil;

[Bindable]
private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();

[Bindable]
private var _devModel:DeveloperState = DeveloperState.getInstance();

private var _iteration:Iteration;

[Bindable]
public function set iteration(itr:Iteration):void {
	_iteration = _model.getIteration(itr.id);
	_model.getMeetings(_iteration);
	iterationStack.selectedChild = storiesTasks;
}

public function get iteration():Iteration {
	return _iteration;
}


public function showMeetings():void {
	iterationStack.selectedChild = meetings;
	//meetingsHolder.removeAllChildren();
	setLinkButtonsStyles(meetingsLink);	
	try {
	meetings.removeChildAt(0);
	}
	catch(e:RangeError){}
	 
	if (iteration.meetings.length > 0) {
		var ac:Accordion = new Accordion();
		var mv:MeetingView;
		ac.percentWidth=100;
		ac.percentHeight=100;
		meetings.addChildAt(ac,0);
		for each (var meeting:Meeting in iteration.meetings){
			mv = new MeetingView();
			mv.label = "Meeting " + TuskitLib.dateToString(meeting.meetingDate) + " '" + meeting.meetingName + "'";
			mv.meeting = meeting;
			ac.addChild(mv);
		}
	} else {
		var sp:Spacer = new Spacer();
		sp.percentHeight=100;
		sp.percentWidth=100;
		meetings.addChildAt(sp,0);
	}
}

private function showStoriesTasks():void {
	setLinkButtonsStyles(storiesTasksLink);
	iterationStack.selectedChild=storiesTasks;
}

private function showIterationInfo():void {
	setLinkButtonsStyles(iterationInfoLink);
	iterationStack.selectedChild=iterationInfo;
}

private function showAllIterations():void {
	setLinkButtonsStyles(storiesTasksLink);
	iteration.project.selectedIteration=Iteration.NONE;
}

private function createMeeting():void {
	var meeting:Meeting = new Meeting(iteration);
	var mi:MeetingInput = MeetingView.setMeetingInputPopup(meeting);
	var pop:Canvas = TuskitModelLocator.popupWorld;
	mi.meetingInputState = MeetingInput.CREATE_STATE;
	pop.addChild(mi);			
}

private function setLinkButtonsStyles(lb:LinkButton):void {
	var buttons:Array = [allIterationsLink, storiesTasksLink, iterationInfoLink, meetingsLink];
	var item:LinkButton;
	var isCurrent:Boolean
	for each (item in buttons){
		isCurrent=false;
		if (lb == item) isCurrent = true;
		item.styleName = isCurrent ? "current" : "notCurrent";
	}
}