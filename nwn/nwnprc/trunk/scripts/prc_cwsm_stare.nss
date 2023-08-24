//::///////////////////////////////////////////////
//:: Complete Warrior Samurai Staredown class ability
//:: prc_cwsm_stare
//::///////////////////////////////////////////////
/** @file
    Staredown (Ex):
    At 6th level, a samurai becoms able to strike
    fear into his foes by his mere presence. He gains
    +4 on Intimidate checks and can demoralize an
    opponent.

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
    object oPC      = OBJECT_SELF;
    object oTarget  = PRCGetSpellTargetObject();

    // Target validity check
    if(oTarget != oPC &&                                          // Can't stare self down
       spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC) // PVP settings stuff
       )
    {
        // Let the target know something hostile happened
        SignalEvent(oTarget, EventSpellCastAt(oPC, PRCGetSpellId(), TRUE));

        // Intimidate DC calculation
        int nDC         = d20()                                                         // Die roll
                        + GetHitDice(oTarget)                                           // Hit dice
                        + max(0, GetAbilityModifier(ABILITY_WISDOM, oTarget))           // Wisdom bonus, no wisdom penalty
                        + (4 * (PRCGetCreatureSize(oTarget) - PRCGetCreatureSize(oPC))) // Adjust by 4 in favor of the bigger creature for each size category it is bigger than the smaller one
                        ;
        // Construct Intimidate effect
        effect eLink    =                          EffectAttackDecrease(2);
               eLink    = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL,2));
               eLink    = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS,2));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
               eLink    = ExtraordinaryEffect(eLink);
        // Determine duration. Normally 2 rounds, with Improved Staredown, 5
        float fDuration = RoundsToSeconds(GetHasFeat(FEAT_CWSM_IMPROVED_STAREDOWN, oPC) ?
                                           5 :
                                           2
                                          );

        // Make the skill roll and display results
        if(GetIsSkillSuccessful(oPC, SKILL_INTIMIDATE, nDC) && !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, oPC))
        {//                              "* Staredown - success! *"
            FloatingTextStringOnCreature("* " + GetStringByStrRef(16826174) + " - " + GetStringByStrRef(5353) + "! *", oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        }
        else//                              "* Staredown - failure! *"
            FloatingTextStringOnCreature("* " + GetStringByStrRef(16826174) + " - " + GetStringByStrRef(5354) + "! *", oPC);
    }
}
