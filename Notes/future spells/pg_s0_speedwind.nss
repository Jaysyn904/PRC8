//::///////////////////////////////////////////////
//:: Sihlbrane's Grove
//:: Speed of the Wind
//:: 00_S0_SPEEDWIND
//:://////////////////////////////////////////////
/*
    Caster gains +4 Dex and -2 Con for 10 turns
    per level.
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

    object oTarget = PRCGetSpellTargetObject();

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one of that type, thats ok
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(GetSpellId(), oTarget))
    {
        FloatingTextStrRefOnCreature(100775, OBJECT_SELF, FALSE);
        return;
    }

    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 4);
    effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, 2);
    effect eVis1 = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);
    effect eLink = EffectLinkEffects(eDex, eCon);
    eLink = EffectLinkEffects(eLink, eDur);

    int nRace = MyPRCGetRacialType(oTarget);
    int nDuration = PRCGetCasterLevel(OBJECT_SELF) * 10;
    int nMetaMagic = PRCGetMetaMagicFeat();

    if(nMetaMagic == METAMAGIC_EXTEND) {
        nDuration = nDuration * 2; }
    if((nRace != RACIAL_TYPE_CONSTRUCT) || (nRace != RACIAL_TYPE_UNDEAD))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    }
}
