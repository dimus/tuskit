package org.tuskit.model {
	import flash.display.InteractiveObject;
	import lib.TuskitLib;
	import mx.controls.Alert;
	
	public class MeetingParticipant {
		public static const UNSAVED_ID:int = -1;
		
		[Bindable]
		public var id:int;
		
		[Bindable]
		public var meeting:Meeting;

		[Bindable]
		public var user:User;
						
		public function MeetingParticipant(
			meeting:Meeting = null,
			user:User = null,
			id:int = UNSAVED_ID
			):void {
			
			this.id = id;
			
			if (meeting == null) meeting = Meeting.NONE;
			meeting.addMeetingParticipant(this);

			if (user == null) user = User.NONE;
			user.addMeetingParticipant(this);
		}			
		
		public function toXML():XML {
			var retval:XML = 
				<meeting_participant>
					<meeting_id>{this.meeting.id}</meeting_id>
					<user_id>{this.user.id}</user_id>
				</meeting_participant>;
			return retval;	
		}	
		
		public static function fromXML(meetingParticipant:XML):MeetingParticipant {
			var model:TuskitModelLocator = TuskitModelLocator.getInstance();
			var retval:MeetingParticipant = new MeetingParticipant (
				model.getMeeting(meetingParticipant.meeting_id),
				model.getUser(meetingParticipant.user_id),
				meetingParticipant.id
			);
			return retval; 
		}
	}
}