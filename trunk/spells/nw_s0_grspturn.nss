 //::///////////////////////////////////////////////
//:: Greater Spell Turning
//:: NW_S0_GrSpTurn.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: [Description of File]
//:://////////////////////////////////////////////
//:: Created By: [Your Name]
//:: Created On: [date]
//:://////////////////////////////////////////////


 #include "prc_inc_spells"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

}

