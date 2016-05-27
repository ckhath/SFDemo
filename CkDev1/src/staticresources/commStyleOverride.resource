/* @group Page Wrapper */
.globalHeaderBar{
  display:none;
}

html, body, p, td { 
	font-family: "ProximaNovaSoft-Regular", Calibri, 
            "Gill Sans", "Gill Sans MT", Candara, Segoe, 
            "Segoe UI", Arial, sans-serif;
	font-weight: normal;
}

//li < a[title="Home Mobile Tab"], li < a[title="Directory Search Mobile Tab"] {display:none;}
//li < a[title*="Mobile Tab"]{display:none;}
//li[class^="Mobile"], li[class*="Mobile"]{display:none;}

.zen .zen-tabMenu > li:nth-child(2),.zen .zen-tabMenu > li:nth-child(3) {display:none;}
/* @end */

/* @group Home Page */
html .brandPrimaryBgr {
  background-color: #fff!important;
}

#sidebarDiv .sidebarModuleHeader {
  background: none;
}

#sidebarDiv .sidebarModuleHeader h2 {
  background: url("") no-repeat scroll 0 0 #6D88A3;
  font-size: 15px;
  font-weight: normal;
  padding: 8px;
  border-top-left-radius: 10px;
  border-top-right-radius: 10px;
}

#sidebarDiv .sidebarModule .sidebarModuleBody {
  border: 1px solid #4C5A65;
  border-bottom-right-radius: 10px;
  border-bottom-left-radius: 10px;
}

.bodyDiv iframe[title="HP_Header"] {
	width:100%;
}

#sidebarDiv .sidebarModule{
  background: none;
}
/* @end */

/* @group User Profile */
.userProfilePage {
  width: 100%;
  margin: 10px;
}
.userProfilePage .leftContent {
  /*float: left;
  width: 23%;*/
}
.profilePage.userProfilePage .mainContent {
  /*float: right;
  width: 77%;
  margin: 0;*/
  width: initial;
}
.profileTabSetContainer {
  margin: 0 10px 0 0;
}

.userProfilePage .leftContent .photoSection {
  width: 96%;
  text-align: center;
  border-radius: 9px;
  border: 1px solid #CCC !important;
}

.userProfilePage .leftContent .profileImage {
  border: none !important;
  width: 100%;
  padding: 13px 0;
}

.userProfilePage .leftContent .photoSection #tailBreadcrumbNode{
    font-size: 12px;
    font-family: arial;
    font-weight: bold;
    padding-bottom: 12px;
    display: block;
}
.chatter-avatarFull .chatter-photo {
width: 90%;
border-radius: 9px;
max-width: 200px;
}

.userProfilePage .profileOverview .profileRightColumn {
  width: 33%;
}
.userProfilePage .profileOverview .profileLeftColumn {
  width: 66%;
}
.userProfilePage .profileOverview .profileFilesOwnedDiv {
  width: 50%;
}
.userProfilePage .profileOverview .profileGroupsDiv {
  width: 50%;
}
.userProfilePage .profileOverview .zoneActivityPanel {
  width: 48%;
}
.zoneActivityPanel .content {
    width: 94%;
}
#recentFilesPanel {
  margin-right: 10px;
}

.chatterUserGuestBadge, .chatterGroupGuestBadge, .nonTailBreadCrumbGuestBadge {display:none;}
.userProfilePage .leftContent .guestBadge {
  background: #44596c;
  text-align: left;
  color: #fff;
  padding: 10px 0 5px 5%;
  border-radius: 7px 7px 0 0;
  display: block;
  position: static;
  margin: 0;
  width: 95%;
  font-family: Arial,Helvetica,sans-serif;
  font-size: 15px;
}

.userProfilePage .leftContent .hasPhotoLinks.hoverOrFocus #displayBadge{ display: block !important;}
.userProfilePage .leftContent .photoUploadSection {
  bottom: 12px;
  width: 92%;
}


.userProfilePage .leftContent .contactInfo { display: none; }
.profileTabSetContainer .zen-tabs .profileMore { margin: 0; }
.profileTabSetContainer .profileTabSetHeader.zen-header #profileTabSetHeaderWrapper { max-width: 100%; margin-left: 8px;}
.profileTabSetContainer .profileTabSet.zen-tabControl li, .profileTabSetContainer .profileMoreTrigger {
    background: #5d7a98;
    box-shadow: none;
    border: none;
}
.profileTabSetContainer .profileTabSetHeader.zen-header { border: none; }

.profileTabSetContainer .profileMore .profileMoreTrigger.zen-current {
  background: #5d7a98;
  color: #fff;
  text-transform: uppercase;
  font-size: 10px;
  font-weight: lighter;
}
.profileTabSetContainer .profileTabSet.zen-tabControl li a, .profileTabSetContainer #profileMoreTriggerLabel {
  color: #fff;
  text-transform: uppercase;
  font-size: 12px;
  font-weight: lighter;
}

