#include "prc_class_const"
#include "prc_feat_const"
#include "prc_spell_const"
#include "prc_misc_const"
#include "prc_racial_const"
#include "prc_inc_dragsham"

void _SetupAura(object oPC, int nSpellID)
{
    object oAura = GetAuraObject(oPC, "VFX_MARSH_MAJ1");
    int nAuraBonus = GetMarshalAuraPower(oPC);

    SetLocalObject(oPC, "MajorAura", oAura);
    SetLocalInt(oAura, "SpellID", nSpellID);
    SetLocalInt(oAura, "AuraBonus", nAuraBonus);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oAura = GetLocalObject(oPC, "MajorAura");
    int nSpellID = GetSpellId();
    string sMes = "";

    if(GetIsObjectValid(oAura))
    {
        sMes = "*Major Aura Deactivated*";
        DestroyObject(oAura);
        DeleteLocalObject(oPC, "MajorAura");
    }
    else
    {
        sMes = "*Major Aura Activated*";
        effect eAura = ExtraordinaryEffect(EffectAreaOfEffect(AOE_MOB_MARSHAL_MAJOR_AURA));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAura, oPC);
        _SetupAura(oPC, nSpellID);
    }

    FloatingTextStringOnCreature(sMes, oPC, FALSE);
}