package org.tuskit.business {
    import mx.rpc.IResponder;
    import org.tuskit.util.ServiceUtils;
    import org.tuskit.model.User;

    public class UserDelegate {
        private var _responder : IResponder;
        
        public function UserDelegate(responder : IResponder) {
            _responder = responder;
        }
		public function createUser(user:User) : void {
			ServiceUtils.send(
				"/users.xml",
				_responder,
				"POST",
				user.toXML(),
				true);
		}
        
        public function deleteUser(user:User) : void {
            ServiceUtils.send(
                "/users/" + user.id + ".xml",
                _responder,
                "DELETE");
        }

        public function listUsers() : void {
            ServiceUtils.send(
                "/users.xml",
                _responder,
                "GET");
        }
        
        public function updateUser(user:User):void {
            ServiceUtils.send(
                "/users/" + user.id + ".xml",
                _responder,
                "PUT",
                user.toUpdateObject(),
                false);
        }

        
    }
}