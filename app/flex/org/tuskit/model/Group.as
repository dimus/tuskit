package org.tuskit.model {
	import mx.collections.ListCollectionView;
	import mx.collections.ArrayCollection;
	
	
	public class Group {
		public static const NONE_ID:int = 0;
		public static const NONE:Group = new Group();
		
		[Bindable]
		public var id:int;
		
		[Bindable]
		public var name:String;
		
		[Bindable]
		public var memberships:ArrayCollection;
		
		public function Group(
			name:String = '',
			id:int = NONE_ID
			):void {
				this.id = id;
				this.name = name;
				memberships = new ArrayCollection([]);
		}
		
		public function addMembership(membership:Membership):void {
			membership.group = this;
            memberships.addItem(membership);
		}
		
		public function removeMembership(membership:Membership):void {
            if (membership.group == this) {
                for (var i:int = 0; i < memberships.length; i++) {
                    if (memberships[i].id == membership.id) {
                        memberships.removeItemAt(i);
                        membership.group = null;
                        break;
                    }
                }
            }			
		}
		
		public function toXML():XML {
			var retval:XML = 
				<group>
					<name>{this.name}</name>
				</group>;
		    return retval;
		}
		
		public static function fromXML(group:XML):Group {
			return new Group (
				group.name,
				group.id
			);
		}
	}
}