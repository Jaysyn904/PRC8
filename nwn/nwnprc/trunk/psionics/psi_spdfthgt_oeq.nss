//::///////////////////////////////////////////////
//:: Speed of Thought onequip script
//:: psi_spdfthgt_oeq
//:://////////////////////////////////////////////
/** @file
	Removes the Speed of Thought bonus if
	equipper equipped heavy armor.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 23.03.2005
//:: Modified On: 11.07.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

void main()
{
    object oCreature = GetItemLastEquippedBy();
    if(GetBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature)) >= 6)
        PRCRemoveSpellEffects(SPELL_FEAT_SPEED_OF_THOUGHT_BONUS, oCreature, oCreature);
}