//::///////////////////////////////////////////////
//:: Chosen of Iborighu
//:: prc_chn_iborighu.nss
//::///////////////////////////////////////////////
/*
    Once per day, you can cause one creature within 
    30 feet that meets your gaze to become overwhelmed
    with a wave of supernatural cold. The target can 
    resist the effects of this attack with a successful 
    Fortitude save (DC 10 + 1/2 your character level + 
    your Charisma modifi er), otherwise it causes cold 
    damage equal to your Charisma modifi er + 3 (minimum 
    1 point of damage) and causes the victim to become 
    fatigued. If you use this attack against someone who 
    is fatigued, they instead become exhausted. Using 
    this supernatural ability is a standard action that 
    does not provoke attacks of opportunity.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 30.10.2018
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_BREACH);
    int nDC = 10 + GetHitDice(oPC)/2 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    effect eLink = EffectFatigue();
    effect eDam = EffectDamage(GetAbilityModifier(ABILITY_CHARISMA, oPC) + 3, DAMAGE_TYPE_COLD);
    
    if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget);  
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }    
}
