import mx.controls.Alert;
import mx.validators.Validator;

import org.tuskit.components.admin_box.AdminState;
import org.tuskit.control.EventNames;
import org.tuskit.model.TuskitModelLocator;
import org.tuskit.model.User;
import org.tuskit.util.CairngormUtils;


private var _userInput:User;

[Bindable]
private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();

private var _state:AdminState = AdminState.getInstance();


public function set userInput(user:User):void {
	_userInput = user;
	changeState();
}

[Bindable]
public function get userInput():User {
	return _userInput;
}
	
private function changeState():void{
	if (userInput.id > 0) editState();
	else createState();
} 

private function editState():void {
	this.styleName = "updateUser";
	loginTI.styleName="inputDisabled";                
	loginTI.editable=false;
	saveB.label="Update";
	focusManager.setFocus(firstNameTI);
	this.title = "Update User " + userInput.first_name +
		" " + userInput.last_name + " (aka " +
	    userInput.login + ")";
	passwordFI.required=false;
	passwordConfirmationFI.required=false;
	passwordConfirmationValidator.required=false;
	passwordValidator.required=false;
}

private function createState():void {
	this.styleName = "newUser";
	loginTI.styleName = "inputEnabled";
	loginTI.editable = true;
	saveB.label="Create";
	focusManager.setFocus(loginTI);
	this.title="Create New User";
	passwordFI.required=true;
	passwordConfirmationFI.required=true;
	passwordConfirmationValidator.required=true;
	passwordValidator.required=true;
}

private function cancelUser():void {
	_state.userInput = new User();			
}

private function prepareGroupsToSave():Object {
	var retval:Object = {'toCreate':[],'toDelete':[]};
	if (userInput.id == User.UNSAVED_ID){
		if (adminCB.selected) {
			retval['toCreate'].push(_model.getGroup(TuskitModelLocator.ADMIN));
		}
		if (developerCB.selected) {
			retval['toCreate'].push(_model.getGroup(TuskitModelLocator.DEVELOPER));
		}
		if (customerCB.selected) {
			retval['toCreate'].push(_model.getGroup(TuskitModelLocator.CUSTOMER));
		}
	} else {
		if (adminCB.selected) {
			if (!userInput.isAdmin()) {
				retval['toCreate'].push(_model.getGroup(TuskitModelLocator.ADMIN));
			}
		} else {
			if (userInput.isAdmin()) {
				retval['toDelete'].push(_model.getGroup(TuskitModelLocator.ADMIN));
			}
		}

		if (developerCB.selected) {
			if (!userInput.isDeveloper()) {
				retval['toCreate'].push(_model.getGroup(TuskitModelLocator.DEVELOPER));
			}
		} else {
			if (userInput.isDeveloper()) {
				retval['toDelete'].push(_model.getGroup(TuskitModelLocator.DEVELOPER));
			}
		}
		
		if (customerCB.selected) {
			if (!userInput.isCustomer()) {
				retval['toCreate'].push(_model.getGroup(TuskitModelLocator.CUSTOMER));
			}
		} else {
			if (userInput.isCustomer()) {
				retval['toDelete'].push(_model.getGroup(TuskitModelLocator.CUSTOMER));
			}
		}
	}
	return retval;
}


private function saveUser():void {
	var results:Array = Validator.validateAll([
        usernameValidator,
        firstNameValidator,
        lastNameValidator,
        emailValidator]);
    if (results.length > 0) {
        Alert.show("Please correct the validation errors highlighted " +
            "on the form.", "Account Not Created");
        return;
    }
	var groupsData:Object = prepareGroupsToSave();
	var userToSave:User = userInput;
	var userPackage:Object = {'user':userToSave, 'groups':groupsData};
	userToSave.login = loginTI.text;
	userToSave.first_name = firstNameTI.text;
	userToSave.last_name = lastNameTI.text;
	userToSave.phone = phoneTI.text;
	userToSave.email = emailTI.text;
	userToSave.password = passwordTI.text;
	userToSave.password_confirmation = confirmPasswordTI.text;
	if (userToSave.id == User.UNSAVED_ID) {
		//_state.resetFilter = 1 - _state.resetFilter;				
		CairngormUtils.dispatchEvent(EventNames.CREATE_USER, userPackage);
	}
	else if (userToSave.id > 0) {
		CairngormUtils.dispatchEvent(EventNames.UPDATE_USER, userPackage);
	}
}



