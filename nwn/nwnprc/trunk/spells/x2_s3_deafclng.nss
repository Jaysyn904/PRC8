//::///////////////////////////////////////////////
//:: OnHitCastSpell Deafening Clang
//:: x2_s3_deafclng
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
   * OnHit 100% chance to deafen enemy for
     1 round per casterlevel

   * Fort Save DC 10+CasterLevel negates

   * Standard level used by the deafening clang
     spellscript is 5.


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-19
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_combat"

void main()
{
    object oSpellOrigin = OBJECT_SELF;
    object oSpellTarget = PRCGetSpellTargetObject(oSpellOrigin);
    object oItem        = PRCGetSpellCastItem(oSpellOrigin);

    // route all onhit-cast spells through the unique power script (hardcoded to "prc_onhitcast")
    // in order to fix the Bioware bug, that only executes the first onhitcast spell found on an item
    // any onhitcast spell should have the check ContinueOnHitCast() at the beginning of its code
    // if you want to force the execution of an onhitcast spell script (that has the check) without routing the call
    // through prc_onhitcast, you must use ForceExecuteSpellScript(), to be found in prc_inc_spells
    if(!ContinueOnHitCastSpell(oSpellOrigin)) return;

    if(!GetIsObjectValid(oItem) || GetIsObjectValid(oSpellTarget))
        return;

    // you can not be deafened if you already can not hear.
    if(!PRCGetHasEffect(EFFECT_TYPE_SILENCE, oSpellTarget)
    && !PRCGetHasEffect(EFFECT_TYPE_DEAF, oSpellTarget))
    {
        int nCasterLevel = GetLocalInt(oItem, "X2_Wep_Caster_Lvl_DC");
        int nPenetr = GetLocalInt(oItem, "X2_Wep_Penetr_DC");
        if (!PRCDoResistSpell(oSpellOrigin, oSpellTarget, nPenetr))
        {
            int nDC= nCasterLevel + 10;
            if (!PRCMySavingThrow(SAVING_THROW_FORT, oSpellTarget, nDC, SAVING_THROW_TYPE_SONIC, oSpellOrigin))
            {
                effect eDeaf = EffectDeaf();
                effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDeaf,oSpellTarget,RoundsToSeconds(nCasterLevel));
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSpellTarget);
                FloatingTextStrRefOnCreature(85388,oSpellTarget,FALSE);
            }
        }
    }
}
