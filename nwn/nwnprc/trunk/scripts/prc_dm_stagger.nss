#include "prc_inc_combmove"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nAoO = TRUE;
    if (GetIsSkillSuccessful(oPC, SKILL_TUMBLE, 15)) nAoO = FALSE;
    DoCharge(oPC, oTarget, TRUE, nAoO);
}
