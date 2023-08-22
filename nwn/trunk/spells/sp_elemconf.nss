#include "prc_inc_spells"
//Stormlord Elemental Comflaguration spellscript

void main()
{

    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = PRCGetSpellTargetObject();

    string Elemental;

    //Determine Invok Elemental subradial type
    if(nSpell == SPELL_ELE_CONF_FIRE)
    {
        Elemental = "NW_FIREHUGE";
    }
    else if (nSpell == SPELL_ELE_CONF_WATER)
    {
        Elemental = "NW_WATERHUGE";
    }
    else if (nSpell == SPELL_ELE_CONF_EARTH)
    {
        Elemental = "NW_EARTHHUGE";
    }
    else if (nSpell == SPELL_ELE_CONF_AIR)
    {
        Elemental = "NW_AIRHUGE";
    }

    int Duration=PRCGetCasterLevel();

    effect Summon=EffectSummonCreature(Elemental,VFX_NONE,0.0,1);
    MultisummonPreSummon();
    float fDuration = RoundsToSeconds(Duration);
    if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
        fDuration = RoundsToSeconds(Duration*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL));
    if(GetPRCSwitch(PRC_MULTISUMMON))
    {
        Summon=EffectSummonCreature("NW_FIREHUGE",VFX_NONE,0.0,1);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, Summon, PRCGetSpellTargetLocation(), fDuration);
        Summon=EffectSummonCreature("NW_WATERHUGE",VFX_NONE,0.0,1);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, Summon, PRCGetSpellTargetLocation(), fDuration);
        Summon=EffectSummonCreature("NW_EARTHHUGE",VFX_NONE,0.0,1);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, Summon, PRCGetSpellTargetLocation(), fDuration);
        Summon=EffectSummonCreature("NW_AIRHUGE",VFX_NONE,0.0,1);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, Summon, PRCGetSpellTargetLocation(), fDuration);
    }
    else
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, Summon, PRCGetSpellTargetLocation(), fDuration);
}

