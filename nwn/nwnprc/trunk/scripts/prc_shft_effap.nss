//::///////////////////////////////////////////////
//:: Shifting effects application spellscript
//:: prc_shft_effap
//::///////////////////////////////////////////////
/** @file prc_shft_effap
    Applies those effects of shifting that
    need an effect placed on the shifter in order
    to bind said effects to a specific spellID.

    @author Ornedan
    @date   Created - 2006.07.02
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////


//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_shifting"

const string PRC_Shifter_ApplyEffects_Generation = "PRC_Shifter_ApplyEffects_Generation";

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

void main()
{
    object oApplier = OBJECT_SELF;
    object oShifter = PRCGetSpellTargetObject();
    
    if (GetLocalInt(oShifter, PRC_Shifter_ApplyEffects_EvalPRC_Generation) != GetLocalInt(oShifter, PRC_EvalPRCFeats_Generation))
    {
        //EvalPRCFeats has been called again since this application was scheduled,
        //so don't apply--let the application scheduled by the later call to EvalPRCFeats
        //do it instead.
        return;
    }
    
    int nGeneration = PRC_NextGeneration(GetLocalInt(oShifter, PRC_Shifter_ApplyEffects_Generation));
    SetLocalInt(oShifter, PRC_Shifter_ApplyEffects_Generation, nGeneration);

    int bApplyAll = GetLocalInt(oShifter, "PRC_SHIFTER_APPLY_ALL_SPELL_EFFECTS");
    DeleteLocalInt(oShifter, "PRC_SHIFTER_APPLY_ALL_SPELL_EFFECTS");

    int nSTR_AttackBonus = GetLocalInt(oShifter, "PRC_Shifter_ExtraSTR_AttackBonus");
    int nSTR_DamageBonus = GetLocalInt(oShifter, "PRC_Shifter_ExtraSTR_DamageBonus");
    int nSTR_DamageType = GetLocalInt(oShifter, "PRC_Shifter_ExtraSTR_DamageType");    
    int nSTR_SaveAndSkillBonus = GetLocalInt(oShifter, "PRC_Shifter_ExtraSTR_SaveAndSkillBonus");
    int nDEX_ACBonus = GetLocalInt(oShifter, "PRC_Shifter_ExtraDEX_ACBonus");
    int nDEX_SaveAndSkillBonus = GetLocalInt(oShifter, "PRC_Shifter_ExtraDEX_SaveAndSkillBonus");
    int nCON_HPBonus = GetLocalInt(oShifter, "PRC_Shifter_ExtraCON_HPBonus"); 
    int nCON_SaveAndSkillBonus = GetLocalInt(oShifter, "PRC_Shifter_ExtraCON_SaveAndSkillBonus"); 
    
    //Remove any old effects
    
    _prc_inc_shifting_RemoveSpellEffects(oShifter, bApplyAll);

    //Add any new effects

    //STR-based attack bonus
    if(nSTR_AttackBonus > 0)
    {
        int nAttackIncrease = nSTR_AttackBonus;
        if (nAttackIncrease > 20)
            nAttackIncrease = 20;
        DelayApplyEffectToObject(0.0f, PRC_Shifter_ApplyEffects_Generation, DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackIncrease(nAttackIncrease, ATTACK_BONUS_MISC)), oShifter);
    }
    else if (nSTR_AttackBonus < 0)
    {
        int nAttackDecrease = -nSTR_AttackBonus;
        if (nAttackDecrease > 20) //TODO: What's the actual cap?
            nAttackDecrease = 20;
        DelayApplyEffectToObject(0.0f, PRC_Shifter_ApplyEffects_Generation, DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(nAttackDecrease, ATTACK_BONUS_MISC)), oShifter);
    }

    //STR-based damage bonus
    if(nSTR_DamageBonus > 0)
    {
        int nDamageBonusConstant;
        switch(nSTR_DamageBonus)
        {
            case 1 : nDamageBonusConstant = DAMAGE_BONUS_1 ; break;
            case 2 : nDamageBonusConstant = DAMAGE_BONUS_2 ; break;
            case 3 : nDamageBonusConstant = DAMAGE_BONUS_3 ; break;
            case 4 : nDamageBonusConstant = DAMAGE_BONUS_4 ; break;
            case 5 : nDamageBonusConstant = DAMAGE_BONUS_5 ; break;
            case 6 : nDamageBonusConstant = DAMAGE_BONUS_6 ; break;
            case 7 : nDamageBonusConstant = DAMAGE_BONUS_7 ; break;
            case 8 : nDamageBonusConstant = DAMAGE_BONUS_8 ; break;
            case 9 : nDamageBonusConstant = DAMAGE_BONUS_9 ; break;
            case 10: nDamageBonusConstant = DAMAGE_BONUS_10; break;
            case 11: nDamageBonusConstant = DAMAGE_BONUS_11; break;
            case 12: nDamageBonusConstant = DAMAGE_BONUS_12; break;
            case 13: nDamageBonusConstant = DAMAGE_BONUS_13; break;
            case 14: nDamageBonusConstant = DAMAGE_BONUS_14; break;
            case 15: nDamageBonusConstant = DAMAGE_BONUS_15; break;
            case 16: nDamageBonusConstant = DAMAGE_BONUS_16; break;
            case 17: nDamageBonusConstant = DAMAGE_BONUS_17; break;
            case 18: nDamageBonusConstant = DAMAGE_BONUS_18; break;
            case 19: nDamageBonusConstant = DAMAGE_BONUS_19; break;
            default: nDamageBonusConstant = DAMAGE_BONUS_20; // The value is >= 20, the bonus limit is +20
        }
        DelayApplyEffectToObject(0.0f, PRC_Shifter_ApplyEffects_Generation, DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageIncrease(nDamageBonusConstant, nSTR_DamageType)), oShifter);
    }
    else if(nSTR_DamageBonus < 0)
    {
        DelayApplyEffectToObject(0.0f, PRC_Shifter_ApplyEffects_Generation, DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageDecrease(-nSTR_DamageBonus, nSTR_DamageType)), oShifter);
    }

    //DEX-based AC bonus
    if (nDEX_ACBonus > 0)
        DelayApplyEffectToObject(0.0f, PRC_Shifter_ApplyEffects_Generation, DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nDEX_ACBonus)), oShifter);
    else if (nDEX_ACBonus < 0)
        DelayApplyEffectToObject(0.0f, PRC_Shifter_ApplyEffects_Generation, DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACDecrease(-nDEX_ACBonus)), oShifter);

    //DEX-based save bonus
    if (nDEX_SaveAndSkillBonus > 0)
        DelayApplyEffectToObject(0.0f, PRC_Shifter_ApplyEffects_Generation, DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nDEX_SaveAndSkillBonus)), oShifter);
    else if (nDEX_SaveAndSkillBonus < 0)
        DelayApplyEffectToObject(0.0f, PRC_Shifter_ApplyEffects_Generation, DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSavingThrowDecrease(SAVING_THROW_REFLEX, -nDEX_SaveAndSkillBonus)), oShifter);
            //TODO: what about forms that are immune to saving throw decrease? Use code similar to _prc_inc_shifting_BypassItemProperties()?

    //CON-based save bonus
    if (nCON_SaveAndSkillBonus > 0)
        DelayApplyEffectToObject(0.0f, PRC_Shifter_ApplyEffects_Generation, DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_FORT, nCON_SaveAndSkillBonus)), oShifter);
    else if (nCON_SaveAndSkillBonus < 0)
        DelayApplyEffectToObject(0.0f, PRC_Shifter_ApplyEffects_Generation, DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSavingThrowDecrease(SAVING_THROW_FORT, -nCON_SaveAndSkillBonus)), oShifter);
            //TODO: what about forms that are immune to saving throw decrease? Use code similar to _prc_inc_shifting_BypassItemProperties()?

    //STR, DEX, and CON based skill bonuses
    int i = 0;
    string sSkillKeyAbility;
    effect eTotalSkillEffect;
    int bHaveTotalSkillEffect = FALSE;
    while((sSkillKeyAbility = Get2DACache("skills", "KeyAbility", i)) != "")
    {
        int nSaveAndSkillBonus = 0;
        
        if (sSkillKeyAbility == "STR")
            nSaveAndSkillBonus = nSTR_SaveAndSkillBonus;
        else if (sSkillKeyAbility == "DEX")
            nSaveAndSkillBonus = nDEX_SaveAndSkillBonus;
        else if (sSkillKeyAbility == "CON")
            nSaveAndSkillBonus = nCON_SaveAndSkillBonus;
        
        effect eSkillEffect;
        if(nSaveAndSkillBonus > 0)
        {
            eSkillEffect = EffectLinkEffects(eTotalSkillEffect, EffectSkillIncrease(i, nSaveAndSkillBonus));
        }
        else if (nSaveAndSkillBonus < 0)
        {
            eSkillEffect = EffectLinkEffects(eTotalSkillEffect, EffectSkillDecrease(i, -nSaveAndSkillBonus));
            //TODO: what about forms that are immune to skill decrease? Use code similar to _prc_inc_shifting_BypassItemProperties()?
        }
        
        if (!bHaveTotalSkillEffect)
        {
            eTotalSkillEffect = eSkillEffect;
            bHaveTotalSkillEffect = TRUE;
        }
        else
            eTotalSkillEffect = EffectLinkEffects(eTotalSkillEffect, eSkillEffect);

        i += 1;
    }
    if (bHaveTotalSkillEffect)
        DelayApplyEffectToObject(0.0f, PRC_Shifter_ApplyEffects_Generation, DURATION_TYPE_PERMANENT, SupernaturalEffect(eTotalSkillEffect), oShifter);

    //Natural AC
    if(GetLocalInt(oShifter, "PRC_Shifter_NaturalAC"))
    {
        int nNaturalAC = GetLocalInt(oShifter, "PRC_Shifter_NaturalAC");
        DelayApplyEffectToObject(0.0f, PRC_Shifter_ApplyEffects_Generation, DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nNaturalAC, AC_NATURAL_BONUS)), oShifter);
    }

    //Harmlessly invisible
    if (bApplyAll)
    {
        if(GetLocalInt(oShifter, "PRC_Shifter_HarmlessInvisible"))
        {
            if(DEBUG_EFFECTS || DEBUG) 
                DoDebug("Applying Harmless Invisibility effect");
            DelayApplyEffectToObject(0.0f, PRC_Shifter_ApplyEffects_Generation, DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectInvisibility(INVISIBILITY_TYPE_NORMAL)), oShifter);
        }
    }

    //CON-based HP bonus
    if (bApplyAll)
    {
        if(DEBUG_EFFECTS || DEBUG) 
            DoDebug("Applying Temporary HP effect: " + IntToString(nCON_HPBonus));

        //Apply temporary HP separately from other effects--linking it with other effects
        //causes those other effects to be removed when the temporary HP is used up.
    
        if (nCON_HPBonus > 0)
        {
            DelayApplyEffectToObject(0.0f, PRC_Shifter_ApplyEffects_Generation, DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectTemporaryHitpoints(nCON_HPBonus)), oShifter);
        }
        else if (nCON_HPBonus < 0)
        {
            //TODO
        }
    }

    if (GetIsObjectValid(oApplier) && GetResRef(oApplier) == "x0_rodwonder")
    {
        //Queue deletion of the applicator object
        DestroyObject(oApplier, 6.0f);
    }
}
