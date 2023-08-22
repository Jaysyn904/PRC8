/*
    Warlock epic feat
    Shadowmaster - Shades spells
*/
#include "prc_inc_racial"

#include "inv_inc_invfunc"

void DoSLA(int nSpellID, int nCasterlevel = 0, int nTotalDC = 0)
{
    if(DEBUG) DoDebug("Spell DC passed to DoRacialSLA: " + IntToString(nTotalDC));
    if(nTotalDC == 0)
        nTotalDC = 10
            +StringToInt(Get2DACache("spells", "Innate", nSpellID))
            +GetAbilityModifier(ABILITY_CHARISMA);

    ActionDoCommand(SetLocalInt(OBJECT_SELF, "SpellIsSLA", TRUE));
    if(DEBUG) DoDebug("Spell DC entered in ActionCastSpell: " + IntToString(nTotalDC));
    ActionCastSpell(nSpellID, nCasterlevel, 0, nTotalDC, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, FALSE, OBJECT_INVALID, FALSE);
    ActionDoCommand(DeleteLocalInt(OBJECT_SELF, "SpellIsSLA"));
}

void main()
{
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK);
    int nSpellID = GetSpellId();

    if(nSpellID == INVOKE_SHADOWMASTER_SUMMON_SHADOW)
    {
        DoSLA(SPELL_SHADES_SUMMON_SHADOW, CasterLvl);
    }

    if(nSpellID == INVOKE_SHADOWMASTER_CONE_OF_COLD)
    {
        DoSLA(SPELL_SHADES_CONE_OF_COLD, CasterLvl);
    }

    if(nSpellID == INVOKE_SHADOWMASTER_FIREBALL)
    {
        DoSLA(SPELL_SHADES_FIREBALL, CasterLvl);
    }

    if(nSpellID == INVOKE_SHADOWMASTER_STONESKIN)
    {
        DoSLA(SPELL_SHADES_STONESKIN, CasterLvl);
    }

    if(nSpellID == INVOKE_SHADOWMASTER_WALL_OF_FIRE)
    {
        DoSLA(SPELL_SHADES_WALL_OF_FIRE, CasterLvl);
    }
}
