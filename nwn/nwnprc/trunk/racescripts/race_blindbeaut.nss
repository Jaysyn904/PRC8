//::///////////////////////////////////////////////
//:: Blinding Beauty Toggle
//:: race_blindbeaut.nss
//::///////////////////////////////////////////////
/*
    Toggles Blinding Beauty aura.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 21, 2008
//:://////////////////////////////////////////////

//#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    string sMes = "";

    if(!GetHasSpellEffect(SPELL_NYMPH_BLINDING_BEAUTY))
    {
        effect eAura = ExtraordinaryEffect(EffectAreaOfEffect(AOE_PER_NYMPH_BLINDING));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAura, oPC);
        sMes = "*Blinding Beauty Activated*";
    }
    else
    {
        // Removes effects
        PRCRemoveSpellEffects(SPELL_NYMPH_BLINDING_BEAUTY, oPC, oPC);
        sMes = "*Blinding Beauty Deactivated*";
    }

    FloatingTextStringOnCreature(sMes, oPC, FALSE);
}