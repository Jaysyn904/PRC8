////////////////////////////////////////////////////////
// Fareye Oil
// sp_fareyeoil.nss
////////////////////////////////////////////////////////
/* Fareye Oil: When applied to the eyes, this clear oil
sharpens the user’s vision for a short time, providing a
+1 alchemical bonus on Spot checks for 1 minute.
One dose of fareye oil is enough to affect the eyes of
a creature of any size, but the creature must have eyes
to gain any benefit from the oil. Applying fareye oil is a
standard action that provokes attacks of opportunity. */

#include "prc_inc_spells"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_SPOT, 1), oTarget, TurnsToSeconds(1));
    SendMessageToPC(oTarget, "Your vision sharpens.");
}