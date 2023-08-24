/**
 * True Necromancer: Create Lesser Undead
 * 2004/04/14
 * Stratovarius
 */

#include "prc_inc_clsfunc"

void main()
{
    string sSummon;
    object oCreature;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    int nClass = GetLevelByClass(CLASS_TYPE_TRUENECRO, OBJECT_SELF);

    // After level 10, it summons the previous levels Create Greater Undead
    if (nClass > 27)       sSummon = "prc_sum_dk";
    else if (nClass > 24) sSummon = "prc_sum_vamp2";
    else if (nClass > 21) sSummon = "prc_sum_bonet";
    else if (nClass > 18) sSummon = "prc_sum_wight";
    else if (nClass > 15) sSummon = "prc_sum_vamp1";
    else if (nClass > 12) sSummon = "prc_sum_grav";
    else if (nClass > 9)  sSummon = "prc_sum_sklch";
    else if (nClass > 6)  sSummon = "prc_sum_zlord";
    else                  sSummon = "prc_sum_mohrg";

   oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());
   int nMaxHenchmen = GetMaxHenchmen();
   SetMaxHenchmen(99);
   AddHenchman(OBJECT_SELF, oCreature);
   SetMaxHenchmen(nMaxHenchmen);
   CorpseCrafter(OBJECT_SELF, oCreature);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
}