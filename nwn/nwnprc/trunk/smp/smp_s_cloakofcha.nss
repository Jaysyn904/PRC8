/*:://////////////////////////////////////////////
//:: Spell Name Cloak of Chaos
//:: Spell FileName SMP_S_CloakofCha
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration [Chaotic]
    Level: Chaos 8, Clr 8
    Components: V, S, F
    Casting Time: 1 standard action
    Range: 6.67M.
    Targets: One allied creature/level in a 6.67-M.-radius burst centered on you
    Duration: 1 round/level (D)
    Saving Throw: See text
    Spell Resistance: Yes (harmless)

    A random pattern of color surrounds the subjects, protecting them from
    attacks, granting them resistance to spells cast by lawful creatures, and
    causing lawful creatures that strike the subjects to become confused. This
    abjuration has four effects.

    First, each warded creature gains a +4 deflection bonus to AC and a +4
    resistance bonus on saves. Unlike protection from law, the benefit of this
    spell applies against all attacks, not just against attacks by lawful
    creatures.

    Second, each warded creature gains spell resistance 25 against lawful spells
    and spells cast by lawful creatures.

    Third, the abjuration blocks possession and mental influence, providing
    immunity to Domination and Charming effects, just as protection from law does.

    Finally, if a lawful creature succeeds on a melee attack against a warded
    creature, the offending attacker is confused for 1 round (Will save negates,
    as with the confusion spell, but against the save DC of cloak of chaos).

    Focus: A tiny reliquary containing some sacred relic, such as a scrap of
    parchment from a chaotic text. The reliquary costs at least 500 gp.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Not got the "final" part of the 4 effects, the rest is easy, however.

    Requires a sacred relic of chaos, at least 500GP in value.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck()) return;

    // Check for 500GP chaotic relic item
    // - Only a focus, not a requirement
    if(!SMP_ComponentFocusItem(SMP_ITEM_CHAOS_RELIC_500, "Chaotic Relic worth 500GP", "Cloak of Chaos")) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();

    // 1 creature level.
    int nDoneCreatures = 0;

    // 1 Round/level duration
    float fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

    // Delcare effects
    effect eDur = EffectVisualEffect(SMP_VFX_DUR_PROTECTION_CHAOS_MAJOR);
    effect eSR = EffectSpellResistanceIncrease(25);
    effect eAC = EffectACIncrease(4, AC_DEFLECTION_BONUS);
    effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
    effect eImmunities = SMP_CreateCompulsionImmunityLink();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Only the SR and immunities are vs law.
    // * Need to check if this works correctly
    eSR = VersusAlignmentEffect(eSR, ALIGNMENT_LAWFUL);
    eImmunities = VersusAlignmentEffect(eImmunities, ALIGNMENT_LAWFUL);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eSR);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eSaves);
    eLink = EffectLinkEffects(eLink, eImmunities);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Loop all targets without effect nearby
    int nCnt = 0;
    oTarget = oCaster;
    // Loop for 6.67M range
    while(GetIsObjectValid(oTarget) && nDoneCreatures < nCasterLevel &&
          GetDistanceToObject(oTarget) <= 6.67)
    {
        // Make sure they are in our LOS, are a friend too.
        if(LineOfSightObject(oCaster, oTarget) &&
          (GetIsFriend(oTarget) || GetFactionEqual(oTarget)) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            // Add one to nDoneCreatures
            nDoneCreatures++;

            // Signal spell cast at event
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_CLOAK_OF_CHAOS, FALSE);

            // Remove previous castings
            SMP_RemoveProtectionFromAlignment(oTarget, ALIGNMENT_LAWFUL, 3);

            // Apply effects
            SMP_ApplyDuration(oTarget, eLink, fDuration);
        }
        nCnt++;
        oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oCaster, nCnt);
    }
}
