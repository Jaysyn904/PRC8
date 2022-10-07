//::///////////////////////////////////////////////
//:: Draconic Aura Exit
//:: prc_dracaura_out.nss
//::///////////////////////////////////////////////
/*
    Handles PCs leaving the Aura AoE for all
    draconic auras.
*/
//:://////////////////////////////////////////////
//:: Created By: xwarren
//:: Created On: Apr 2, 2011
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    //Declare major variables
    object oAura = OBJECT_SELF;
    object oTarget = GetExitingObject();
    object oShaman = GetAreaOfEffectCreator();
    int nAuraID = GetLocalInt(oAura, "SpellID");
    int nDamageType = GetLocalInt(oAura, "DamageType");

    if(GetHasSpellEffect(nAuraID, oTarget))
    {
        if(nAuraID == SPELL_SECOND_AURA_MAGICPOWER && GetLocalInt(oTarget, "MagicPowerAura") == GetLocalInt(oShaman, "MagicPowerAura"))
            DeleteLocalInt(oTarget,"MagicPowerAura");
        else if(nAuraID == SPELL_SECOND_AURA_ENERGY)
        {
            if((GetLocalInt(oTarget, "AcidEnergyAura") == GetLocalInt(oShaman, "AcidEnergyAura"))
            && nDamageType == DAMAGE_TYPE_ACID)
                DeleteLocalInt(oTarget, "AcidEnergyAura");
            if((GetLocalInt(oTarget, "ColdEnergyAura") == GetLocalInt(oShaman, "ColdEnergyAura"))
            && nDamageType == DAMAGE_TYPE_COLD)
                DeleteLocalInt(oTarget, "ColdEnergyAura");
            if((GetLocalInt(oTarget, "ElecEnergyAura") == GetLocalInt(oShaman, "ElecEnergyAura"))
            && nDamageType == DAMAGE_TYPE_ELECTRICAL)
                DeleteLocalInt(oTarget, "ElecEnergyAura");
            if((GetLocalInt(oTarget, "FireEnergyAura") == GetLocalInt(oShaman, "FireEnergyAura"))
            && nDamageType == DAMAGE_TYPE_FIRE)
                DeleteLocalInt(oTarget, "FireEnergyAura");
        }

        //Search through the valid effects on the target.
        effect eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == oShaman)
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == nAuraID)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}
