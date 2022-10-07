#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    int nHPLimit = GetPRCSwitch(PRC_SYMBOL_HP_LIMIT);
    if(nHPLimit <= 0)
        nHPLimit = 150;
    int nSchool, nVFX;
    int nSpellID = PRCGetSpellId();
    switch(nSpellID)
    {
        case SPELL_SYMBOL_OF_DEATH:      nSchool = SPELL_SCHOOL_NECROMANCY;  nVFX = VFX_DUR_SYMB_DEATH; break;
        case SPELL_SYMBOL_OF_FEAR:       nSchool = SPELL_SCHOOL_NECROMANCY;  nVFX = VFX_DUR_SYMB_FEAR;  break;
        case SPELL_SYMBOL_OF_STUNING:    nSchool = SPELL_SCHOOL_ENCHANTMENT; nVFX = VFX_DUR_SYMB_STUN;  break;
        case SPELL_SYMBOL_OF_INSANITY:   nSchool = SPELL_SCHOOL_ENCHANTMENT; nVFX = VFX_DUR_SYMB_INSAN; nHPLimit = -1;  break;
        case SPELL_SYMBOL_OF_PAIN:       nSchool = SPELL_SCHOOL_NECROMANCY;  nVFX = VFX_DUR_SYMB_PAIN;  nHPLimit = -1;  break;
        case SPELL_SYMBOL_OF_PERSUASION: nSchool = SPELL_SCHOOL_ENCHANTMENT; nVFX = VFX_DUR_SYMB_PERS;  nHPLimit = -1;  break;
        case SPELL_SYMBOL_OF_SLEEP:      nSchool = SPELL_SCHOOL_ENCHANTMENT; nVFX = VFX_DUR_SYMB_SLEEP; nHPLimit = -1;  break;
        case SPELL_SYMBOL_OF_WEAKNESS:   nSchool = SPELL_SCHOOL_NECROMANCY;  nVFX = VFX_DUR_SYMB_WEAK;  nHPLimit = -1;  break;
    }

    PRCSetSchool(nSchool);

    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    object oSymbol = CreateObject(OBJECT_TYPE_PLACEABLE, "sp_plc_symbol", lTarget);
    object oTest = GetNearestObjectByTag("SP_PLC_SYMBOL", oSymbol);

    if(GetIsObjectValid(oTest) && GetDistanceBetween(oSymbol, oTest) <5.0f)
    {
        FloatingTextStrRefOnCreature(84612, oCaster);
        DestroyObject(oSymbol);
        return;
    }

    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nAoE = AOE_PER_GLYPH_OF_WARDING;
    effect eSymbol = EffectAreaOfEffect(nAoE, "sp_symbola");
    float fDuration = TurnsToSeconds(nCasterLvl * 10);//10min/level
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;

    if(GetModuleSwitchValue(MODULE_SWITCH_ENABLE_INVISIBLE_GLYPH_OF_WARDING))
        // show symbol only for 6 seconds
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nVFX), lTarget, 6.0f);
    else
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(nVFX)), oSymbol);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eSymbol), lTarget, fDuration);

    // Setup AoE object
    object oAoE = GetAreaOfEffectObject(lTarget, GetAreaOfEffectTag(nAoE), oCaster);
    SetLocalInt(oAoE, "X2_AoE_Caster_Level", nCasterLvl);
    SetLocalInt(oAoE, "X2_AoE_SpellID", nSpellID);
    SetLocalInt(oAoE, "X2_AoE_Weave", GetHasFeat(FEAT_SHADOWWEAVE, oCaster));
    SetLocalInt(oAoE, "X2_AoE_BaseSaveDC", PRCGetSpellSaveDC(nSpellID));
    SetLocalInt(oAoE, "PRC_Symbol_Metamagic", nMetaMagic);
    SetLocalInt(oAoE, "PRC_Symbol_HP_Limit", nHPLimit);

    // Setup placeable object
    SetLocalObject(oSymbol, "X2_PLC_GLYPH_CASTER", oCaster);
    SetLocalObject(oSymbol, "X2_PLC_GLYPH_AOE", oAoE);
    SetLocalInt(oSymbol, "X2_PLC_GLYPH_CASTER_LEVEL", nCasterLvl);
    DestroyObject(oSymbol, fDuration);

    PRCSetSchool();
}

