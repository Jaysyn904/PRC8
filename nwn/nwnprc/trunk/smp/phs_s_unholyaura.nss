/*:://////////////////////////////////////////////
//:: Spell Name Unholy Aura
//:: Spell FileName PHS_S_UnholyAura
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration [Evil]
    Level: Clr 8, Evil 8
    Components: V, S, F
    Casting Time: 1 standard action
    Range: 6.67M (20 ft.)
    Targets: One creature/level in a 6.67M-radius (20-ft.) burst centered on you
    Duration: 1 round/level (D)
    Saving Throw: See text
    Spell Resistance: Yes (harmless)

    A malevolent darkness surrounds the subjects, protecting them from attacks,
    granting them resistance to spells cast by good creatures, and weakening
    good creatures when they strike the subjects. This abjuration has four
    effects.

    First, each warded creature gains a +4 deflection bonus to AC and a +4
    resistance bonus on saves. Unlike the effect of protection from good, this
    benefit applies against all attacks, not just against attacks by good
    creatures.

    Second, a warded creature gains spell resistance 25 against good spells and
    spells cast by good creatures.

    Third, the abjuration blocks possession and mental influence, just as
    protection from good does.

    Finally, if a good creature succeeds on a melee attack against a warded
    creature, the offending attacker takes 1d6 points of temporary Strength
    damage (Fortitude negates).

    Focus: A tiny reliquary containing some sacred relic, such as a piece of
    parchment from an unholy text. The reliquary costs at least 500 gp.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the other 3 versions, havn't done the "Finally" part.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_UNHOLY_AURA)) return;

    // Check for 500GP evil relic item
    // - Only a focus, not a requirement
    if(!PHS_ComponentFocusItem(PHS_ITEM_EVIL_RELIC_500, "Evil Relic worth 500GP", "Unholy Aura")) return;

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
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR);
    effect eSR = EffectSpellResistanceIncrease(25);
    effect eAC = EffectACIncrease(4, AC_DEFLECTION_BONUS);
    effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
    effect eImmunities = PHS_CreateCompulsionImmunityLink();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Only the SR and immunities are vs chaos.
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
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_UNHOLY_AURA, FALSE);

            // Remove previous castings
            PHS_RemoveProtectionFromAlignment(oTarget, ALIGNMENT_GOOD, 3);

            // Apply effects
            PHS_ApplyDuration(oTarget, eLink, fDuration);
        }
        nCnt++;
        oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oCaster, nCnt);
    }
}
