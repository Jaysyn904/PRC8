//::///////////////////////////////////////////////
//:: Death Touch
//:: prc_to_deathtouch
//:://////////////////////////////////////////////
/*
    Thrall of Orcus may kill their foes.

    -Requires melee Touch attack
    -Save vs DC of 10 + Class Level + Cha bonus

*/

#include "prc_inc_sp_tch"

void main()
{
    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();

    //Declare effects
    effect eSlay = EffectDeath();
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVis2 = EffectVisualEffect(VFX_IMP_DEATH);
    int nClass = GetLevelByClass(CLASS_TYPE_ORCUS, OBJECT_SELF);
    int nCha = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    int nSave = 10 + nCha + nClass;

    //Link effects

    if(PRCDoMeleeTouchAttack(oTarget))
    {
        //Saving Throw

        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSave, SAVING_THROW_TYPE_NEGATIVE))
        {
            //Apply effects to target and caster
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSlay, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        }
    }

}
