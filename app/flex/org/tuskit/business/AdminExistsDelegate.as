package org.tuskit.business {
    import mx.rpc.IResponder;
    import org.tuskit.util.ServiceUtils;

    public class AdminExistsDelegate {
        private var _responder : IResponder;
        
        public function AdminExistsDelegate(responder : IResponder) {
            _responder = responder;
        }
        
        public function checkAdminExists() : void {
            ServiceUtils.send(
                "/admin_exists",
                _responder,
                "GET");
        }
    }
}