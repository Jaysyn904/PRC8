#include "prc_ipfeat_const"
#include "prc_feat_const"
#include "prc_inc_skin"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    if(GetHasFeat(FEAT_NS_WEBWALKER, oPC))
    {
        if(GetLocalInt(oSkin, "ImmuNSWeb"))
            return;

        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_WEB), oSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_BELETITH_WEB), oSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_BOLT_WEB), oSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_NS_WEB), oSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SHADOW_WEB), oSkin);
        SetLocalInt(oSkin, "ImmuNSWeb", TRUE);
    }
    if(GetHasFeat(FEAT_NS_POISON_IMMUNE, oPC))
    {
        if(GetLocalInt(oSkin, "ImmuNSPoison"))
            return;

        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON), oSkin);
        SetLocalInt(oSkin, "ImmuNSPoison", TRUE);
    }
}