/*:://////////////////////////////////////////////
//:: Spell Name Divine Favor
//:: Spell FileName PHS_S_DivineFavo
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation
    Level: Clr 1, Pal 1
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 minute

    Calling upon the strength and wisdom of a deity, you gain a +1 bonus on
    attack and weapon damage rolls for every three caster levels you have (at
    least +1, maximum +3). The bonus doesn’t apply to spell damage.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell says.

    Errata - Changes this to a maximum of +3 - whew!

    It is only the caster, only for a minute, although it does penetrate DR (urg).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DIVINE_FAVOR)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Total bonuses to add 1 per 3 levels, max 3
    int nBonus = PHS_LimitInteger(nCasterLevel/3, 3);

    // Determine duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, 1, nMetaMagic);

    // Declare effefcts and link
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
    effect eAttack = EffectAttackIncrease(nBonus);
    effect eDamage = EffectDamageIncrease(nBonus, DAMAGE_TYPE_DIVINE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eAttack);
    eLink = EffectLinkEffects(eLink, eDamage);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove pervious castings of it
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_DIVINE_FAVOR, oTarget);

    //Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DIVINE_FAVOR, FALSE);

    // Apply VNF and effect.
    PHS_ApplyLocationVFX(GetLocation(oTarget), eImpact);
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
