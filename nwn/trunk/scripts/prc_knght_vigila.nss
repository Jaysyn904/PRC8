//::///////////////////////////////////////////////
//:: Knight - Vigilant Defender, Enter
//:: prc_knght_vigil.nss
//:://////////////////////////////////////////////
//:: Tumble Pen = class level
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    int nKnight = GetLevelByClass(CLASS_TYPE_KNIGHT, GetAreaOfEffectCreator());
    effect eSkill = EffectSkillDecrease(SKILL_TUMBLE, nKnight);

    // Cleaned up on exit
    if (GetIsEnemy(oTarget, GetAreaOfEffectCreator())) SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSkill, oTarget);
}
