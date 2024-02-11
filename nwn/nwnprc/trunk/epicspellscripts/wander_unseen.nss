//:://////////////////////////////////////////////
//:: FileName: "wander_unseen"
/*   Purpose: Wander Unseen - this is the ability that is granted to a player
        as the result of an Unseen Wanderer epic spell. Using this feat will
        either turn the player invisible, or if already in that state, visible
        again.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 13, 2004
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_ILLUSION);

    if(GetHasSpellEffect(SPELL_WANDER_UNSEEN))
        PRCRemoveEffectsFromSpell(OBJECT_SELF, SPELL_WANDER_UNSEEN);
    else
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectInvisibility(INVISIBILITY_TYPE_NORMAL)), OBJECT_SELF);

    PRCSetSchool();
}