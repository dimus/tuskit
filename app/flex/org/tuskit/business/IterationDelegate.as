package org.tuskit.business {
    import mx.rpc.IResponder;
    import org.tuskit.util.ServiceUtils;
    import org.tuskit.model.Iteration;

    public class IterationDelegate {
        private var _responder : IResponder;
        
        public function IterationDelegate(responder : IResponder) {
            _responder = responder;
        }
        
        public function createIteration(iteration:Iteration) : void {
			
			ServiceUtils.send(
				"/iterations.xml",
				_responder,
				"POST",
				iteration.toXML(),
				true);
		}
		
		public function updateIteration(iteration:Iteration) : void {
			ServiceUtils.send(
				"/iterations/" + iteration.id + ".xml",
                _responder,
                "PUT",
                iteration.toUpdateObject(),
                false);
		}
		
        public function deleteIteration(iteration:Iteration) : void {
            ServiceUtils.send(
                "/iterations/" + iteration.id + ".xml",
                _responder,
                "DELETE");
        }

        
        public function listIterations() : void {
            ServiceUtils.send(
                "/iterations.xml",
                _responder,
                "GET");
        }
    }
}