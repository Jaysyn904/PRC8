//::///////////////////////////////////////////////
//:: Shifter Traits
//:: race_shifter.nss
//::///////////////////////////////////////////////
/*
    Handles Eberron Shifters' shifting ability
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 19, 2008
//:://////////////////////////////////////////////

#include "prc_inc_function"
#include "prc_inc_natweap"

void ApplyPrimaryTrait(object oPC, int nAbility, int nDuration)
{
    effect eTrait = EffectAbilityIncrease(nAbility, 2);
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    eTrait = SupernaturalEffect(eTrait);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrait, oPC, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    DelayCommand(RoundsToSeconds(nDuration), ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC));
}

void main()
{

    object oPC = OBJECT_SELF;
    int nDuration = 3 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + GetShiftingFeats(oPC);
    int nPrimaryTrait = GetPersistantLocalInt(oPC, "FirstShifterTrait");
    
    if(GetIsPolyMorphedOrShifted(oPC))
    {
        SendMessageToPC(oPC, "You can only shift in your natural form.");
        return;
    }
    
    if(GetHasFeat(FEAT_SHIFTER_WILDHUNT, oPC))
    {
        if(nPrimaryTrait == FEAT_SHIFTER_WILDHUNT) 
            ApplyPrimaryTrait(oPC, ABILITY_CONSTITUTION, nDuration);

        //scent bonuses
        effect eTrait = EffectSkillIncrease(SKILL_SPOT, 4);
        eTrait = EffectLinkEffects(eTrait, EffectSkillIncrease(SKILL_SEARCH, 4));
        eTrait = EffectLinkEffects(eTrait, EffectSkillIncrease(SKILL_LISTEN, 4));
        if(GetHasFeat(FEAT_WILDHUNT_ELITE))
            eTrait = EffectLinkEffects(eTrait, EffectUltravision());
        eTrait = SupernaturalEffect(eTrait);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrait, oPC, RoundsToSeconds(nDuration));
    }
    
    if(GetHasFeat(FEAT_SHIFTER_RAZORCLAW, oPC))
    {
        if(nPrimaryTrait == FEAT_SHIFTER_RAZORCLAW) 
            ApplyPrimaryTrait(oPC, ABILITY_STRENGTH, nDuration);
            
        //primary weapon
        string sResRef = "prc_claw_1d6l_";
        int nSize = PRCGetCreatureSize(oPC);
        if(GetHasFeat(FEAT_SHIFTER_SAVAGERY) && GetHasFeatEffect(FEAT_FRENZY, oPC))
            nSize += 2;
        if(nSize > CREATURE_SIZE_COLOSSAL)
            nSize = CREATURE_SIZE_COLOSSAL;
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2);
        DelayCommand(RoundsToSeconds(nDuration), RemoveNaturalPrimaryWeapon(oPC, sResRef));
    }
    
    if(GetHasFeat(FEAT_SHIFTER_LONGTOOTH, oPC))
    {
        if(nPrimaryTrait == FEAT_SHIFTER_LONGTOOTH) 
            ApplyPrimaryTrait(oPC, ABILITY_STRENGTH, nDuration);
            
        
        string sResRef = "prc_raks_bite_";
        if(GetHasFeat(FEAT_LONGTOOTH_ELITE))
            sResRef = "prc_lngth_elt_";
        int nSize = PRCGetCreatureSize(oPC);
        if(GetHasFeat(FEAT_SHIFTER_SAVAGERY) && GetHasFeatEffect(FEAT_FRENZY, oPC))
            nSize += 2;
        if(nSize > CREATURE_SIZE_COLOSSAL)
            nSize = CREATURE_SIZE_COLOSSAL;
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
        DelayCommand(RoundsToSeconds(nDuration), RemoveNaturalSecondaryWeapons(oPC, sResRef));
    }
    
    if(GetHasFeat(FEAT_SHIFTER_LONGSTRIDE, oPC))
    {
        if(nPrimaryTrait == FEAT_SHIFTER_LONGSTRIDE) 
            ApplyPrimaryTrait(oPC, ABILITY_DEXTERITY, nDuration);
            
        effect eTrait = EffectMovementSpeedIncrease(33);
        if(GetHasFeat(FEAT_LONGSTRIDE_ELITE))
            eTrait = EffectMovementSpeedIncrease(67);
        if(GetHasFeat(FEAT_SHIFTER_AGILITY))
        {
            eTrait = EffectLinkEffects(eTrait, EffectACIncrease(1));
            eTrait = EffectLinkEffects(eTrait, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 1));
        }
        eTrait = SupernaturalEffect(eTrait);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrait, oPC, RoundsToSeconds(nDuration));
    }
    
    if(GetHasFeat(FEAT_SHIFTER_BEASTHIDE, oPC))
    {
        if(nPrimaryTrait == FEAT_SHIFTER_BEASTHIDE) 
            ApplyPrimaryTrait(oPC, ABILITY_CONSTITUTION, nDuration);
             
        effect eTrait = EffectACIncrease(2);
        if(GetHasFeat(FEAT_BEASTHIDE_ELITE))
            eTrait = EffectACIncrease(4);
        eTrait = SupernaturalEffect(eTrait);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrait, oPC, RoundsToSeconds(nDuration));
    }
    
    if(GetHasFeat(FEAT_SHIFTER_DREAMSIGHT, oPC))
    {
        if(nPrimaryTrait == FEAT_SHIFTER_DREAMSIGHT) 
            ApplyPrimaryTrait(oPC, ABILITY_WISDOM, nDuration);
            
        effect eTrait = EffectSkillIncrease(SKILL_ANIMAL_EMPATHY, 2);
        if(GetHasFeat(FEAT_DREAMSIGHT_ELITE))
        {
            eTrait = EffectLinkEffects(eTrait, EffectSeeInvisible());
            eTrait = EffectLinkEffects(eTrait, EffectSkillIncrease(SKILL_SPOT, 5));
        }
        eTrait = SupernaturalEffect(eTrait);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrait, oPC, RoundsToSeconds(nDuration));
    }
    
    if(GetHasFeat(FEAT_SHIFTER_GOREBRUTE, oPC))
    {
        if(nPrimaryTrait == FEAT_SHIFTER_GOREBRUTE) 
            ApplyPrimaryTrait(oPC, ABILITY_STRENGTH, nDuration);
            
        SetLocalInt(oPC, "ShifterGore", TRUE);
        DelayCommand(RoundsToSeconds(nDuration), DeleteLocalInt(oPC, "ShifterGore"));
    }
    
    if(GetHasFeat(FEAT_SHIFTER_WINTERHIDE, oPC))
    {
        if(nPrimaryTrait == FEAT_SHIFTER_WINTERHIDE) 
            ApplyPrimaryTrait(oPC, ABILITY_CONSTITUTION, nDuration);
            
        effect eTrait = EffectACIncrease(1, AC_NATURAL_BONUS);
        eTrait = EffectLinkEffects(eTrait, EffectDamageResistance(DAMAGE_TYPE_COLD, 5));

        eTrait = SupernaturalEffect(eTrait);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrait, oPC, RoundsToSeconds(nDuration));
    }    
    
    if(GetHasFeat(FEAT_HEALING_FACTOR))
    {
        effect eHeal = EffectHeal(GetHitDice(oPC));
        eHeal = EffectLinkEffects(eHeal, EffectVisualEffect(VFX_IMP_HEALING_L));
        DelayCommand(RoundsToSeconds(nDuration), ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC));
    }
    
    if(GetHasFeat(FEAT_SHIFTER_DEFENSE))
    {
        effect eDR = EffectDamageReduction(2, DAMAGE_POWER_PLUS_TWO);
        eDR = SupernaturalEffect(eDR);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDR, oPC, RoundsToSeconds(nDuration));
    }
    else if(GetHasFeat(FEAT_GREATER_SHIFTER_DEFENSE))
    {
        effect eDR = EffectDamageReduction(4, DAMAGE_POWER_PLUS_TWO);
        eDR = SupernaturalEffect(eDR);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDR, oPC, RoundsToSeconds(nDuration));
    }
    
    if(GetHasFeat(FEAT_SHIFTER_SAVAGERY) && GetHasFeatEffect(FEAT_FRENZY, oPC))
    {
        itemproperty ipSavage = ItemPropertyBonusFeat(IP_CONST_FEAT_ImpCritCreature);
        IPSafeAddItemProperty(GetPCSkin(oPC), ipSavage, RoundsToSeconds(nDuration), 
                               X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    
    if(GetHasFeat(FEAT_SHIFTER_FEROCITY))
    {
        itemproperty ipSavage = ItemPropertyBonusFeat(IP_CONST_FEAT_REMAIN_CONCIOUS);
        IPSafeAddItemProperty(GetPCSkin(oPC), ipSavage, RoundsToSeconds(nDuration), 
                               X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    
}