//::///////////////////////////////////////////////
//:: Sihlbrane's Grove
//:: Tortoise Shell
//:: 00_S0_TORTSHELL
//:://////////////////////////////////////////////
/*
    Caster gains 100 temporary HP and DR 10/-
    against physical damage for one round/level.
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

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one of that type, thats ok
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(GetSpellId(), OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(100775, OBJECT_SELF, FALSE);
        return;
    }

    int nDuration = PRCGetCasterLevel(OBJECT_SELF);
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eTemp = EffectTemporaryHitpoints(100);
    effect eDamage1 = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 10);
    effect eDamage2 = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 10);
    effect eDamage3 = EffectDamageResistance(DAMAGE_TYPE_SLASHING, 10);
    effect eVis = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
    effect eShell = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);
    effect eDur = EffectVisualEffect(VFX_DUR_SANCTUARY);

    effect eLink = EffectLinkEffects(eTemp, eDamage1);
    eLink = EffectLinkEffects(eLink, eDamage2);
    eLink = EffectLinkEffects(eLink, eDamage3);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eShell);

    if(nMetaMagic == METAMAGIC_EXTEND) {
         nDuration = nDuration * 2; }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
}
