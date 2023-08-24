//::///////////////////////////////////////////////
//:: Mental Leap spellscript
//:: psi_mental_leap
//::///////////////////////////////////////////////
/*
    Makes a jump with +10 bonus to skill.
    
    Using Mental Leap requires expending psionic focus.
*/
//:://////////////////////////////////////////////
//:: Modified By: Ornedan
//:: Modified On: 22.03.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_feat_const"
#include "psi_inc_psifunc"
#include "prc_inc_skills"

void main()
{
    object oPC = OBJECT_SELF;
    
    if(!UsePsionicFocus(oPC)){
        SendMessageToPC(oPC, "You must be psionically focused to use this feat");
        return;
    }
    
    effect eJump = EffectSkillIncrease(SKILL_JUMP, 10);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eJump, oPC, 6.0f);
    
    PerformJump(oPC, PRCGetSpellTargetLocation(), TRUE);
    //AssignCommand(oPC, ActionCastSpellAtLocation(SPELL_JUMP, PRCGetSpellTargetLocation(), METAMAGIC_NONE, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
}