//::///////////////////////////////////////////////
//:: Name Spider's Grace
//:: FileName prc_dj_spidgrace
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Spider's Grace feat
*/
//:://////////////////////////////////////////////
//:: Created By: PsychicToaster
//:: Created On: 7-31-04
//:://////////////////////////////////////////////
#include "prc_alterations"
void main()
{
//Debug
//SpeakString("Placeholder Grace");


object oPC     = OBJECT_SELF;

effect eHide   = EffectSkillIncrease(SKILL_HIDE, 4);
effect eMove   = EffectSkillIncrease(SKILL_MOVE_SILENTLY, 4);
effect eImmWeb = EffectSpellImmunity(SPELL_WEB);
effect eImmEnt = EffectSpellImmunity(SPELL_ENTANGLE);

effect eVis    = EffectVisualEffect(VFX_DUR_WEB);
effect eVis2   = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);

effect eLink   = EffectLinkEffects(eHide, eMove);
effect eLink2  = EffectLinkEffects(eImmWeb, eImmEnt);

ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 600.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oPC, 600.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 2.5);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oPC);

}
