//::///////////////////////////////////////////////
//:: Power Attack evaluation script
//:: prc_powatk_eval
//::///////////////////////////////////////////////
/** @file
    Ran from EvalPRCFeats(). Checks if the creature
    has Power Attack and gives them the PRC Power
    Attack feats to skin if they do.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
// x - moved to prc_feats.nss
#include "prc_alterations"

void main()
{
/*    object oPC = OBJECT_SELF;

    if(GetPRCSwitch(PRC_POWER_ATTACK) == PRC_POWER_ATTACK_DISABLED)
        return;

    if(GetHasFeat(FEAT_POWER_ATTACK) && !GetHasFeat(FEAT_POWER_ATTACK_QUICKS_RADIAL))
    {
        if(DEBUG) DoDebug("prc_powatk_eval: Adding the PRC Power Attack radials", oPC);
        object oSkin = GetPCSkin(oPC);

        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_POWER_ATTACK_SINGLE_RADIAL),     0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_POWER_ATTACK_FIVES_RADIAL),      0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_PRC_POWER_ATTACK_QUICKS_RADIAL), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }*/
}