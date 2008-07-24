// ActionScript file
import org.tuskit.model.TuskitModelLocator;
import org.tuskit.components.admin_box.AdminState;
import org.tuskit.model.User;
import mx.events.DropdownEvent;
import mx.controls.Alert;

private const ANY_GROUP			:int = 0;
private const ADMIN_GROUP		:int = 1;
private const DEVELOPER_GROUP	:int = 2;
private const CUSTOMER_GROUP		:int = 3;
private const SELECT_GROUP:Array = [
	{label: "Any", data: ANY_GROUP, filter: emptyFilter},
	{label: "Admin", data: ADMIN_GROUP, filter: adminFilter},
	{label: "Developer", data: DEVELOPER_GROUP, filter: developerFilter},
	{label: "Customer", data: CUSTOMER_GROUP, filter: customerFilter}
];

private var _resetFilter:int;

[Bindable]
private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();

private var _state:AdminState = AdminState.getInstance();

public function set resetFilter(state:int):void {
	_resetFilter=state;
	changeState();
}

[Bindable]
public function get resetFilter():int {
	return _resetFilter;
}
	
private function changeState():void{
		filterInput.text = '';
		selectGroupCB.selectedIndex = ANY_GROUP;
		_model.users.filterFunction = SELECT_GROUP[ANY_GROUP].filter;
		_model.users.refresh();
}

private function emptyFilter(user:User):Boolean {
	var name:String = user.first_name.toLowerCase() + " " + user.last_name.toLowerCase();
	return name.indexOf(filterInput.text) != -1;
}

private function adminFilter(user:User):Boolean {
	var name:String = user.first_name.toLowerCase() + " " + user.last_name.toLowerCase();
	return (name.indexOf(filterInput.text) != -1 && user.isAdmin());				
}

private function developerFilter(user:User):Boolean {
	var name:String = user.first_name.toLowerCase() + " " + user.last_name.toLowerCase();
	return name.indexOf(filterInput.text) != -1 && user.isDeveloper();				
}

private function customerFilter(user:User):Boolean {
	var name:String = user.first_name.toLowerCase() + " " + user.last_name.toLowerCase();
	return name.indexOf(filterInput.text) != -1 && user.isCustomer();				
}

private function handleFilterInputChange():void {
	if (_model.users.filterFunction === null) {
		_model.users.filterFunction = emptyFilter;
	}
	_model.users.refresh();
}

private function handleUserFilter(event:DropdownEvent):void {
	var idx:int = event.currentTarget.selectedIndex;
	_model.selectedUserId = -1;
	//usersGrid.selectedItem = null;
	_model.users.filterFunction = SELECT_GROUP[idx].filter;
	filterInput.text = "";
	_state.userInput=new User();
	_model.users.refresh();
}