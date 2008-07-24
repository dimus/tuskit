package org.tuskit.business {
    import mx.rpc.IResponder;
    import org.tuskit.util.ServiceUtils;
    import org.tuskit.model.Iteration;

    public class CurrentIterationDelegate {
        private var _responder : IResponder;
        
        public function CurrentIterationDelegate(responder : IResponder) {
            _responder = responder;
        }
        public function listCurrentIterations() : void {
            ServiceUtils.send(
                "/current_iterations.xml",
                _responder,
                "GET");
        }
    }
}