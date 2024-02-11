#include "prc_feat_const"

void main()
{
    object oPC = OBJECT_SELF;
    string sMes;

    if(GetLocalInt(oPC, "INV_SPELLWEAVE"))
    {
        FloatingTextStringOnCreature("Eldritch Spellweave is already active!", oPC, FALSE);
        IncrementRemainingFeatUses(oPC, FEAT_ELDRITCH_SPELLWEAVE);
    }
    else
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_FINAL_STAND), oPC);
        SetLocalInt(oPC, "INV_SPELLWEAVE", TRUE);
    }
}