#profileTabSetHeaderWrapper .leftBorder {
  border-radius: 7px 0 0 7px;
}

.profileTabSetContainer .profileTabSetHeader.zen-header {
  border: none;
}
.profileTabSetContainer .profileTabSet.zen-tabControl .zen-current, .profileTabSetContainer .profileMore .profileMoreTrigger.zen-current {
  background-color: #136398;
  border-left: 1px solid #fff;
  border-right: 1px solid #fff;
}

.profileTabSetContainer .profileTabSet.zen-tabControl a:hover, .profileTabSetContainer a.profileMoreTrigger:hover, .profileTabSetContainer a.profileMoreTrigger:focus {
  background-color: #136398;
}

.profileTabSetContainer .profileTabSet.zen-tabControl .zen-current a:hover, .profileTabSetContainer .profileMore a.profileMoreTrigger.zen-current:hover {
  background-color: #136398;
}

#profileTabContent #profileFeed {
  margin: 15px 10px;
}

#profileTabContent #profileOverview {
  margin: 10px;
}

#profileTabSetHeader {
  width: 64.5%;
  background-color: #5d7a98;
  margin-left: 10px;
  border-radius: 7px;
}

.profileTabSetContainer .profileOverview h3, .groupprofilepage .rightContent h3 {
  margin: 0;
  background-color: #9f9fa1;
  padding: 7px 13px;
  border-radius: 7px 7px 0 0;
  color: #fff;
}
.profileTabSetContainer .profileOverview h3, .groupprofilepage .leftContent h3 {
  margin: 0;
  background-color: #9f9fa1;
  padding: 7px 13px;
  border-radius: 7px 7px 0 0;
  color: #fff;
}
.groupprofilepage .rightContent h3 {
display: inherit;
}
.groupprofilepage .leftContent h3 {
display: inherit;
}
.groupprofilepage .rightContent #recentFilesPanel {
	margin:0;
}
.groupprofilepage .rightContent .profileSection .panelEmptyContent {
  margin: 12px;
}
.groupprofilepage .leftContent .profileSectionBody {
    margin: 12px;
}

.groupprofilepage .groupMembers.profileSection {
  margin-bottom: 10px;
}
.groupprofilepage .groupmanagementlink {
  padding: 4px 12px;
}

.profileTabSetContainer .profileOverview #profileAboutMe h3 {
  background-color: #be6054;
}


.profileTabSetContainer .profileOverview .content, 
.profileTabSetContainer .profileOverview .profileSectionBody,
.profileTabSetContainer .profileOverview .groupList, 
.profileTabSetContainer .profileOverview .panelEmptyContent{
  margin: 10px;
  min-height:150px;
}
 
.userProfilePage .profileHeader {
  display: none;
}

.userProfilePage .vfButtonBar #moreGroupsLink, .vfButtonBar a{
  margin: 7px;
  color: #fff;
}
.thumbnailPanel .thumbnailTable {
    margin: 12px;
}
.profileSection, .groupprofilepage .rightContent .groupmembership{
  margin-bottom: 10px;
  border: 1px solid #b0b5b9;
  border-radius: 9px;
}

#profileFeed .profileSection, .groupprofilepage .centerContent .profileSection{
  background-color: #be6054;
  padding: 30px;
  border: none;
}

#profileFeed #feedwrapper, .groupprofilepage .centerContent #feedwrapper{
  background-color: #fff;
  padding: 10px;
  border-radius: 7px;
}

#profileFeed #publishersharebutton, .publishercontainer.defaultState #publishersharebutton{
  background: #354961;
  border: none;
  box-shadow: none;
  padding: 0 16px;
  font-weight: normal;
}

.userProfilePage .headerContent { width: 100%; }

.userProfilePage .leftContent .influenceBoxHeader { display: none; }
.userProfilePage .leftContent .influence-widget { display: none; }
.userProfilePage .leftContent .influence { display: none; }

.userProfilePage .rightContent {
  width: 22%;
  padding: 0 20px 0 0;
}
.userProfilePage .centerContent {
  width: 66%;
}

.userProfilePage .profileTools{
    float: right;
    width: 32%;
    background: #5D7A98;
    border-radius: 7px;
    margin-right: 10px;
    text-align: center;
}

.userProfilePage .profileTools #USER_DETAIL{
	color: rgb(255, 255, 255);
	text-transform: uppercase;
	font-size: 12px;
	line-height: 38px;
}

.userProfilePage .profileTools #USER_DETAIL .settingIcon {
    background: url("/alumni/resource/acfComm__communitysprite") -28px 0 transparent;
    padding: 6px 14px;
    margin-right: 3px;
}

