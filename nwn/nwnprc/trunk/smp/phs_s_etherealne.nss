/*:://////////////////////////////////////////////
//:: Spell Name Etherealness
//:: Spell FileName PHS_S_Etherealne
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Clr 9, Sor/Wiz 9
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch; see text
    Targets: You and one other ally per three levels within 5M
    Duration: 1 min./level (D)
    Saving Throw: None
    Spell Resistance: Yes (Harmless)

    This spell functions like ethereal jaunt, except that you and other willing
    allied creatures within a 5M radius sphere around the caster (along with
    their equipment) become ethereal. Besides yourself, you can bring one
    creature per three caster levels to the Ethereal Plane. Once ethereal, the
    subjects need not stay together, and it each affects them seperatly.

    When the spell expires, or the subject decide to cancle it by attacking or
    casting any spell, the affected creature on the Ethereal Plane return to
    material existence.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    We apply ethrealness to the nearest allied (friendly) creatures, then
    the nearest any creatures.

    A multi version of Ethereal Jaunt.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_ETHEREALNESS)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Extra creatures/allies to affect
    int nCreatureExtraLimit = PHS_LimitInteger(nCasterLevel/3);
    int nAffected, nCnt;

    // Determine duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effefcts and link
    effect eDur = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
    effect eEthereal = EffectEthereal();
    effect eGhost = EffectCutsceneGhost();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eEthereal);
    eLink = EffectLinkEffects(eLink, eGhost);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Apply it to us first
    oTarget = oCaster;

    // Make sure they are not immune to spells
    if(!PHS_TotalSpellImmunity(oTarget))
    {
        // Remove pervious castings of it
        PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_ETHEREALNESS, oTarget);

        //Fire cast spell at event for the specified target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ETHEREALNESS, FALSE);

        // Apply VNF and effect.
        PHS_ApplyDuration(oTarget, eLink, fDuration);
    }

    // Loop allies near to the caster
    nCnt = 1;
    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, oCaster, nCnt);
    while(GetIsObjectValid(oTarget) && nAffected < nCreatureExtraLimit &&
          GetDistanceToObject(oTarget) <= 5.0)
    {
        // Make sure they are not immune to spells
        if(!PHS_TotalSpellImmunity(oTarget))
        {
            // Remove pervious castings of it
            PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_ETHEREALNESS, oTarget);

            //Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ETHEREALNESS, FALSE);

            // Apply VNF and effect.
            PHS_ApplyDuration(oTarget, eLink, fDuration);

            // Add one to total
            nAffected++;
        }
        // Get next ally.
        nCnt++;
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, oCaster, nCnt);
    }
}
