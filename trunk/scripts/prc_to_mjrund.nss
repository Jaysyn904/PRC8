/**
 * Thrall of Orcus: Create Major Undead
 * 2004/07/12
 * Stratovarius
 */

#include "prc_inc_clsfunc"

void main()
{
    string sSummon = "prc_to_mummy";
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);

   effect eSum = EffectSummonCreature(sSummon, VFX_NONE);
   MultisummonPreSummon(OBJECT_SELF);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
   ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSum, GetSpellTargetLocation());
//   object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
//   CorpseCrafter(OBJECT_SELF, oSummon);
}