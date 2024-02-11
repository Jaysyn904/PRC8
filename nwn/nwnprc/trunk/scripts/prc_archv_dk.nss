#include "prc_inc_spells"

//Checks target racial type for Archivists Dark Knowledge ability
int DarkKnowledgeValidTarget(int nRacialType)
{
    switch(nRacialType)
    {
        case RACIAL_TYPE_ABERRATION:    return TRUE;
        case RACIAL_TYPE_ELEMENTAL:     return TRUE;
        case RACIAL_TYPE_MAGICAL_BEAST: return TRUE;
        case RACIAL_TYPE_OUTSIDER:      return TRUE;
        case RACIAL_TYPE_UNDEAD:        return TRUE;
        case RACIAL_TYPE_DRAGON:        if(GetHasFeat(FEAT_DRACONIC_ARCHIVIST))  return TRUE;
        case RACIAL_TYPE_CONSTRUCT:     if(GetHasFeat(FEAT_DRACONIC_ARCHIVIST))  return TRUE;
        case RACIAL_TYPE_FEY:           if(GetHasFeat(FEAT_ARCHIVIST_OF_NATURE)) return TRUE;
        case RACIAL_TYPE_GIANT:         if(GetHasFeat(FEAT_ARCHIVIST_OF_NATURE)) return TRUE;

        default: return FALSE;
    }

    return FALSE;
}

int SpellIDToFeatID(int nSpellID)
{
    switch(nSpellID)
    {
        case SPELL_DK_TACTICS:       return FEAT_DK_TACTICS;
        case SPELL_DK_PUISSANCE:     return FEAT_DK_PUISSANCE;
        case SPELL_DK_FOE:           return FEAT_DK_FOE;
        case SPELL_DK_DREADSECRET:   return FEAT_DK_DREADSECRET;
        case SPELL_DK_FOREKNOWLEDGE: return FEAT_DK_FOREKNOWLEDGE;
    }
    //on error
    return -1;
}

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nSpellID = PRCGetSpellId();
    int nRacialType = MyPRCGetRacialType(oTarget);
    effect eBonus, eVis, eEff;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //nr of uses is decreased by game engine and by this script, so add an extra use here
    IncrementRemainingFeatUses(oPC, SpellIDToFeatID(nSpellID));

    //check if target is valid
    if(!DarkKnowledgeValidTarget(nRacialType))
    {
        FloatingTextStringOnCreature(GetStringByStrRef(16789900), oPC, FALSE);
        return;
    }

    //remove use for all dark knowledge abilities
    DecrementRemainingFeatUses(oPC, FEAT_DK_TACTICS);
    DecrementRemainingFeatUses(oPC, FEAT_DK_PUISSANCE);
    DecrementRemainingFeatUses(oPC, FEAT_DK_FOE);
    DecrementRemainingFeatUses(oPC, FEAT_DK_DREADSECRET);
    DecrementRemainingFeatUses(oPC, FEAT_DK_FOREKNOWLEDGE);

    //make a lore check
    int nRoll = d20();
    int nLoreCheck = nRoll + GetSkillRank(SKILL_LORE);
    if(!GetPRCIsSkillSuccessful(oPC, SKILL_LORE, 15, nRoll))
    {
        //FloatingTextStringOnCreature(GetStringByStrRef(16789901), oPC, FALSE);
        return;
    }

    if(nSpellID == SPELL_DK_DREADSECRET)
    {
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eVis = EffectVisualEffect(VFX_FNF_PWSTUN);// VFX_IMP_CHARM skoñczy³em na 181

        int bMindSpellImmune = GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oPC);
        int bStunImmune = GetIsImmune(oTarget, IMMUNITY_TYPE_STUN, oPC);
        int bDazeImmune = GetIsImmune(oTarget, IMMUNITY_TYPE_DAZED, oPC);

        if(nLoreCheck >= 35)
        {
            if(!bMindSpellImmune && !bStunImmune)//Stunned
                eEff = EffectStunned();
            else
                eEff = EffectCutsceneParalyze();
        }
        else if(nLoreCheck < 35 && nLoreCheck >= 25)//Dazed
        {
            if(!bMindSpellImmune && !bDazeImmune)
                eEff = EffectDazed();
            else
                eEff = EffectCutsceneImmobilize();
        }
        else if(nLoreCheck < 25)//Dazzled
        {
            eEff = EffectDazzle();
        }

        eEff = EffectLinkEffects(eEff, eDur);

        //remove effects of previous castings
        PRCRemoveEffectsFromSpell(oTarget, SPELL_DK_DREADSECRET);

        //apply new effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff, oTarget, RoundsToSeconds(1));
        return;
    }

    //other abilities are beneficial
    int nBonus = (nLoreCheck - 5) / 10;
    if(nBonus > 3 && !GetHasFeat(FEAT_EPIC_DARK_KNOWLEDGE, oPC))
        nBonus = 3;

    //set bonuses
    if(nSpellID == SPELL_DK_TACTICS)
    {
        eBonus = VersusRacialTypeEffect(EffectAttackIncrease(nBonus), nRacialType);
        eVis = EffectVisualEffect(VFX_IMP_HOLY_AID_DN_PURPLE);
    }
    else if(nSpellID == SPELL_DK_PUISSANCE)
    {
        eBonus = VersusRacialTypeEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus), nRacialType);
        eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION_P);
    }
    else if(nSpellID == SPELL_DK_FOREKNOWLEDGE)
    {
        eBonus = VersusRacialTypeEffect(EffectACIncrease(nBonus), nRacialType);
        eVis = EffectVisualEffect(VFX_IMP_PDK_RALLYING_CRY);
    }
    else if(nSpellID == SPELL_DK_FOE)
    {
        switch(nBonus)
        {
            case  1: nBonus = DAMAGE_BONUS_1d6; break;
            case  2: nBonus = DAMAGE_BONUS_2d6; break;
            case  3: nBonus = 31; break;//DAMAGE_BONUS_3d6 - no constant?
            case  4: nBonus = 32; break;//DAMAGE_BONUS_4d6
            case  5: nBonus = 33; break;//DAMAGE_BONUS_5d6
            case  6: nBonus = 34; break;//DAMAGE_BONUS_6d6
            case  7: nBonus = 35; break;//DAMAGE_BONUS_7d6
            case  8: nBonus = 36; break;//DAMAGE_BONUS_8d6
            case  9: nBonus = 53; break;//DAMAGE_BONUS_9d6
            default: nBonus = 54; break;//DAMAGE_BONUS_10d6
        }
        eBonus = VersusRacialTypeEffect(EffectDamageIncrease(nBonus, DAMAGE_TYPE_BLUDGEONING), nRacialType);
        eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    }

    eBonus = EffectLinkEffects(eBonus, eDur);
    eBonus = ExtraordinaryEffect(eBonus);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_PURPLE_30_SILENT), GetLocation(oPC));

    object oAlly = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC));

    while(GetIsObjectValid(oAlly) && GetIsFriend(oAlly))
    {
        //remove effects of previous castings
        effect eLook = GetFirstEffect(oAlly);
        while(GetIsEffectValid(eLook))
        {
             int nEffID = GetEffectSpellId(eLook);
             if(nEffID == SPELL_DK_TACTICS
             || nEffID == SPELL_DK_PUISSANCE
             || nEffID == SPELL_DK_FOREKNOWLEDGE
             || nEffID == SPELL_DK_FOE)
                RemoveEffect(oAlly, eLook);
            eLook = GetNextEffect(oAlly);
        }

        //apply new effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oAlly);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oAlly, TurnsToSeconds(1));

        oAlly = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC));
    }
}