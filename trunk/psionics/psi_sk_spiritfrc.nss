//::///////////////////////////////////////////////
//:: Spiritual Force
//:: psi_sk_spiritfrc
//::///////////////////////////////////////////////
/*
    Expends the Psionic Focus to grant Cha to damage 
    for 1 round to your mindblade.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: 2008.2.14
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"
#include "psi_inc_psifunc"


void main()
{
    object oPC = OBJECT_SELF;
    
    // Make sure the PC is wielding at least one mindblade
    if(!(GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)), 14) == "prc_sk_mblade_" ||
         GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,  oPC)), 14) == "prc_sk_mblade_"
       ) )
    {
        // Inform the player and return
        SendMessageToPCByStrRef(oPC, 16824509); // "You must have a mindblade manifested to use this feat."
        return;
    }
    
    if(!UsePsionicFocus(oPC)){
        SendMessageToPC(oPC, "You must be psionically focused to use this feat");
        return;
    }

    //Add Charisma to damage
    int nDmgBonus = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    effect eDmgBonus = EffectDamageIncrease(nDmgBonus, DAMAGE_TYPE_SLASHING);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDmgBonus, oPC, RoundsToSeconds(1));
}
