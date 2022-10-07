//::///////////////////////////////////////////////
//:: Metamagic Spell Ability
//:: ft_metamagic.nss
//:://////////////////////////////////////////////
//:: Applies desired metamagic effect to next spell cast.
//:://////////////////////////////////////////////
//:: Created By: N-S
//:: Created On: 20/09/2009
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_spell_const"
#include "inc_debug"

int GetMetamagicFromSpellAbility(int nSpell)
{
    switch (nSpell)
    {
        case SPELL_EXTEND_SPELL_ABILITY:   return METAMAGIC_EXTEND;
        case SPELL_SILENT_SPELL_ABILITY:   return METAMAGIC_SILENT;
        case SPELL_STILL_SPELL_ABILITY:    return METAMAGIC_STILL;
        case SPELL_EMPOWER_SPELL_ABILITY:  return METAMAGIC_EMPOWER;
        case SPELL_MAXIMIZE_SPELL_ABILITY: return METAMAGIC_MAXIMIZE;
        case SPELL_QUICKEN_SPELL_ABILITY:  return METAMAGIC_QUICKEN;
    }
    return METAMAGIC_NONE;
}

void main()
{
    object oPC = OBJECT_SELF;
    int nMetaState = GetLocalInt(oPC, "PRC_metamagic_state");
    int nSpellID = GetSpellId();
    int nMetaOld = GetLocalInt(oPC, "MetamagicFeatAdjust");
    int nMetamagic = GetMetamagicFromSpellAbility(nSpellID);

    if (DEBUG) Assert(nMetamagic != METAMAGIC_NONE, "nMetamagic != METAMAGIC_NONE", "Bad call to metamagic script!", "ft_metamagic");

    if(nMetaState < 1 || (nMetaState > 0 && nMetaOld != nMetamagic))//no metamagic was used or different metamagic used
    {
        SetLocalInt(oPC, "MetamagicFeatAdjust", nMetamagic);
        SetLocalInt(oPC, "PRC_metamagic_state", 1);
        // "[Extend/Silent/...] Spell Activated"
        FloatingTextStringOnCreature("*"+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID))) + " " + GetStringByStrRef(63798)+"*", oPC, FALSE);
        SendMessageToPC(oPC, "Metamagic activated for the next spell you cast.");
    }
    else if(nMetaState == 1 && nMetaOld == nMetamagic)//same metamagic used twice
    {
        SetLocalInt(oPC, "PRC_metamagic_state", 2);
        // "[Extend/Silent/...] Spell Activated"
        FloatingTextStringOnCreature("*"+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID))) + " " + GetStringByStrRef(63798)+"*", oPC, FALSE);
        SendMessageToPC(oPC, "Metamagic activated for all spells you cast.");
    }
    else if(nMetaState == 2)//disable metamagic
    {
        SetLocalInt(oPC, "PRC_metamagic_state", 0);
        SetLocalInt(oPC, "MetamagicFeatAdjust", 0);
        FloatingTextStringOnCreature("*"+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID))) + " " + GetStringByStrRef(63799)+"*", oPC, FALSE);
    }
}
