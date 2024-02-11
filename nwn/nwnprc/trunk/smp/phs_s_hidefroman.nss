/*:://////////////////////////////////////////////
//:: Spell Name Hide from Animals
//:: Spell FileName PHS_S_HidefromAn
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Drd 1, Rgr 1
    Components: S, DF
    Casting Time: 1 standard action
    Range: Touch
    Targets: One ally/level in a 3.33M-radius sphere
    Duration: 10 min./level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes

    Animals cannot see, hear, or smell the warded creatures. Even extraordinary
    or supernatural sensory capabilities, such as blindsense, blindsight, scent,
    and tremorsense, cannot detect or locate warded creatures. Animals simply
    act as though the warded creatures are not there. If a warded character
    attacks any creature, even with a spell, the spell ends for that recipient.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Ethrealness (IE: permament "hiding") applied, or attempted to, against
    only Racial Type Animal.

    Might work, NEED TO TEST!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HIDE_FROM_ANIMALS)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Extra creatures/allies to affect, 1 per caster level.
    int nCreatureExtraLimit = PHS_LimitInteger(nCasterLevel);
    int nAffected, nCnt;

    // Determine duration in minutes (10/caster level)
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effefcts and link
    effect eEthereal = EffectEthereal();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eCessate, eEthereal);

    // Make it versus animals only
    eLink = VersusRacialTypeEffect(eLink, RACIAL_TYPE_ANIMAL);

    // Apply it to us first
    oTarget = oCaster;

    // Make sure they are not immune to spells
    if(!PHS_TotalSpellImmunity(oTarget))
    {
        // Remove pervious castings of it
        PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_HIDE_FROM_ANIMALS, oTarget);

        //Fire cast spell at event for the specified target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HIDE_FROM_ANIMALS, FALSE);

        // Apply VNF and effect.
        PHS_ApplyDuration(oTarget, eLink, fDuration);
    }

    // Loop allies near to the caster
    nCnt = 1;
    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, oCaster, nCnt);
    while(GetIsObjectValid(oTarget) && nAffected < nCreatureExtraLimit &&
          GetDistanceToObject(oTarget) <= 3.33)
    {
        // Make sure they are not immune to spells
        if(!PHS_TotalSpellImmunity(oTarget))
        {
            // Remove pervious castings of it
            PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_HIDE_FROM_ANIMALS, oTarget);

            //Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HIDE_FROM_ANIMALS, FALSE);

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