.userProfilePage .profileTools #USER_DETAIL .settingIcon {
    background: url("/alumni/resource/acfComm__communitysprite") -28px 0 transparent;
    padding: 6px 14px;
    margin-right: 3px;
}

.userProfilePage .profileTools .zen {
    padding: 7px 0px;
    float: left;
    margin-left: 10%;
}
.userProfilePage .profileTools .zen .zen-select .zen-selectArrow{
	display: none;
}
.userProfilePage .profileTools .zen .zen-mediaExt a, .userProfilePage .profileTools .zen .zen-mediaExt .zen-mediaBody, .userProfilePage .profileTools .sendPrivateMessage a {
    color: #fff;
    text-transform: uppercase;
}
.userProfilePage .profileTools .zen .zen-mediaExt .zen-imgExt {
    margin: -4px 0 0;
}

.userProfilePage .profileTools .zen .zen-mediaExt img {
    background: url("/alumni/resource/acfComm__communitysprite") repeat scroll -97px -2px transparent;
    padding: 4px 3px;
}
.userProfilePage .profileTools .zen .zen-mediaExt img.chatter-unfollowIcon {
    background: url("/img/feeds/follow_sprite.png") 0 -50px transparent;
}
.userProfilePage .profileTools .sendPrivateMessage{
    border: none;
    margin: 0;
	padding: 10px 0 0;
}



.userProfilePage .profileTabSetContainer .profileMoreTrigger .profileMoreTriggerIcon {
    background: url("/alumni/resource/acfComm__communitysprite") repeat scroll 0 -48px transparent;
    border: medium none;
    padding: 10px;
    margin-top: 8px;
    right: 8px;
}
.chatter-avatarFull.chatter-externalIndicator .chatter-avatarStyle{
	display: none;
}
/* @end */


/* @group NEW WRAPPER */
html .brandQuaternaryBgr {
  background: #708090;
}

.hasMotif {
  margin: 25px 25px 0;
}

#hdrBlock {
  background-color: #fff;
  padding: 20px;
  border-radius: 25px 25px 0 0;
  /*border-bottom: 1px solid #ccc;*/
  margin: 0;
}

#hdrBlock .logo {
  text-align: center;
}

#hdrBlock .links {
  float: right;
  color: #353535;
  font-weight: bold;
  }

#hdrBlock .links a{
  text-decoration: none;
  font-weight: normal;
  text-transform: uppercase;
}

.bPageHeader .zen, div[role="banner"] header{
  background: #fff;
  padding: 10px 10px;
}

.ChatterPage .zen .zen-bodyZen, .zen .zen-bodyZen { border:none; }

.zen .zen-page {
    width: 100%;
    padding: 0;
}

.zen #tabContainer {
  background: #fff;
  border-radius: 0;
  box-shadow: none;
}

.bPageHeader nav, #tabContainer nav {
  text-align: center;
  background: #2A3E56;
  border-radius: 10px;
}

.zen .zen-tabMenu {
  padding: 0;
}

.zen .zen-tabMenu>li {
  height: 50px;
  line-height: 50px;
  padding: 0 20px;
}

.zen .zen-tabMenu .zen-active {
  border-radius: 0px;
  box-shadow: none;
  background: #136398 !important;
  border: 1px solid #fff;
  border-width: 0 1px;
  padding: 0 20px;
  font-size: 14px;
}

.zen .zen-tabMenu a {
  color: #fff;
  font-weight: normal;
  text-transform: uppercase;
}

html .brandPrimaryBrd {
border: none;
}

.bodyDiv {
  margin: 0;
  border-radius: 0;
  box-shadow: none;
}

#ftrBlock {
  border-radius: 0;
  margin: 0;
  float: none;
  clear: both;
  text-align: center;
}

#ftrBlock .ftrTopSection{ background-color: #263441;padding:25px;}

#ftrBlock .ftrBottomSection{ background: #192734;padding:25px;}

#ftrBlock .ftrTopSection ul, #ftrBlock .ftrBottomSection ul { margin: 0;}
#ftrBlock .ftrTopSection ul.inline-items li {
    display: inline-block;
}
#ftrBlock .ftrTopSection ul.inline-items li a,#ftrBlock .ftrBottomSection ul.partner-promos li a {
    font-family: "Franklin ITC",sans-serif;
    font-weight: bold;
    color: #ddd;
}

#ftrBlock .ftrBottomSection ul.partner-promos li {
    display: inline-block;
    vertical-align: middle;
    min-height: 90px;
}


#contentWrapper {
}

.outer td.oRight {
    padding: 10px 10px 20px;
}

.errorMsg {
    color: #cc0000;
}

.helpBubbleCommon { display: none !important; }

/* @end */



