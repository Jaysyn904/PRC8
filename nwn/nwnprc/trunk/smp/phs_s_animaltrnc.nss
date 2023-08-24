/*:://////////////////////////////////////////////
//:: Spell Name Animal Trance
//:: Spell FileName PHS_S_AnimalTrnc
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting, Sonic], Close range, target is
    animals or beasts with intelligence 3 (1 or 2 in 3E)
    Duration: Concentration
    Saving Throw: Will negates; see text
    Spell Resistance: Yes

    Your swaying motions and music (or singing, or chanting) compel animals and
    magical beasts to do nothing but watch you. Only a creature with an
    Intelligence score of 1 or 2 can be fascinated by this spell. Roll 2d6 to
    determine the total number of HD worth of creatures that you fascinate. The
    closest targets are selected first until no more targets within range can
    be affected.

    A magical beast, a dire animal, or an animal trained to attack or guard is
    allowed a saving throw; an animal not trained to attack or guard is not.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell. They always get the save unless they are actually set as a
    non-attack animal.

    Also, the concentration is taken as not doing another action and staying
    within the spell range of the creatures (else it is broken).

    The action check is done every 2 seconds.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_ANIMAL_TRANCE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nHD, nCnt, nRace;
    float fDelay, fDistance;

    // Get max to mesmorise
    int nMesmoriseMax = PHS_MaximizeOrEmpower(6, 2, nMetaMagic);

    // Declare effect
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    //effect eStun =

    // Up to 8M range, so all from the target location up to 8M from the caster.
    // They must be able to see the caster to be mesmorised.
    nCnt = 1;
    oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    while(GetIsObjectValid(oTarget))
    {
        // Must be within 8M, PvP check and can hear, and are not immune to magic
        fDistance = GetDistanceBetween(oCaster, oTarget);
        if(fDistance <= 8.0 && !GetIsReactionTypeFriendly(oTarget) &&
        // Make sure they are not immune to spells
          !PHS_TotalSpellImmunity(oTarget))
        {
            // Need to be an animal
            nRace = GetRacialType(oTarget);
            if((nRace == RACIAL_TYPE_ANIMAL ||
                nRace == RACIAL_TYPE_MAGICAL_BEAST) &&
            // Needs to have 3 intelligence
                GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) <= 3)
            {
                // Trance them
                // Trance!

                // Get delay
                fDelay = fDistance/20;

                // Spell resistance and immunity
                if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                {
                    // Immunity VS mind spells
                    if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS, fDelay))
                    {
                        // Will save VS mind spells.
                        if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
                        {

                        }
                    }
                }
            }
        }
        // Next one to the location
        nCnt++;
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    }
}
