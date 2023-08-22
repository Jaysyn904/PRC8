////////////////////////////////////////////////////////
// Softfoot
// sp_softfoot.nss
////////////////////////////////////////////////////////

/*
Softfoot: Softfoot is a fine gray powder that muffles
sound when applied to the bottom of a foot or boot. It
provides a +1 alchemical bonus on Move Silently checks
for 1 hour.
One dose of softfoot is enough to affect one Medium
creature that has one pair of feet; each additional pair
of feet (or similar appendages) requires another dose.
Applying softfoot is a standard action that provokes
attacks of opportunity. If softfoot is applied over a boot
or other foot covering, its benefit is lost if the foot covering
is removed. Likewise, if it is applied to a creature’s
skin or hide, its benefit is lost if the creature later dons
footwear.
*/

#include "prc_inc_spells"

void main()
{
        object oTarget = PRCGetSpellTargetObject();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_MOVE_SILENTLY,1), oTarget, HoursToSeconds(1));
        SendMessageToPC(oTarget, "Your footsteps are muffled.");
}