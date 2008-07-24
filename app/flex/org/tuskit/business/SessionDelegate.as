package org.tuskit.business {
    import mx.rpc.IResponder;
    import org.tuskit.util.ServiceUtils;

    public class SessionDelegate {
        private var _responder : IResponder;
        
        public function SessionDelegate(responder : IResponder) {
            _responder = responder;
        }
        
        public function createSession(login: String, password: String) : void {
            ServiceUtils.send(
                "/sessions.xml",
                _responder,
                "POST",
                {login: login, password: password});
        }
        
        public function deleteSession():void {
        	ServiceUtils.send(
        		"/logout",
        		_responder,
        		"GET");
        }
    }
}