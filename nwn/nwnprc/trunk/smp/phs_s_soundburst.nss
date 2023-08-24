/*:://////////////////////////////////////////////
//:: Spell Name Sound Burst
//:: Spell FileName PHS_S_SoundBurst
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Sonic. Level 2. Close range. 10ft Radius (3.33M), Fortitude partial, SR
    applies.

    You blast an area with a tremendous cacophony. Every creature in the area
    takes 1d8 points of sonic damage and must succeed on a Fortitude save to
    avoid being stunned for 1 round.

    Creatures that cannot hear are not stunned but are still damaged.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell says. RADIUS_SIZE_MEDIUM = 3.33M
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SOUND_BURST)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nDam;
    float fDelay;

    // Get duration of the stun (metamagic extend?)
    float fDuration = PHS_GetDuration(PHS_ROUNDS, 1, nMetaMagic);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eStun = EffectStunned();
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link stun effects
    effect eLink = EffectLinkEffects(eStun, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Apply AOE location explosion
    effect eExplode = EffectVisualEffect(VFX_FNF_SOUND_BURST);
    PHS_ApplyLocationVFX(lTarget, eExplode);

    // Get all targets in a sphere, medium (3.33M) radius, creatures only.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster))
        {
            //Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SOUND_BURST);

            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Spell resistance And immunity checking.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Roll damage for each target
                nDam = PHS_MaximizeOrEmpower(8, 1, nMetaMagic);

                // We will stun the target if they can hear
                if(PHS_GetCanHear(oTarget) &&
                  !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_STUN, fDelay) &&
                  !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS, fDelay))
                {
                    // Fortitude save negates the stun
                    if(PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_SONIC, oCaster, fDelay))
                    {
                        // Apply stun effects
                        DelayCommand(fDelay, PHS_ApplyDuration(oTarget, eLink, fDuration));
                    }
                }
                // Apply effects to the currently selected target.
                DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_FIRE));
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
