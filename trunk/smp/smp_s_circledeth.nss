/*:://////////////////////////////////////////////
//:: Spell Name Circle of Death
//:: Spell FileName SMP_S_CircleDeth
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy [Death]
    Level: Sor/Wiz 6
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Medium (20M)
    Area: Several living creatures within a 13.33-M.-radius burst
    Duration: Instantaneous
    Saving Throw: Fortitude negates
    Spell Resistance: Yes

    A circle of death snuffs out the life force of living creatures, killing
    them instantly.

    The spell slays 1d4 HD worth of living creatures per caster level (maximum
    20d4). Creatures with the fewest HD are affected first; among creatures
    with equal HD, those who are closest to the burst’s point of origin are
    affected first. No creature of 9 or more HD can be affected, and Hit Dice
    that are not sufficient to affect a creature are wasted.

    Material Component: The powder of a crushed black pearl with a minimum
    value of 500 gp.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell - Bioware's is almost like this.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck()) return;

    // Check for the Crushed Black Pearl (500GP value)
    if(!SMP_ComponentExactItemRemove(PHS_ITEM_CRUSHED_BLACK_PEARL, "Crushed Black Pearl", "Circle of Death")) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    string sSpellLocal = "SMP_SPELL_CIRCLE_OF_DEATH" + ObjectToString(OBJECT_SELF);
    float fDistance, fDelay;
    int bContinueLoop, nCurrentHD, nLow;
    object oLowest;

    // Limit dice up to 20.
    int nDice = SMP_LimitInteger(nCasterLevel, 20);

    // Get amount of HD we can kill -
    // The spell slays 1d4 HD worth of living creatures per caster level (maximum 20d4).
    int nHD = SMP_MaximizeOrEmpower(4, nDice, nMetaMagic);
    // Max HD to affect is level 9
    int nMaxHD = 9;

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eDeath = EffectDeath();

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(SMP_VFX_FNF_LOS_EVIL_40);//40ft radius
    SMP_ApplyLocationVFX(lTarget, eImpact);

    // Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 13.33, lTarget, TRUE);
    // If no valid targets exists ignore the loop
    if(GetIsObjectValid(oTarget))
    {
        bContinueLoop = TRUE;
    }
    // The above checks to see if there is at least one valid target.
    while((nHD > 0) && (bContinueLoop))
    {
        nLow = 999;
        bContinueLoop = FALSE;
        // Get the first creature in the spell area
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 13.33, lTarget, TRUE);
        while(GetIsObjectValid(oTarget))
        {
            // Already affected check
            if(!GetLocalInt(oTarget, sSpellLocal))
            {
                // Make faction check to ignore allies
                if(!GetIsReactionTypeFriendly(oTarget) &&
                // Must be under nMaxHD to be a valid target
                    GetHitDice(oTarget) <= nMaxHD &&
                // Make sure they are not immune to spells
                   !SMP_TotalSpellImmunity(oTarget) &&
                // Must be alive
                    SMP_GetIsAliveCreature(oTarget))
                {
                    //Get the current HD of the target creature
                    nCurrentHD = GetHitDice(oTarget);

                    // Check to see if the HD are lower than the current Lowest HD stored and that the
                    // HD of the monster are lower than the number of HD left to use up.
                    if(nCurrentHD <= nHD && ((nCurrentHD < nLow) ||
                      (nCurrentHD <= nLow &&
                       GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) <= fDistance)))
                    {
                        nLow = nCurrentHD;
                        fDistance = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget));
                        oLowest = oTarget;
                        bContinueLoop = TRUE;
                    }
                }
                else
                {
                    // Immune to it in some way, ignore on next pass
                    SetLocalInt(oTarget, sSpellLocal, TRUE);
                    DelayCommand(0.1, DeleteLocalInt(oTarget, sSpellLocal));
                }
            }
            //Get the next target in the shape
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 13.33, lTarget, TRUE);
        }
        // Check to see if oLowest returned a valid object
        if(GetIsObjectValid(oLowest))
        {
            // Fire cast spell at event for the specified target
            SMP_SignalSpellCastAt(oLowest, SMP_SPELL_CIRCLE_OF_DEATH);

            // Set a local int to make sure the creature is not used twice in the
            // pass.  Destroy that variable in 0.1 seconds to remove it from
            // the creature
            SetLocalInt(oLowest, sSpellLocal, TRUE);
            DelayCommand(0.1, DeleteLocalInt(oLowest, sSpellLocal));

            // Delay based on range
            fDelay = fDistance/20;

            // Make SR and Death Immunity check
            if(!SMP_SpellResistanceCheck(oCaster, oLowest, fDelay) &&
               !SMP_ImmunityCheck(oLowest, IMMUNITY_TYPE_DEATH, fDelay))
            {
                // Fortitude saving throw
                if(!SMP_SavingThrow(SAVING_THROW_FORT, oLowest, nSpellSaveDC, SAVING_THROW_TYPE_DEATH, oCaster, fDelay))
                {
                    // Apply effects
                    DelayCommand(fDelay, SMP_ApplyInstantAndVFX(oTarget, eVis, eDeath));
                }
            }
        }
        // Remove the HD of the creature from the total
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }
}
