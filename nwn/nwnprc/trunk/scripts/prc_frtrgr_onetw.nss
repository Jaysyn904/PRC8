//::///////////////////////////////////////////////
//:: Frostrager - One-Two Punch
//:://////////////////////////////////////////////
/*
    This is the spell cast on the Frostrager to apply the effects
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sep 4, 2018
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    object oPC = PRCGetSpellTargetObject();

    // Removes effects
    PRCRemoveEffectsFromSpell(oPC, GetSpellId());

    string nMesL = "";
    object oWeapRL = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    if (GetBaseItemType(oWeapRL) == BASE_ITEM_INVALID) //Unarmed only
    {
        if(DEBUG) DoDebug("Frostrager One-Two: Right hand weapon is empty");
        effect addAttL = SupernaturalEffect( EffectModifyAttacks(1) );
        effect attPenL = SupernaturalEffect( EffectAttackDecrease(2) );
        effect eLinkL = EffectLinkEffects(addAttL, attPenL);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLinkL, oPC);
        nMesL = "One-Two Punch Activated";
    }
    else
    {
        nMesL = "*Invalid Weapon. Ability Not Activated!*";
    }

    FloatingTextStringOnCreature(nMesL, oPC, FALSE);
}