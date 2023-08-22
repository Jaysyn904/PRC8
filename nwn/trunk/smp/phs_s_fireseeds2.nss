/*:://////////////////////////////////////////////
//:: Spell Name Fire Seeds: Berries
//:: Spell FileName PHS_S_FireSeeds2
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////

    - We use the Berry Bombs as new items. We create the items, and then
      are able to, of course, place them all anywhere or even give them away.
      They are stored as local variables on the caster, so when they activate
      the class item which triggers it, it will get the locals.

      This means no more then 1 casting at once of the berries.

      If the berries are not in the area of the caster, then they will still be
      berries (and look red) but not have the spell save DC needed to trigger
      them, and also be deleted from the array.

      If you enter with any berries, they are stripped of any DC's if the times
      that it's been cast doesn't match the times the caster has cast it.
      SCRIPT: PHS_S_FIRESEEDS2

    This activates the berries set on the locals 1-8 on the caster.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oSeed, oPossessor, oTarget;
    object oArea = GetArea(oCaster);
    location lSeed;
    int nDam, nCnt, bDoBurst;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
    effect eDam;
    float fDelay;
    float fExplosionRadius = 1.67;

    // Get the spell saves from the caster.
    int nSpellSaveDC = GetLocalInt(oCaster, "PHS_SPELL_FIRESEEDS_SAVEDC");
    int nBonusDam = GetLocalInt(oCaster, "PHS_SPELL_FIRESEEDS_DICE");

    // We will get the location of each seed individually
    for(nCnt = 1; nCnt <= 8; nCnt++)
    {
        // Get the seed
        oSeed = GetLocalObject(oCaster, "PHS_SPELL_FIRESEEDS_ARRAY" + IntToString(nCnt));

        // Make sure it is valid
        if(GetIsObjectValid(oSeed))
        {
            // Reset the burst
            bDoBurst = FALSE;

            // Get the item possessor
            oPossessor = GetItemPossessor(oSeed);

            // Make sure the possessor (if valid) or the item, is in the same area
            // as the fire seeds activator.
            if(GetIsObjectValid(oPossessor))
            {
                // Possessor is valid. Use thier location
                if(GetArea(oPossessor) == oArea)
                {
                    // Apply VFX at location
                    lSeed = GetLocation(oPossessor);

                    // Set to do burst
                    bDoBurst = TRUE;
                }
                else
                {
                    // Else, destroy it
                    DestroyObject(oSeed);
                }
            }
            else
            {
                // Seed is on the ground
                if(oSeed == oArea)
                {
                    // Apply VFX at location
                    lSeed = GetLocation(oSeed);

                    // Set to do burst
                    bDoBurst = TRUE;
                }
                else
                {
                    // Else, destroy it
                    DestroyObject(oSeed);
                }
            }
            // Do we do the burst on the location lSeed?
            if(bDoBurst == TRUE)
            {
                // Apply the VFX
                PHS_ApplyLocationVFX(lSeed, eImpact);

                // Cycle through the targets within the spell shape until an invalid object is captured.
                oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fExplosionRadius, lSeed, TRUE, OBJECT_TYPE_CREATURE);
                while(GetIsObjectValid(oTarget))
                {
                    // Check PvP
                    if(!GetIsReactionTypeFriendly(oTarget))
                    {
                        // Get short delay as fireball
                        fDelay = GetDistanceBetweenLocations(lSeed, GetLocation(oTarget))/20;

                        // Apply effects to the currently selected target.
                        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FIRE_SEEDS);

                        // Randomise damage
                        nDam = PHS_MaximizeOrEmpower(6, 1, FALSE, nBonusDam);

                        // Get reflex adjusted damage
                        nDam = GetReflexAdjustedDamage(nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FIRE);

                        if(nDam > 0)
                        {
                            // Set the damage effect. It is now 1 per dice used.
                            eDam = EffectDamage(nDam, DAMAGE_TYPE_FIRE);

                            // Delay the damage and visual effects
                            DelayCommand(fDelay, PHS_ApplyInstantAndVFX(oTarget, eVis, eDam));
                        }
                    }
                    // Get the next target within the spell shape.
                    oTarget = GetNextObjectInShape(SHAPE_SPHERE, fExplosionRadius, lSeed, TRUE, OBJECT_TYPE_CREATURE);
                }
            }
        }
    }
}
