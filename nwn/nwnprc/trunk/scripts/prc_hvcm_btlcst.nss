// Written by Stratovarius
// Turns Battlecast on and off for the Havoc Mage.

#include "prc_spell_const"
#include "prc_ipfeat_const"
#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    string sMsg;

    if (!GetLocalInt(oPC, "HavocMageBattlecast"))
    {
        // Activate
        effect eFeat = EffectBonusFeat(FEAT_EPIC_IMPROVED_COMBAT_CASTING);
        eFeat = UnyieldingEffect(eFeat);
        TagEffect(eFeat, "BATTLECAST_FEAT");

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFeat, oPC);
        SetLocalInt(oPC, "HavocMageBattlecast", TRUE);

        sMsg = "*Battlecast Activated*";
    }
    else
    {
        // Deactivate: remove the tagged unyielding effect
        effect e = GetFirstEffect(oPC);
        while (GetIsEffectValid(e))
        {
            if (GetEffectTag(e) == "BATTLECAST_FEAT")
            {
                RemoveEffect(oPC, e);
                break;
            }
            e = GetNextEffect(oPC);
        }

        DeleteLocalInt(oPC, "HavocMageBattlecast");
        sMsg = "*Battlecast Deactivated*";
    }

    FloatingTextStringOnCreature(sMsg, oPC, FALSE);
}



/* void main()
{

    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    string nMes = "";

    if(!GetLocalInt(oPC, "HavocMageBattlecast"))
    {
        SetLocalInt(oPC, "HavocMageBattlecast", TRUE);
        //AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(IP_CONST_IMP_CC), oSkin);
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_IMP_CC), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        nMes = "*Battlecast Activated*";
    }
    else
    {
        // Removes effects
        PRCRemoveSpellEffects(SPELL_BATTLECAST, oPC, oPC);
        DeleteLocalInt(oPC, "HavocMageBattlecast");
        nMes = "*Battlecast Deactivated*";
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_IMP_CC);
    }

    FloatingTextStringOnCreature(nMes, oPC, FALSE);
} */