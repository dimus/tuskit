package org.tuskit.business {
    import mx.rpc.IResponder;
    import org.tuskit.util.ServiceUtils;
    import org.tuskit.model.Tracker;

    public class TrackerDelegate {
        private var _responder : IResponder;
        
        public function TrackerDelegate(responder : IResponder) {
            _responder = responder;
        }
		public function createTracker(tracker:Tracker) : void {
			ServiceUtils.send(
				"/trackers.xml",
				_responder,
				"POST",
				tracker.toXML(),
				true);
		}
        
        public function deleteTracker(tracker:Tracker) : void {
            ServiceUtils.send(
                "/trackers/" + tracker.id + ".xml",
                _responder,
                "DELETE");
        }

        public function listTrackers() : void {
            ServiceUtils.send(
                "/trackers.xml",
                _responder,
                "GET");
        }
        
        public function updateTracker(tracker:Tracker):void {
            ServiceUtils.send(
                "/trackers/" + tracker.id + ".xml",
                _responder,
                "PUT",
                tracker.toUpdateObject(),
                false);
        }

        
    }
}