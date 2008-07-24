package org.tuskit.business {
    import mx.rpc.IResponder;
    import org.tuskit.util.ServiceUtils;

    public class GroupDelegate {
        private var _responder : IResponder;
        
        public function GroupDelegate(responder : IResponder) {
            _responder = responder;
        }
        
        public function listGroups() : void {
            ServiceUtils.send(
                "/groups.xml",
                _responder,
                "GET");
        }
    }
}