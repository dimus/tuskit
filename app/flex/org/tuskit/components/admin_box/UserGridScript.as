// ActionScript file
import org.tuskit.model.User;
import org.tuskit.model.TuskitModelLocator;
import org.tuskit.util.CairngormUtils;
import org.tuskit.control.EventNames;
import org.tuskit.components.admin_box.AdminState;

[Bindable]
private var _model:TuskitModelLocator=TuskitModelLocator.getInstance();
private var _adminState:AdminState = AdminState.getInstance();

private var nextState:int;
public var currentUserGridState:int;

private function getUsersGridSelectedIndex(isInTransitionState:Boolean):int {
	if (!isInTransitionState && _model.selectedUserId != -1) {
		var selectedUser:User = _model.getUser(_model.selectedUserId);
		var selectedIndex:int;
		selectedIndex = _model.users.getItemIndex(selectedUser);
		this.verticalScrollPosition=selectedIndex;
		return selectedIndex;
	} else return -1;
 }
 
public function editUser():void {
	_model.selectedUserId = this.selectedItem.id;	    		

}

public function deleteUser(usr:User):void {
	CairngormUtils.dispatchEvent(EventNames.DELETE_USER,usr);
} 
	