package org.tuskit.business {
    import mx.rpc.IResponder;
    import org.tuskit.util.ServiceUtils;
    import org.tuskit.model.MeetingParticipant;
    import org.tuskit.model.Meeting;

    public class MeetingParticipantDelegate {
        private var _responder : IResponder;
        
        public function MeetingParticipantDelegate(responder : IResponder) {
            _responder = responder;
        }
        
        public function createMeetingParticipant(meetingParticipant:MeetingParticipant) : void {
			ServiceUtils.send(
				"/meeting_participants.xml",
				_responder,
				"POST",
				meetingParticipant.toXML(),
				true);
		}
		
        public function deleteMeetingParticipant(meetingParticipant:MeetingParticipant) : void {
            ServiceUtils.send(
                "/meeting_participants/" + meetingParticipant.id + ".xml",
                _responder,
                "DELETE");
        }
        
        public function listMeetingParticipants(meeting:Meeting) : void {
            ServiceUtils.send(
                "/meetings/" + meeting.id + "/meeting_participants.xml",
                _responder,
                "GET");
        }
    }
}