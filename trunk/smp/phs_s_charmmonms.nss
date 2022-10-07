/*:://////////////////////////////////////////////
//:: Spell Name Charm Monster, Mass
//:: Spell FileName PHS_S_CharmMonMs
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Charm) [Mind-Affecting]
    Level: Brd 6, Sor/Wiz 8
    Components: V
    Casting Time: 1 standard action
    Range: Close (8M)
    Targets: One or more hostile enemy creatures within a 5M-radius sphere
    Duration: One day/level
    Saving Throw: Will negates
    Spell Resistance: Yes

    This spell functions like charm monster, except that mass charm monster
    affects a number of creatures whose combined HD do not exceed twice your
    level, or at least one creature regardless of HD. Creatures with the lowest
    HD are targeted first.

    The charming makes each creature effected regard you as its trusted friend
    and ally. If the any target is currently being threatened or attacked by you
    or your allies, however, it receives a +5 bonus on its saving throw.

    Any act by you or your apparent allies that threatens the charmed creature
    breaks the spell. You cannot control a charmed creature directly, but it may
    help in battle and not attack you.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Charms using Biowares EffectCharmed(), which, as tests show, just increases
    personal reputation.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck()) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    string sSpellLocal = "PHS_SPELL_CHARM_MASS" + ObjectToString(OBJECT_SELF);
    // x2 Caster level to affect with this spell, minimum one creature
    int nHD = nCasterLevel * 2;
    float fDistance, fDelay;
    int bContinueLoop, bOneCreatureDone, nCurrentHD, nLow;
    object oLowest;

    // Duration is 1 day/level. (24 hours/level)
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel * 24, nMetaMagic);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eCharm = EffectCharmed();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eMind, eCharm);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Apply AOE location explosion
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE);
    // If no valid targets exists ignore the loop
    if(GetIsObjectValid(oTarget))
    {
        bContinueLoop = TRUE;
    }
    // The above checks to see if there is at least one valid target.
    while((nHD > 0) && (bContinueLoop))
    {
        nLow = 99;
        bContinueLoop = FALSE;
        //Get the first creature in the spell area
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE);
        while(GetIsObjectValid(oTarget))
        {
            // Already affected check
            if(!GetLocalInt(oTarget, sSpellLocal))
            {
                // Make faction check to ignore allies
                if(!GetIsReactionTypeFriendly(oTarget) &&
                // Make sure they are not immune to spells
                   !PHS_TotalSpellImmunity(oTarget))
                {
                    //Get the current HD of the target creature
                    nCurrentHD = GetHitDice(oTarget);

                    // Check to see if the HD are lower than the current Lowest HD stored and that the
                    // HD of the monster are lower than the number of HD left to use up.
                    // * Special for mass charm - at least 1 target targeted.
                    if((nCurrentHD <= nHD || bOneCreatureDone == FALSE) && ((nCurrentHD < nLow) ||
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
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE);
        }
        // Check to see if oLowest returned a valid object
        if(GetIsObjectValid(oLowest))
        {
            // We've done at least one creature now
            bOneCreatureDone = TRUE;

            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oLowest, PHS_SPELL_CHARM_MONSTER_MASS, FALSE);

            // Set a local int to make sure the creature is not used twice in the
            // pass.  Destroy that variable in 0.1 seconds to remove it from
            // the creature
            SetLocalInt(oLowest, sSpellLocal, TRUE);
            DelayCommand(0.1, DeleteLocalInt(oLowest, sSpellLocal));

            // Delay based on range
            fDelay = fDistance/20;

            // Make SR check
            if(!PHS_SpellResistanceCheck(oCaster, oLowest, fDelay) &&
               !PHS_ImmunityCheck(oLowest, IMMUNITY_TYPE_CHARM, fDelay) &&
               !PHS_ImmunityCheck(oLowest, IMMUNITY_TYPE_MIND_SPELLS, fDelay))
            {
                // Will saving throw
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oLowest, nSpellSaveDC - (5 * GetIsInCombat(oLowest)), SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
                {
                    // Apply effects
                    PHS_ApplyDurationAndVFX(oLowest, eVis, eLink, fDuration);
                }
            }
        }
        // Remove the HD of the creature from the total
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }
}
