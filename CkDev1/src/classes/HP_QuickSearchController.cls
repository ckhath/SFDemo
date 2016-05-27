public class HP_QuickSearchController{
    public ProfileDomainName__c profileDomainCustomSetting {get; set;}
    public String profileDomain{ get; set; }
    public String headerType { get; set; }
    //constructor
    public HP_QuickSearchController(){
        profileDomainCustomSetting = UtilityGeneral.getProfileDomainName();
        profileDomain = profileDomainCustomSetting.DomainName__c;
        CommunityCSSHeaders commHeaders = new CommunityCSSHeaders();
        headerType = commHeaders.getHeadersType();
    }//End constructor
}//End class