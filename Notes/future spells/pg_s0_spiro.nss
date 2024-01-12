//::///////////////////////////////////////////////
//:: Sihlbrane's Grove
//:: Spiritual Hammer
//:: 00_S0_SPIRO
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Yaballa
//:: Created On: 7/9/2003
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "prc_inc_spells"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = PRCGetCasterLevel(OBJECT_SELF);
    int nAttack = GetBaseAttackBonus(OBJECT_SELF);
    effect eSummon = EffectSummonCreature("pg_spiritweap", VFX_FNF_SUMMON_MONSTER_1);
    if(nMetaMagic == METAMAGIC_EXTEND) {
        nDuration = nDuration * 2; }
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nDuration));
    DelayCommand(1.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(nAttack - 1), GetAssociate(ASSOCIATE_TYPE_SUMMONED), RoundsToSeconds(nDuration)));
}
