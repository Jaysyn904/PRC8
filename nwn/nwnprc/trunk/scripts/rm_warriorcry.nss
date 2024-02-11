//::///////////////////////////////////////////////
//:: Tensor's Transformation
//:: NW_S0_TensTrans.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the caster the following bonuses:
        +1 Attack per 2 levels
        +4 Natural AC
        20 STR and DEX and CON
        1d6 Bonus HP per level
        +5 on Fortitude Saves
        -10 Intelligence
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////
#include "prc_inc_spells"

// this is used to restore # attacks, when spell has ended
void PnPTensTransPseudoHB()
{
//  object oPC = OBJECT_SELF;
  if (DEBUG) DoDebug("entered PnPTensTransPseudoHB");

  // if we don't have the spell effect any more, do clean up
    if(!GetHasSpellEffect(SPELL_WARRIOR_CRY))
    {
        //remove IPs for simple + martial weapon prof
        object oSkin = GetPCSkin(OBJECT_SELF);
        int nSimple;
        int nMartial;
        itemproperty ipTest = GetFirstItemProperty(oSkin);
        while(GetIsItemPropertyValid(ipTest))
        {
            if(!nSimple
                && GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT
                && GetItemPropertyDurationType(ipTest) == DURATION_TYPE_TEMPORARY
                && GetItemPropertyCostTableValue(ipTest) == IP_CONST_FEAT_WEAPON_PROF_SIMPLE)
            {
                RemoveItemProperty(oSkin, ipTest);
                nSimple = TRUE;
            }
            if(!nMartial
                && GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT
                && GetItemPropertyDurationType(ipTest) == DURATION_TYPE_TEMPORARY
                && GetItemPropertyCostTableValue(ipTest) == IP_CONST_FEAT_WEAPON_PROF_MARTIAL)
            {
                RemoveItemProperty(oSkin, ipTest);
                nMartial = TRUE;
            }
            ipTest = GetNextItemProperty(oSkin);
        }
    // motu99: added this, to facilitate logic in prc_bab_caller
    DeleteLocalInt(OBJECT_SELF, "CasterLvl_TensersTrans");

    // now execute prc_bab_caller to set the base attack count to normal again
    ExecuteScript("prc_bab_caller", OBJECT_SELF);

    //end the pseudoHB
    return;
    }

  // do the pseudo heart beat again in 6 seconds, continue as long as spell lasts
  DelayCommand(6.0, PnPTensTransPseudoHB());
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
        return;
    }

    //Declare major variables
    object oSkin = GetPCSkin(OBJECT_SELF);

    int nCasterLvl = GetHitDice(OBJECT_SELF);
    float fDuration = RoundsToSeconds(nCasterLvl);

    // Attack Bonus Increase
    int nAB = nCasterLvl / 2;

    //Determine bonus HP and Ability adjustments
    int nHP = d6(nCasterLvl);
    int nStr = d4(2);
    int nDex = d4(2);
    int nCon = d4(2);

    effect eEffect = EffectAbilityIncrease(ABILITY_STRENGTH, nStr);
    eEffect = EffectLinkEffects(eEffect, EffectAbilityIncrease(ABILITY_DEXTERITY, nDex));
    eEffect = EffectLinkEffects(eEffect, EffectAbilityIncrease(ABILITY_CONSTITUTION, nCon));
    eEffect = EffectLinkEffects(eEffect, EffectAttackIncrease(nAB));
    eEffect = EffectLinkEffects(eEffect, EffectSavingThrowIncrease(SAVING_THROW_FORT, 5));
    eEffect = ExtraordinaryEffect(eEffect);

    //apply separately (so that we don't loose any other boni when we loose the temporary HP)
    effect eHP = EffectTemporaryHitpoints(nHP); 

    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, fDuration, TRUE, -1, nCasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, OBJECT_SELF, fDuration, TRUE, -1, nCasterLvl);

    itemproperty ipSimple = PRCItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE);
    itemproperty ipMartial = PRCItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL);
    IPSafeAddItemProperty(oSkin, ipSimple,  fDuration);
    IPSafeAddItemProperty(oSkin, ipMartial, fDuration);

    // remember the caster level in order to properly calculate the number of attacks in prc_bab_caller
    SetLocalInt(OBJECT_SELF, "CasterLvl_TensersTrans", nCasterLvl);
    // prc_bab_caller must be executed *after* the spell effects have been applied to the target (otherwise it won't detect Tenser's on the target)
    ExecuteScript("prc_bab_caller", OBJECT_SELF);

    // put the pseudo heart beat on the target of the spell
    DelayCommand(6.0, AssignCommand(OBJECT_SELF,PnPTensTransPseudoHB()));

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the integer used to hold the spells spell school
}
