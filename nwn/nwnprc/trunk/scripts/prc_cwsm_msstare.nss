//::///////////////////////////////////////////////
//:: Complete Warrior Samurai Mass Staredown class ability
//:: prc_cwsm_msstare
//::///////////////////////////////////////////////
/** @file
    Mass Staredown (Ex):
    At 10th level, a samurai has sufficient presence
    that he can cow multiple foes. Using a Intimidate
    check, the samurai can demoralize all opponents
    within 30 feet with a single standard action.

    SRD on Intimidate - Demoralize Opponent:
    You can also use Intimidate to weaken an
    opponent's resolve in combat. To do so, make an
    Intimidate check opposed by the target's modified
    level check (1d20 + hit dice + wisdom bonus,
    if any). If you win, the targe becomes shaken for
    1 round. A shaken character takes a -2 penalty
    on attack rolls, ability checks and saving
    throws.

    @date   Modified - 2006.07.04
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    //Declare major variables
    object oPC       = OBJECT_SELF;
    location lTarget = GetLocation(oPC);
    int nPCSize      = PRCGetCreatureSize(oPC);
    int nSpellID     = PRCGetSpellId();
    int nDC;
    // Construct Intimidate effect
    effect eLink     =                          EffectAttackDecrease(2);
           eLink     = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL,2));
           eLink     = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS,2));
           eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
           eLink     = ExtraordinaryEffect(eLink);
    // Determine duration. Normally 2 rounds, with Improved Staredown, 5
    float fDuration  = RoundsToSeconds(GetHasFeat(FEAT_CWSM_IMPROVED_STAREDOWN, oPC) ?
                                        5 :
                                        2
                                       );
    float fRadius    = FeetToMeters(30.0f);

    // Loop over creatures in range
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE);
    while (GetIsObjectValid(oTarget))
    {
        // Target validity check
        if(oTarget != oPC &&                                           // Can't stare self down
           spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC) // Only hostiles
           )
        {
            // Let the target know something hostile happened
            SignalEvent(oTarget, EventSpellCastAt(oPC, nSpellID, TRUE));

            // Determine DC for this target
            nDC = d20()                                               // Die roll
                + GetHitDice(oTarget)                                 // Hit dice
                + max(0, GetAbilityModifier(ABILITY_WISDOM, oTarget)) // Wisdom bonus, no wisdom penalty
                + (4 * (PRCGetCreatureSize(oTarget) - nPCSize))       // Adjust by 4 in favor of the bigger creature for each size category it is bigger than the smaller one
                ;

            // Roll and apply effect in case of success
            if(GetIsSkillSuccessful(oPC, SKILL_INTIMIDATE, nDC) && !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, oPC))
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        }// end if - Target validity check

        // Get next target in area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE);
    }// end while - Loop over creatures in 30ft area
}
