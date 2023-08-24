//::///////////////////////////////////////////////
//:: Name      Exalted Raiment
//:: FileName  sp_exaltd_raim.nss
//:://////////////////////////////////////////////
/**@file Exalted Raiment
Abjuration
Level: Sanctified 6
Components: V, DF, Sacrifice
Casting Time: 1 standard action
Range: Touch
Target: Robe, garment, or outfit touched
Duration: 1 minute/level
Saving Throw: Will negates (harmless, object)
Spell Resistance: Yes (harmless, object)

You imbue a robe, priestly garment, or outfit of
regular clothing with divine power.  The spell bestows
the following effects for the duration:

     - +1 sacred bonus to AC per five caster levels
     (max +4 at 20th level)

     - Damage reduction 10/evil

     - Spell resistance 5 + 1/caster level (max SR 25 
     at 20th level

     - Reduces ability damage due to spell casting by 1,
     to a minimum of 1 point (but does not reduce the 
     sacrifice cost of this spell).

     Sacrifice: 1d4 points of Strength damage

Author:    Tenjac
Created:   6/28/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////



#include "prc_inc_spells"
#include "prc_ip_srcost.nss"

int GetERSpellResistance(int nCasterLvl)
{
    int nSRBonus = min(nCasterLvl, 20);
    int nIPConst;

    switch(nSRBonus)
    {
        case 0: break;
        case 1: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_6; break;
        case 2: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_7; break;
        case 3: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_8; break;
        case 4: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_9; break;
        case 5: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_10; break;
        case 6: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_11; break;
        case 7: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_12; break;
        case 8: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_13; break;
        case 9: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_14; break;
        case 10: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_15; break;
        case 11: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_16; break;
        case 12: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_17; break;
        case 13: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_18; break;
        case 14: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_19; break;
        case 15: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_20; break;
        case 16: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_21; break;
        case 17: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_22; break;
        case 18: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_23; break;
        case 19: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_24; break;
        case 20: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_25; break;
    }

    return nIPConst;
}

void main()
{
    object oPC = OBJECT_SELF;
    object oMyArmor = IPGetTargetedOrEquippedArmor(FALSE);
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nSR = GetERSpellResistance(nCasterLvl);
    int nArmor = min(nCasterLvl / 5, 4);
    float fDur = (60.0f * nCasterLvl);
    int nMetaMagic = PRCGetMetaMagicFeat();

    if(nMetaMagic & METAMAGIC_EXTEND)
    {
        fDur += fDur;
    }

    //check to make sure it has no AC
    int nBaseAC = GetBaseAC(oMyArmor);
    int nBonusAC = GetACBonus(oMyArmor);
    int nLevel = GetLevelByClass(CLASS_TYPE_ABJURANT_CHAMPION);
    
    if(nLevel > 0)
    {
        nBonusAC += nLevel;
    }    

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    itemproperty ipArmor = ItemPropertyACBonus(nBonusAC += nArmor);
    itemproperty ipDR    = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_2, IP_CONST_DAMAGESOAK_10_HP);
    itemproperty ipSR    = ItemPropertyBonusSpellResistance(nSR);

    //object is valid but has no AC value (clothes, robes, etc).
    if((GetIsObjectValid(oMyArmor)))
    {
        if(nBaseAC < 1)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oMyArmor, fDur);
            IPSafeAddItemProperty(oMyArmor, ipArmor, fDur);
            IPSafeAddItemProperty(oMyArmor, ipDR, fDur);
            IPSafeAddItemProperty(oMyArmor, ipSR, fDur);
            //SetLocalInt(oMyArmor, "PRC_Has_Exalted_Raiment", 1);
            //DelayCommand(fDur, DeleteLocalInt(oMyArmor, "PRC_Has_Exalted_Raiment"));
        }
        else
        {
            SendMessageToPC(oPC, "Invalid item: Base AC > 0");
            return;
        }
    }
    else
    {
        SendMessageToPC(oPC, "Target creature has no armor!");
        return;
    }

    //Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
    AdjustAlignment(oPC, ALIGNMENT_GOOD, 10, FALSE);

    //SPGoodShift(oPC);

    DoCorruptionCost(oPC, ABILITY_STRENGTH, d4(1), 0);
    PRCSetSchool();
}