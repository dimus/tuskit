package org.tuskit.model {
	import flash.display.InteractiveObject;
	import lib.TuskitLib;
	import mx.controls.Alert;
	import mx.collections.ArrayCollection;
	
	public class Meeting {
		public static const UNSAVED_ID:int = -1;
		public static const NONE_ID:Number = 0;
		
		public static const NONE:Meeting = 
			new Meeting (null,'','',null,0,NONE_ID);
		
		[Bindable]
		public var id:int;
		
		[Bindable]
		public var iteration:Iteration;
		
		[Bindable]
		public var meetingName:String;
		
		[Bindable]
		public var notes:String;
				
		[Bindable]
		public var meetingDate:Date;
		
		[Bindable]
		public var length:Number;
		
		[Bindable]
		public var meetingParticipants:ArrayCollection;
		
		public function Meeting(
			iteration:Iteration = null,
			meetingName:String = '',
			notes:String = '',
			meetingDate:Date = null,
			length:Number = 0,
			id:int = UNSAVED_ID
			):void {
			
			this.id = id;
			if (iteration == null) iteration = Iteration.NONE;
			iteration.addMeeting(this);
			
			this.meetingName = meetingName;
			this.notes = notes;
			this.meetingDate = meetingDate;
			this.length = length
			this.id = id;
			this.meetingParticipants = new ArrayCollection([]);
		}
		
  		public function addMeetingParticipant(meetingParticipant:MeetingParticipant):void {
  			meetingParticipant.meeting = this;
  			for each (var pm:MeetingParticipant in meetingParticipants.source) {
  				if (pm.id == meetingParticipant.id) return;
  			}
  			this.meetingParticipants.addItem(meetingParticipant);
  		}
  		
  		public function removeMeetingParticipant(meetingParticipant:MeetingParticipant):void {
  			if (meetingParticipant.meeting == this) {
  				for (var i:int = 0; i< this.meetingParticipants.length; i++) {
  					if (this.meetingParticipants[i].id == meetingParticipant.id) {
  						this.meetingParticipants.removeItemAt(i);
  						meetingParticipant.meeting = Meeting.NONE;
  						break;
  					}
  				}
  			}
  		}
	
		public function	toUpdateObject():Object {
			var obj:Object = new Object();
			obj["meeting[name]"] = meetingName;
			obj["meeting[notes]"] = notes;
			obj["meeting[meeting_date]"] = meetingDate;
			obj["meeting[length]"] = length;
			obj["meeting[id]"] = id;
			return obj	
		}
		
		public function toXML():XML {
			var retval:XML = 
				<meeting>
					<iteration_id>{this.iteration.id}</iteration_id>
					<name>{this.meetingName}</name>
					<notes>{this.notes}</notes>
					<meeting_date>{this.meetingDate}</meeting_date>
					<length>{this.length}</length>
				</meeting>;
			return retval;	
		}	
		
		public static function fromXML(meeting:XML):Meeting {
			var model:TuskitModelLocator = TuskitModelLocator.getInstance();
			var retval:Meeting = new Meeting (
				model.getIteration(meeting.iteration_id),
				meeting.name,
				meeting.notes,
				TuskitLib.fromXmlDate(meeting.meeting_date),
				meeting.length,
				meeting.id
			);
			return retval; 
		}
	}
}