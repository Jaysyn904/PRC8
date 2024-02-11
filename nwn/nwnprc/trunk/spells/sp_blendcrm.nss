//////////////////////////////////////////////////
// Blend Cream
// sp_blendcrm.nss
///////////////////////////////////////////////////
/*
Blend Cream: This pale gray cream dulls the color of
flesh, fur, scales, and hair. It allows those affected to better
blend with background and shadow, making it easier to
hide.
Applying blend cream is a standard action that provokes
attacks of opportunity. Blend cream provides a +1
alchemical bonus on Hide checks. The effects of blend
cream last for 1 hour. Blend cream gives no ability to hide
in plain sight or without sufficient cover.
*/

#include "prc_inc_spells"

void main()
{
        object oTarget = PRCGetSpellTargetObject();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_HIDE, 1), oTarget, HoursToSeconds(1));
        SendMessageToPC(oTarget, "The color of your skin, hair, and clothing dulls.");
}