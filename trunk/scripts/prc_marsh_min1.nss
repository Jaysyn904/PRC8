#include "prc_class_const"
#include "prc_feat_const"
#include "prc_spell_const"
#include "prc_misc_const"
#include "prc_racial_const"
#include "prc_inc_dragsham"

void _SetupAura(object oPC, int nSpellID)
{
    object oAura = GetAuraObject(oPC, "VFX_MARSH_MIN1");
    int nAuraBonus = GetAbilityModifier(ABILITY_CHARISMA, oPC);

    SetLocalObject(oPC, "MinorAura", oAura);
    SetLocalInt(oAura, "SpellID", nSpellID);
    SetLocalInt(oAura, "AuraBonus", nAuraBonus);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oAura = GetLocalObject(oPC, "MinorAura");
    int nSpellID = GetSpellId();
    string sMes = "";

    if(GetIsObjectValid(oAura))
    {
        sMes = "*Minor Aura Deactivated*";
        DestroyObject(oAura);
        DeleteLocalObject(oPC, "MinorAura");
    }
    else
    {
        sMes = "*Minor Aura Activated*";
        effect eAura = ExtraordinaryEffect(EffectAreaOfEffect(AOE_MOB_MARSHAL_MINOR_AURA));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAura, oPC);
        _SetupAura(oPC, nSpellID);
    }

    FloatingTextStringOnCreature(sMes, oPC, FALSE);
}