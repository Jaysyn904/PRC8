///////////////////////////////////////////
// End Tree Shape script
// prc_end_trees.nss
///////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        object oPC = OBJECT_SELF;
        effect eVis;

        string sTag = "Tree" + GetName(oPC);
        object oTree = GetNearestObjectByTag(sTag, oPC);
        if(GetIsObjectValid(oTree)) eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
        DestroyObject(oTree);

        PRCRemoveSpellEffects(SPELL_TREESHAPE, oPC, oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
}