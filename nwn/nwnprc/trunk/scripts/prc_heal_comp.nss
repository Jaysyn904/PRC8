/*
Type of Feat: Class
Prerequisite: Healer 8
Specifics: Gain a companion
Use: Selected.
*/

void SummonCelestialCompanion(object oPC, string sResRef, int nHD, int nClass, location lTarget);

const int HEALER_COMP_UNICORN = 1845;
const int HEALER_COMP_LAMMASU = 1846;
const int HEALER_COMP_ANDRO   = 1847;

#include "prc_inc_assoc"

void main()
{
    object oCaster = OBJECT_SELF;
    object oComp = GetAssociateNPC(ASSOCIATE_TYPE_CELESTIALCOMPANION, oCaster);
    int nSpellId = GetSpellId();
    int nClass = GetLevelByClass(CLASS_TYPE_HEALER, oCaster);

    if((HEALER_COMP_LAMMASU == nSpellId && nClass < 12) || (HEALER_COMP_ANDRO == nSpellId && nClass < 16))
    {
        FloatingTextStringOnCreature("You are too low level to summon this companion", oCaster, FALSE);
        IncrementRemainingFeatUses(oCaster, FEAT_CELESTIAL_COMPANION);
        return;
    }

    vector vloc = GetPositionFromLocation(GetLocation(oCaster));
    vector vLoc = Vector( vloc.x + (Random(6) - 2.5f), vloc.y + (Random(6) - 2.5f), vloc.z );
    location lTarget = Location(GetArea(oCaster), vLoc, IntToFloat(Random(361) - 180));

    string sSummon;
    int nHD;
    if(HEALER_COMP_UNICORN == nSpellId)
    {
        sSummon = "prc_sum_unicorn";
        nHD = 4;
    }
    else if(HEALER_COMP_LAMMASU == nSpellId)
    {
        sSummon = "prc_sum_lammasu";
        nClass -= 4;
        nHD = 7;
    }
    else if(HEALER_COMP_ANDRO == nSpellId)
    {
        sSummon = "prc_sum_andro";
        nClass -= 8;
        nHD = 12;
    }

    //remove previously summoned companion
    if(GetIsObjectValid(oComp))
        DestroyAssociate(oComp);

    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_CELESTIAL);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
    DelayCommand(3.0f, SummonCelestialCompanion(oCaster, sSummon, nHD, nClass, lTarget));
}

void SummonCelestialCompanion(object oPC, string sResRef, int nHD, int nClass, location lTarget)
{
    object oComp = CreateLocalNPC(oPC, ASSOCIATE_TYPE_CELESTIALCOMPANION, sResRef, lTarget, 1, "prc_heal_comp");
    AddAssociate(oPC, oComp);
    SetLocalObject(oPC, "HealerCompanion", oComp);
    SetLocalInt(oComp, "X2_JUST_A_DISABLEEQUIP", TRUE);

    // Level the creature to its proper HD
    // This is done so the bonus HP can be added later
    int n;
    for(n = 1; n < nHD; n++)
        LevelUpHenchman(oComp, CLASS_TYPE_INVALID, TRUE);

    // Apply the effects from the level in the class
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oComp);
    // Always gets IEvasion
    int nIPFeat = IP_CONST_FEAT_IMPEVASION;
    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(nIPFeat), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    int nArmour, nStat, bSR, bMove, bSave;
    effect eBonus;

    if (nClass >= 18)
    {
        nArmour = 6;
        nStat   = 6;
        nHD    += 6;
        bSave   = TRUE;
        bSR     = TRUE;
        bMove   = TRUE;
    }
    else if(nClass >= 15)
    {
        nArmour = 4;
        nStat   = 4;
        nHD    += 4;
        bSave   = TRUE;
    }
    else if(nClass >= 12)
    {
        nArmour = 2;
        nStat   = 2;
        nHD    += 2;
    }
    // Epic bonuses
    int nEpicBonus = (nClass - 20) / 2;
        nArmour += nEpicBonus;
        nHD     += nEpicBonus;
        nStat   += nEpicBonus / 2;

    eBonus = EffectACIncrease(nArmour);
    if(GetPRCSwitch(PRC_NWNX_FUNCS))
    {
        PRC_Funcs_ModAbilityScore(oComp, ABILITY_STRENGTH,     nStat);
        PRC_Funcs_ModAbilityScore(oComp, ABILITY_DEXTERITY,    nStat);
        PRC_Funcs_ModAbilityScore(oComp, ABILITY_INTELLIGENCE, nStat);
    }
    else
    {
        eBonus = EffectLinkEffects(eBonus, EffectAbilityIncrease(ABILITY_STRENGTH,     nStat));
        eBonus = EffectLinkEffects(eBonus, EffectAbilityIncrease(ABILITY_DEXTERITY,    nStat));
        eBonus = EffectLinkEffects(eBonus, EffectAbilityIncrease(ABILITY_INTELLIGENCE, nStat));
    }
    if(bSave) eBonus = EffectLinkEffects(eBonus, EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_MIND_SPELLS));
    if(bSR)   eBonus = EffectLinkEffects(eBonus, EffectSpellResistanceIncrease(nClass));
    if(bMove) eBonus = EffectLinkEffects(eBonus, EffectMovementSpeedIncrease(33));
              eBonus = SupernaturalEffect(eBonus);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oComp);
}
