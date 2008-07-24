package org.tuskit.model {
	import flash.display.InteractiveObject;
	import mx.controls.Alert;
	
	public class Membership {
		public static const UNSAVED_ID:int = -1;
		
		[Bindable]
		public var id:int;

		[Bindable]
		public var user:User;
		
		[Bindable]
		public var group:Group;
				
		public function Membership(
			user:User = null,
			group:Group = null,
			id:int = UNSAVED_ID
			):void {
			
			this.id = id;
			if (user == null) {
				user = User.NONE;
			}
			user.addMembership(this);
			if (group == null) {
				group = Group.NONE;
			}
			group.addMembership(this);
		}
		
		public function toXML():XML {
			var retval:XML = 
				<membership>
					<user_id>{this.user.id}</user_id>
					<group_id>{this.group.id}</group_id>
				</membership>;
			return retval;	
		}	
		
		public static function fromXML(membership:XML):Membership {
			var model:TuskitModelLocator = TuskitModelLocator.getInstance();
			var retval:Membership = new Membership (
				model.getUser(membership.user_id),
				model.getGroup(membership.group_id),
				membership.id
			);
			return retval; 
		}
	}
}