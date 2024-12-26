//::///////////////////////////////////////////////
//:: Summon Cohort
//:: Cohort
//:://////////////////////////////////////////////
/*
    Summons a Rashemen Barbarian as a Hathran cohort
*/
//:://////////////////////////////////////////////
//:: Created By: Sir Attilla
//:: Created On: January 3 , 2004
//:: Modified By: Stratovarius, bugfixes.
//:://////////////////////////////////////////////

#include "prc_class_const"

void main()
{
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    
    int nMaxHenchmen = GetMaxHenchmen();
    SetMaxHenchmen(99);    

	int nMax = d4(2);
    int i;
    for (i = 1; i <= nMax; i++)
    {
		object oCreature = CreateObject(OBJECT_TYPE_CREATURE, "prc_wrsl_war", GetSpellTargetLocation());
		AddHenchman(OBJECT_SELF, oCreature);
    }

    SetMaxHenchmen(nMaxHenchmen);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
}



