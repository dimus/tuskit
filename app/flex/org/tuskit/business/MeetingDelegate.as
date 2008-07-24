package org.tuskit.business {
    import mx.rpc.IResponder;
    import org.tuskit.util.ServiceUtils;
    import org.tuskit.model.Meeting;
    import org.tuskit.model.Iteration;

    public class MeetingDelegate {
        private var _responder : IResponder;
        
        public function MeetingDelegate(responder : IResponder) {
            _responder = responder;
        }
        
        public function createMeeting(meeting:Meeting) : void {
			
			ServiceUtils.send(
				"/meetings.xml",
				_responder,
				"POST",
				meeting.toXML(),
				true);
		}
		
		public function updateMeeting(meeting:Meeting) : void {
			ServiceUtils.send(
				"/meetings/" + meeting.id.toString() + ".xml",
                _responder,
                "PUT",
                meeting.toUpdateObject(),
                false);
		}
		
        public function deleteMeeting(meeting:Meeting) : void {
            ServiceUtils.send(
                "/meetings/" + meeting.id.toString() + ".xml",
                _responder,
                "DELETE");
        }

        
        public function listMeetings(iteration:Iteration) : void {
            ServiceUtils.send(
                "/iterations/"+ iteration.id.toString() + "/meetings.xml",
                _responder,
                "GET");
        }
    }
}