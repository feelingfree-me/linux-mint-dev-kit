var alert_template = '\
<div class="alert alert-danger" role="alert"> \
	<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button> \
	<p><i class="fa fa-exclamation-triangle"></i> &nbsp; <span class="message"></span></p> \
</div>';

var firstTime = true;
var loginProcess = false;
var resetPassword = false;


// Initialize
$(document).ready(function(){
	centerLoginBox();

	$(".sessions-list").selectpicker();
	$(".actions a").tooltip();

	//[name=password]
	$("#login input").bind("keyup", function(event){
		if(isLoginValid()) {
			$("#login button[type=submit]").removeAttr('disabled');
		} else {
			$("#login button[type=submit]").attr('disabled', 'disabled');
		}
	});

	$("#username").bind("change", function(event){
		event.preventDefault();
		updateUsername();
	});

 	$("#login button[type=submit]").bind("click", function(event){
		event.preventDefault();
		login();
	});

	$("#login input").on("keydown", function(event){
		if(event.keyCode == 13) {
			event.preventDefault();
			login();
		}
 	});

	$("#sessions-list").on("change", function(){
		alert(this.value);
		//mdm_error(this.value);
	});

	$("#suspend, #restart, #shutdown").bind("click", function(event){
		event.preventDefault();
		var self = $(this);
		alert(self.data("target"));
	});

 	$(window).resize(function(){
 		centerLoginBox();
 	});
});

function centerLoginBox() {
	$("#login").css("top", (($(window).height() / 2) - ($("#login").height() / 2) - $("#errors").outerHeight()));
}

function isLoginValid() {
	var username = $("#username").val().toLowerCase();
	var password = $("#password").val();

	if((username.length > 0) && (password.length > 0)) {
		return true;
	}

	return false;
}

function updateUsername() {
	var username = $("#username").val().toLowerCase();

	if(username) {
		alert("USER###" + username);
	}
	//mdm_error("updateUsername: " + username);
}

function sendPassword() {
    alert("LOGIN###" + $("#password").val());

    //mdm_error("login: " + $("#password").val());
}

// MDM: Enable/Disable Input
function mdm_prompt(message) {
	mdm_enable();
	loginProcess = false;

	//mdm_error("mdmPrompt");
}

function login() {
	if(!isLoginValid()) {
		return;
	}

	mdm_disable();

    loginProcess = true;
    updateUsername();
}

function mdm_noecho(message) {
	mdm_enable();
	
    if(loginProcess) {
        sendPassword();

        loginProcess = false;
        resetPassword = true;
    }

	//mdm_error("mdmNoecho");
}

function mdm_disable() {
	$("#login").find("input").attr("disabled", "disabled");
	$("#login button[type=submit]").attr("disabled", "disabled");

	//mdm_error("mdmDisable");
}

function mdm_enable() {
	if(loginProcess) {
		return;
	}

	$("#login").find("input").removeAttr("disabled");
	$("#login button[type=submit]").removeAttr("disabled");

	if(!firstTime) {
		$("#password").focus();
	} else {
		firstTime = false;
		$("#username").focus();
	}

	if(resetPassword) {
		resetPassword = false;
		$("#password").val("");
	}

	//mdm_error("mdmEnable");
}

// MDM: Clock
function set_clock(message) {
	// Dummy
}

// MDM: Time Counter
function mdm_timed(message) {
	// Dummy
}

// MDM: Add Error Message
function mdm_error(message) {
	if (message != "") {
		var alert = $(alert_template);
		alert.find(".message").html(message);

		setTimeout(function() {
			$(alert).fadeOut(1000, function(){ $(this).remove(); });
		}, 10000);

		alert.appendTo("#errors");

		alerts = $("#errors").find(".alert:lt(-2)").fadeOut(1000, function(){ $(this).remove(); });
	}
}

// MDM: Add User
function mdm_add_user(username, gecos, status) {
	// Dummy
}

function mdm_set_current_user(username) {
	// Dummy
	//mdm_error("setCurrentUser: " + username);
}

// MDM: Add Session
function mdm_add_session(name, file) {
	if(name == "Default Session") {
		$("#sessions-list").append('<option value="SESSION###' + name + '###' + file + '" data-subtext="' + name + '">λ</option>').selectpicker("refresh");
		return;
	}

	$("#sessions-list").append('<option value="SESSION###' + name + '###' + file + '" data-subtext="' + name + '">'
		+ name[0].toUpperCase() + '</option>').selectpicker("refresh");
}

// MDM: Add Language
function mdm_add_language(name, code) {
	// Dummy
}

// MDM: Action Hidden
function mdm_hide_suspend() {
	$("#suspend").hide();
}

function mdm_hide_restart() {
	$("#restart").hide();
}

function mdm_hide_shutdown() {
	$("#shutdown").hide();
}

function mdm_hide_quit() {
	$("#quit").hide();
}

function mdm_hide_xdmcp() {
	$("#xdmcp").hide();
}
