//::///////////////////////////////////////////////
//:: Disciple of Asmodeus
//:: prc_discasmodeus.nss
//:://////////////////////////////////////////////
//:: Applies Disciple of Asmodeus Bonuses
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Jan 27, 2006
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
	object oPC = OBJECT_SELF;
        int nClass = GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oPC);
        // Does the +2 AC/Saves/Attack
        if (nClass >= 10) ActionCastSpellOnSelf(SPELL_DISCIPLE_ASMODEUS_DREAD_MIGHT);    
}