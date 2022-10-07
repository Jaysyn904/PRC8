#include "prc_inc_smite"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nRace = MyPRCGetRacialType(oTarget);
    
    DecrementRemainingFeatUses(oPC, FEAT_KILLOREN_ASPECT_A);
    DecrementRemainingFeatUses(oPC, FEAT_KILLOREN_ASPECT_H);    
    
    if(nRace == RACIAL_TYPE_DWARF
    || nRace == RACIAL_TYPE_ELF
    || nRace == RACIAL_TYPE_GNOME
    || nRace == RACIAL_TYPE_HALFLING
    || nRace == RACIAL_TYPE_HALFELF
    || nRace == RACIAL_TYPE_HALFORC
    || nRace == RACIAL_TYPE_HUMAN
    || nRace == RACIAL_TYPE_HUMANOID_GOBLINOID
    || nRace == RACIAL_TYPE_HUMANOID_MONSTROUS
    || nRace == RACIAL_TYPE_HUMANOID_ORC
    || nRace == RACIAL_TYPE_HUMANOID_REPTILIAN
    || nRace == RACIAL_TYPE_ABERRATION
    || nRace == RACIAL_TYPE_CONSTRUCT
    || nRace == RACIAL_TYPE_OOZE
    || nRace == RACIAL_TYPE_OUTSIDER
    || nRace == RACIAL_TYPE_UNDEAD) 
        DoSmite(oPC, oTarget, SMITE_TYPE_KILLOREN);

    if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack") && GetHasFeat(FEAT_KILLOREN_DESTROYER, oPC)) 
    {    
        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
        effect eDaze = EffectDazed();
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

        effect eLink = EffectLinkEffects(eMind, eDaze);
        eLink = EffectLinkEffects(eLink, eDur);
        int nDC = 10 + GetHitDice(oPC)/2 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
        //Make Will Save to negate effect
        if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
        {
            //Apply VFX Impact and daze effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
        }        
    }
}