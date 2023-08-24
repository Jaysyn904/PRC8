//////////////////////////////////////////////////////////////
// Weeping Stone
// sp_weepstn.nss
/////////////////////////////////////////////////////////////
/*
Weeping Stone: Created through alchemical processes
that inflict terrible—and sometimes lethal—pain on a
living being, a weeping stone causes anyone touching it to
his or her face to begin to weep and feel great sorrow. Such a
character is considered shaken for 1d6 rounds.
*/

#include "prc_inc_sp_tch"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    int nTouch = PRCDoRangedTouchAttack(oTarget);

    if(nTouch)
    {
        int nRounds = d6(1);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oTarget, RoundsToSeconds(nRounds));
    }
}