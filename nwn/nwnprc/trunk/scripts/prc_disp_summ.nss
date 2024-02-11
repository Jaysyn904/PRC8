//::///////////////////////////////////////////////
//:: Dispater Summon
//:: prc_disp_summ
//:://////////////////////////////////////////////
/*
    Summons an Eryines
    At level 9, Summons 1d4
*/
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    //Declare major variables
    int nRoll = d4();
    object oStone;
    int nDuration = 15;
    float fDelay = 3.0;
    effect eSummon = EffectSummonCreature("erinyes",VFX_FNF_SUMMON_GATE, fDelay);
    effect eSummon2 = EffectSummonCreature("erinyes", VFX_NONE, fDelay, 0);
    if (GetLevelByClass(CLASS_TYPE_DISPATER, OBJECT_SELF) < 9) nRoll = 1;

    if(nRoll == 4)
    {
        MultisummonPreSummon(OBJECT_SELF, TRUE);
        oStone = CreateObject(OBJECT_TYPE_ITEM, "summoningstone", GetSpellTargetLocation());
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
        DestroyObject(oStone);
    }
    else if(nRoll == 3)
    {
        MultisummonPreSummon(OBJECT_SELF, TRUE);
        oStone = CreateObject(OBJECT_TYPE_ITEM, "summoningstone", GetSpellTargetLocation());
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
        DestroyObject(oStone);
    }
    else if(nRoll == 2)
    {
        MultisummonPreSummon(OBJECT_SELF, TRUE);
        oStone = CreateObject(OBJECT_TYPE_ITEM, "summoningstone", GetSpellTargetLocation());
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
        DestroyObject(oStone);
    }    
    else if(nRoll == 1)
    {
        MultisummonPreSummon(OBJECT_SELF);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
    }
}
