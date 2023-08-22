/*:://////////////////////////////////////////////
//:: Spell Name Endure Elements
//:: Spell FileName PHS_S_EndureElem
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Clr 1, Drd 1, Pal 1, Rgr 1, Sor/Wiz 1, Sun 1
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 24 hours
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    A creature protected by endure elements suffers no harm from being in a hot
    or cold environment. The creature gains 2/- damage resistance against cold
    and fire damage.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Changed to "no protection from" to "2/-".

    As it lasts forever (for 24hrs) it ain't too bad.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_ENDURE_ELEMENTS)) return;

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
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDR1 = EffectDamageResistance(DAMAGE_TYPE_FIRE, 2);
    effect eDR2 = EffectDamageResistance(DAMAGE_TYPE_COLD, 2);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eDR1);
    eLink = EffectLinkEffects(eLink, eDR2);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove pervious castings of it
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_ENDURE_ELEMENTS, oTarget);

    //Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ENDURE_ELEMENTS, FALSE);

    // Apply VNF and effect.
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
