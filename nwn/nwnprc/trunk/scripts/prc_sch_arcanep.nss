//::///////////////////////////////////////////////
//:: Song of Arcane Power
//:: prc_sch_cosmfire.nss
//:://////////////////////////////////////////////
/*
// Bonus to caster level.
// Depends on Perform skill check.
*/
//:://////////////////////////////////////////////
//:: Created By: xwarren
//:: Created On: Dec 8, 2009
//:://////////////////////////////////////////////
#include "prc_alterations"

void main()
{
    object oCaster = OBJECT_SELF;

    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }
    else if(GetSkillRank(SKILL_PERFORM, oCaster) < 12)
    {
        FloatingTextStringOnCreature("You need 12 or more ranks in perform skill.", oCaster, FALSE);
        return;
    }
    else if (!GetHasFeat(FEAT_BARD_SONGS, oCaster))
    {
        //SpeakStringByStrRef(40550);
        FloatingTextStringOnCreature("No Bard Song uses!", oCaster, FALSE);
        return;
    }
    else
    {
        DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);
        //Declare major variables
        int nPerform = d20(1) + GetSkillRank(SKILL_PERFORM, oCaster);
        int nBonus;
        effect eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);
        eVis = EffectLinkEffects(eVis, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));


        if(nPerform >= 30)
            nBonus = 4;
        else if(nPerform < 30 && nPerform >= 20)
            nBonus = 2;
        else if(nPerform < 20 && nPerform >= 10)
            nBonus = 1;
        else
            nBonus = 0;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCaster, 9.0f);
        SetLocalInt(oCaster, "SongOfArcanePower", nBonus);
        DelayCommand(9.0f, DeleteLocalInt(oCaster, "SongOfArcanePower"));
    }
}

