//////////////////////////////////////////////////////////////
// Keenear Powder
// sp_keenear.nss
//////////////////////////////////////////////////////////////

/*
Keenear Powder: This dry white powder sharpens a
creature’s hearing when applied to the ear. The powder
is effective for only a short time, so it is more often used
by those trying to avoid guards or sentries than by those
tasked with guarding an area for a longer time. Keenear
powder provides a +1 alchemical bonus on Listen checks
for 1 minute.
One dose of keenear powder is enough to affect the
hearing of a creature of any size, but the creature must
have ears to gain any benefit from the powder. Applying
keenear powder is a standard action that provokes attacks
of opportunity.
*/

#include "prc_inc_spells"

void main()
{
        object oTarget = PRCGetSpellTargetObject();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_LISTEN, 1), oTarget, TurnsToSeconds(1));
        SendMessageToPC(oTarget, "Your hearing is enchanced.");
}