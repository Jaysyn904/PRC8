//::///////////////////////////////////////////////
//:: Frostrager - One-Two Punch
//:://////////////////////////////////////////////
/*
    Gives and removes extra attack from PC
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sep 4, 2018
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    string sMes = "";

    if(!GetHasSpellEffect(SPELL_ONETWO_PUNCH))
    {
            ActionCastSpellOnSelf(SPELL_ONETWO_PUNCH);
    }
    else
    {
         // Removes effects
         PRCRemoveEffectsFromSpell(OBJECT_SELF, SPELL_ONETWO_PUNCH);

         // Display message to player
         sMes = "One-Two Punch Deactivated";
    }
    FloatingTextStringOnCreature(sMes, OBJECT_SELF, FALSE);
}