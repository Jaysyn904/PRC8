/*:://////////////////////////////////////////////
//:: Spell Name Entropic Shield
//:: Spell FileName PHS_S_EntropicSh
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Clr 1, Luck 1
    Components: V, S
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level (D)

    A magical field appears around you, glowing with a chaotic blast of
    multicolored hues. This field deflects incoming arrows, rays, and other
    ranged attacks. Each ranged attack directed at you for which the attacker
    must make an attack roll has a 20% miss chance (similar to the effects of
    concealment). Other attacks that simply work at a distance are not affected.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell says, really. 20% consealment vs. ranged attacks
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_ENTROPIC_SHIELD)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Determine duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effefcts and link
    effect eDur = EffectVisualEffect(PHS_VFX_DUR_ENTROPIC_SHIELD);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    // The invisibility concealment of 20% vs ranged
    effect eConceal = EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eConceal);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove pervious castings of it
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_ENTROPIC_SHIELD, oTarget);

    //Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ENTROPIC_SHIELD, FALSE);

    // Apply VNF and effect.
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
