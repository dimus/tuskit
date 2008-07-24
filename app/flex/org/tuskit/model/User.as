 package org.tuskit.model {
	import mx.collections.ArrayCollection;
	
	
	public class User {
		public static const UNSAVED_ID:int = -1; 
		public static const NONE_ID:int = 0;
		
		public static const NONE:User = 
			new User ('-none-','','','','','','',NONE_ID);
		
		[Bindable]
		public var id:int;
		
		[Bindable]
		public var login:String;
		
		[Bindable]
		public var email:String;
		
		[Bindable]
		public var phone:String;
		
		[Bindable]
		public var first_name:String;
		
		[Bindable]
		public var last_name:String;
		
		[Bindable]
		public var full_name:String;
		
		[Bindable]
		public var password:String;
		
		[Bindable]
		public var password_confirmation:String;
		
		[Bindable]
		public var memberships:ArrayCollection;
		
		[Bindable]
		public var projectMembers:ArrayCollection;
		
		[Bindable]
		public var meetingParticipants:ArrayCollection;
		
		[Bindable]
		public var groupIds:ArrayCollection= new ArrayCollection([]);
		
		public function User (
			login:String = "",
			email:String = "",
			phone:String = "",
			first_name:String = "",
			last_name:String = "",
			password:String = "",
			password_confirmation:String = "",
			id:int = UNSAVED_ID):void {
				this.login = login;
				this.email = email;
				this.phone = phone;
				this.first_name = first_name;
				this.last_name = last_name;
				this.full_name = last_name + ", " + first_name;
				this.password = password;
				this.password_confirmation = password_confirmation;
				this.id = id;
				this.memberships = new ArrayCollection([]);
				this.projectMembers = new ArrayCollection([]);
				this.meetingParticipants = new ArrayCollection([]);
			}
		
		public function addMembership(membership:Membership):void {
			membership.user = this;
			if (!this.memberships.contains(membership)) {
            	this.memberships.addItem(membership);
   			}
		}
		
		public function removeMembership(membership:Membership):void {
            if (membership.user == this) {
                for (var i:int = 0; i < this.memberships.length; i++) {
                    if (this.memberships[i].id == membership.id) {
                        this.memberships.removeItemAt(i);
                        membership.user = null;
                        break;
                    }
                }
            }			
		}
		
 		public function addProjectMember(projectMember:ProjectMember):void {
  			projectMember.user = this;
  			for each (var pm:ProjectMember in projectMembers.source) {
  				if (pm.id == projectMember.id) return;
  			}
  			this.projectMembers.addItem(projectMember);
  		}
  		
  		public function removeProjectMember(projectMember:ProjectMember):void {
  			if (projectMember.user == this) {
  				for (var i:int = 0; i< this.projectMembers.length; i++) {
  					if (this.projectMembers[i].id == projectMember.id) {
  						this.projectMembers.removeItemAt(i);
  						projectMember.user = User.NONE;
  						break;
  					}
  				}
  			}
  		}

	  	public function addMeetingParticipant(meetingParticipant:MeetingParticipant):void {
  			meetingParticipant.user = this;
  			for each (var pm:MeetingParticipant in meetingParticipants.source) {
  				if (pm.id == meetingParticipant.id) return;
  			}
  			this.meetingParticipants.addItem(meetingParticipant);
  		}
  		
  		public function removeMeetingParticipant(meetingParticipant:MeetingParticipant):void {
  			if (meetingParticipant.user == this) {
  				for (var i:int = 0; i< this.meetingParticipants.length; i++) {
  					if (this.meetingParticipants[i].id == meetingParticipant.id) {
  						this.meetingParticipants.removeItemAt(i);
  						meetingParticipant.user = User.NONE;
  						break;
  					}
  				}
  			}
  		}
	
		
		public function getMembership(group:Group):Membership {
			var membership:Membership;
			for each (membership in this.memberships){
				if (membership.group == group) {
					return membership;
				}
			}
			return null;
		}
		
		/**
		 * Uglyish method to update user in rails.
		 * We cannot use xml with _method=PUT, so we have to assemble 
		 * something similar to rails form
		 */
		public function	toUpdateObject():Object {
			var obj:Object = new Object();
			obj["user[login]"] = login;
			obj["user[email]"] = email;
			obj["user[phone]"] = phone;
			obj["user[first_name]"] = first_name;
			obj["user[last_name]"] = last_name;
			obj["user[password]"] = password;
			obj["user[password_confirmation]"] = password_confirmation;
			return obj
		}
			
			
		public function toXML():XML {
			var retval:XML = 
				<user>
					<login>{login}</login>
					<email>{email}</email>
					<phone>{phone}</phone>
					<first_name>{first_name}</first_name>
					<last_name>{last_name}</last_name>
					<password>{password}</password>
					<password_confirmation>{password_confirmation}</password_confirmation>
				</user>;
			return retval;
		}
		
		public static function fromXML(user:XML):User {
			var groups:XMLList = user.groups as XMLList;
			var retval:User = new User(
				user.login,
				user.email,
				user.phone,
				user.first_name,
				user.last_name,
				"","", user.id
			);
			for each (var group:XML in groups.children()) {
				retval.groupIds.addItem(int(group.id));
			}
			return retval;
		}
		
		public function isAdmin():Boolean {
			return hasGroup(TuskitModelLocator.ADMIN);
		}
		
		public function isDeveloper():Boolean{
			return hasGroup(TuskitModelLocator.DEVELOPER);
		}
		
		public function isCustomer():Boolean{
			return hasGroup(TuskitModelLocator.CUSTOMER);
		}
		
		private function hasGroup(groupId:int):Boolean {
			var m:Membership;
			for each (m in this.memberships){
				if (m.group.id == groupId){
					return true
				}
			}
			return false
		}
			
	}
}