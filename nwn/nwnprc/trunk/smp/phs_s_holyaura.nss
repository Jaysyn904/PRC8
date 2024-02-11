/*:://////////////////////////////////////////////
//:: Spell Name Holy Aura
//:: Spell FileName PHS_S_HolyAura
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration [Good]
    Level: Clr 8, Good 8
    Components: V, S, F
    Casting Time: 1 standard action
    Range: 6.67 M.
    Targets: One creature/level in a 6.67-M.-radius burst centered on you
    Duration: 1 round/level (D)
    Saving Throw: See text
    Spell Resistance: Yes (harmless)

    A brilliant divine radiance surrounds the subjects, protecting them from
    attacks, granting them resistance to spells cast by evil creatures, and
    causing evil creatures to become blinded when they strike the subjects.
    This abjuration has four effects.

    First, each warded creature gains a +4 deflection bonus to AC and a +4
    resistance bonus on saves. Unlike protection from evil, this benefit applies
    against all attacks, not just against attacks by evil creatures.

    Second, each warded creature gains spell resistance 25 against evil spells
    and spells cast by evil creatures.

    Third, the abjuration blocks possession and mental influence, just as
    protection from evil does.

    Finally, if an evil creature succeeds on a melee attack against a warded
    creature, the offending attacker is blinded (Fortitude save negates, as
    blindness/deafness, but against holy aura’s save DC).

    Focus: A tiny reliquary containing some sacred relic. The reliquary costs at
    least 500 gp.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Not got the "final" part of the 4 effects, the rest is easy, however.

    Requires a sacred relic of chaos, at least 500GP in value.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HOLY_AURA)) return;

    // Check for 500GP holy relic item
    // - Only a focus, not a requirement
    if(!PHS_ComponentFocusItem(PHS_ITEM_HOLY_RELIC_500, "Holy Relic worth 500GP", "Holy Aura")) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // 1 creature level.
    int nDoneCreatures = 0;

    // 1 Round/level duration
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Delcare effects
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR);
    effect eSR = EffectSpellResistanceIncrease(25);
    effect eAC = EffectACIncrease(4, AC_DEFLECTION_BONUS);
    effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
    effect eImmunities = PHS_CreateCompulsionImmunityLink();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Only the SR and immunities are vs evil.
    // * Need to check if this works correctly
    eSR = VersusAlignmentEffect(eSR, ALIGNMENT_ALL, ALIGNMENT_EVIL);
    eImmunities = VersusAlignmentEffect(eImmunities, ALIGNMENT_ALL, ALIGNMENT_EVIL);

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
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Add one to nDoneCreatures
            nDoneCreatures++;

            // Signal spell cast at event
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HOLY_AURA, FALSE);

            // Remove previous castings
            PHS_RemoveProtectionFromAlignment(oTarget, ALIGNMENT_EVIL, 3);

            // Apply effects
            PHS_ApplyDuration(oTarget, eLink, fDuration);
        }
        nCnt++;
        oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oCaster, nCnt);
    }
}
