/**
 * Dirgesinger: Song of Awakening
 * Stratovarius
 */

#include "prc_inc_clsfunc"

void main()
{
    string sSummon;
    object oCreature;
    object oPC = OBJECT_SELF;
    int nHD = GetHitDice(oPC);

    if (!GetHasFeat(FEAT_BARD_SONGS, oPC))
    {
        FloatingTextStrRefOnCreature(85587,oPC); // no more bardsong uses left
        return;
    }
    
    if(GetHasSpellEffect(GetSpellId()))
    {
        FloatingTextStringOnCreature("Only one awakened undead allowed at a time", oPC); 
        return;
    }    

    DecrementRemainingFeatUses(oPC, FEAT_BARD_SONGS);

    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,oPC))
    {
        FloatingTextStrRefOnCreature(85764,oPC); // not useable when silenced
        return;
    }

    if (nHD >= 34)        sSummon = "prc_sum_dbl";
    else if (nHD >= 31)   sSummon = "prc_sum_dk";
    else if (nHD >= 28)   sSummon = "prc_sum_vamp2";
    else if (nHD >= 25)   sSummon = "prc_sum_bonet";
    else if (nHD >= 22)   sSummon = "prc_sum_wight";
    else if (nHD >= 19)   sSummon = "prc_sum_vamp1";
    else if (nHD >= 16)   sSummon = "prc_sum_grav";
    else if (nHD >= 13)   sSummon = "prc_tn_fthug";
    else if (nHD >= 10)   sSummon = "prc_sum_mohrg";

    effect eSummon = EffectSummonCreature(sSummon, VFX_FNF_SUMMON_UNDEAD);
    //Apply summon effect and VFX impact.
    MultisummonPreSummon();
    //CorpseCrafter(oPC, oCreature);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), RoundsToSeconds(10));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oPC, RoundsToSeconds(10));
}
