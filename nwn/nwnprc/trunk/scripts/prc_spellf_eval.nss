/*

    prc_spellf_eval.nss - Spellfire feat evaluation a la power attack

    By: Flaming_Sword
    Created: December 19, 2005
    Modified: December 27, 2005

*/

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetHasFeat(FEAT_SPELLFIRE_WIELDER, oPC)) //sanity check
    {
        if(!GetHasFeat(FEAT_SPELLFIRE_QUICKSELECT))
        {
            if(DEBUG) DoDebug("prc_spellf_eval: Adding the Spellfire radials", oPC);
            object oSkin = GetPCSkin(oPC);

            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SPELLFIRE_INCREASE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SPELLFIRE_DECREASE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SPELLFIRE_QUICKSELECT), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(!GetLocalInt(oPC, "SpellfireOnhit") && GetLevelByClass(CLASS_TYPE_SPELLFIRE, oPC))
        {   //only spellfire channelers need to have the onhit
            if(DEBUG) DoDebug("prc_spellf_eval: Adding the onhit armour maintainer", oPC);
            SetLocalInt(oPC, "SpellfireOnhit", 1);  //let's make sure this only runs once, shall we?
            ExecuteScript("prc_keep_onhit_a", oPC);
        }
    }


    //prc_keep_onhit_a
}