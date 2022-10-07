//////////////////////////////////////////////////////////////
// Lockslip Grease
// sp_lockslip.nss
//////////////////////////////////////////////////////////////
/* Lockslip Grease: Lockslip grease is a thick reddish
oil that loosens the mechanical workings of nonmagical
locks. The grease is effective for a short time and
provides a slight edge to those attempting to pick a
lock. Lockslip grease provides a +1 alchemical bonus
on Open Lock checks made against the affected lock
for 1 minute.
One dose of lockslip grease is enough to affect the
mechanism of a lock of any size. Although lockslip grease
can affect any kind of mundane mechanical lock, it has no
effect on magic locks. Applying lockslip grease to a lock is
a standard action that provokes attacks of opportunity.*/


#include "prc_inc_spells"

void main()
{
        object oTarget = PRCGetSpellTargetObject();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_OPEN_LOCK, 1), oTarget, TurnsToSeconds(1));
        SendMessageToPC(oTarget, "You apply the lockslip grease to your tools.");
}