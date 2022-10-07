//::///////////////////////////////////////////////
//:: Shou Disciple - Martial Flurry
//:://////////////////////////////////////////////
/*
    Gives and removes extra attack from PC
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Aug 23, 2004
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    string sMes = "";

    if(!GetHasSpellEffect(SPELL_MARTIAL_FLURRY_ALL) && !GetHasSpellEffect(SPELL_MARTIAL_FLURRY_LIGHT))
    {
        if(GetLevelByClass(CLASS_TYPE_SHOU) > 4)
            ActionCastSpellOnSelf(SPELL_MARTIAL_FLURRY_ALL);
        else if(GetLevelByClass(CLASS_TYPE_SHOU) > 2)
            ActionCastSpellOnSelf(SPELL_MARTIAL_FLURRY_LIGHT);
    }
    else
    {
         // Removes effects
         PRCRemoveEffectsFromSpell(OBJECT_SELF, SPELL_MARTIAL_FLURRY_LIGHT);
         PRCRemoveEffectsFromSpell(OBJECT_SELF, SPELL_MARTIAL_FLURRY_ALL);

         // Display message to player
         sMes = "*Martial Flurry Deactivated*";
    }
    FloatingTextStringOnCreature(sMes, OBJECT_SELF, FALSE);
}