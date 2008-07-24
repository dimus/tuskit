package org.tuskit.business {
    import mx.rpc.IResponder;
    import org.tuskit.util.ServiceUtils;
    import org.tuskit.model.Membership;

    public class MembershipDelegate {
        private var _responder : IResponder;
        
        public function MembershipDelegate(responder : IResponder) {
            _responder = responder;
        }
        
        public function createMembership(membership:Membership) : void {
			
			ServiceUtils.send(
				"/memberships.xml",
				_responder,
				"POST",
				membership.toXML(),
				true);
		}
		
        public function deleteMembership(membership:Membership) : void {
            ServiceUtils.send(
                "/memberships/" + membership.id + ".xml",
                _responder,
                "DELETE");
        }

        
        public function listMemberships() : void {
            ServiceUtils.send(
                "/memberships.xml",
                _responder,
                "GET");
        }
    }
}