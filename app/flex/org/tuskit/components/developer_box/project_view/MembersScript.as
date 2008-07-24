import mx.collections.ArrayCollection;

import org.tuskit.control.EventNames;
import org.tuskit.model.Project;
import org.tuskit.model.ProjectMember;
import org.tuskit.model.TuskitModelLocator;
import org.tuskit.model.User;
import org.tuskit.util.CairngormUtils;
import mx.utils.UIDUtil;

[Bindable]
private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();

[Bindable]
private var _otherUsers:ArrayCollection = new ArrayCollection([]);

[Bindable]
public var project:Project;

private function init():void {

	_model.getProjectMembers(project);
}

private function getUserName(item:ProjectMember, column:DataGridColumn):String {
	return item.user.full_name
}

private function sortByUserName(item1:ProjectMember, item2:ProjectMember):int {
	if (item1.user.last_name > item2.user.last_name) return 1
	else if (item1.user.last_name < item2.user.last_name) return -1
	else return 0;
}

private function getProjectMemberRoles(item:ProjectMember, column:DataGridColumn):String {
	var user:User = item.user;
	return getRoles(user);
}

private function getRoles(user:User):String {
	var roles:Array = [];
	if (user.groupIds.contains(TuskitModelLocator.ADMIN)) roles.push("admin");
	if (user.groupIds.contains(TuskitModelLocator.CUSTOMER)) roles.push("customer");
	if (user.groupIds.contains(TuskitModelLocator.DEVELOPER)) roles.push("developer");
	return roles.join(", ");		
}

private function getUserRoles(item:User, column:DataGridColumn):String {
	return getRoles(item);	
}

private function setOtherUsers(trigger:int):int {
	_otherUsers = new ArrayCollection([]);
	for each (var user:User in _model.users) {
		var notMember:Boolean = true;
		for each (var pm:ProjectMember in project.projectMembers) {
			if (pm.user.id == user.id) {
				notMember = false;
				break;
			}
		}
		if (notMember) _otherUsers.addItem(user);
	}
	return _otherUsers.length;
}

public function addProjectMember(user:User):void {
	var pm:ProjectMember = new ProjectMember(
		project,
		user,
		true,
		true
	);
	CairngormUtils.dispatchEvent(EventNames.CREATE_PROJECT_MEMBER, pm);
}
