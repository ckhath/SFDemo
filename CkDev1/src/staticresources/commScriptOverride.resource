/* JS file*/

acfcomm = {
	setSettingModule: function(){
		$("#profileTabSetHeader").before("<div class=\"profileTools\"></div>");
		$(".profileTools").html($(".userProfilePage .profileHeader #USER_DETAIL"));
		$(".profileTools #USER_DETAIL span").before("<span class=\"settingIcon\">&nbsp;</span>");
		if($(".profileTools").html() == "") $(".profileTools").html($(".userProfilePage .profileHeader").html());
		$("#displayBadge").html("Profile");
		$("#tailBreadcrumbNode span").remove();
		$("#photoSection").append($("#tailBreadcrumbNode"));
	}
	
};

$(function() {
    acfcomm.setSettingModule();


});