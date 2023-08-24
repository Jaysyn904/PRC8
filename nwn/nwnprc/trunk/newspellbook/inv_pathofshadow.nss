//::///////////////////////////////////////////////
//:: Spell: Teleport
//:: sp_teleport
//:://////////////////////////////////////////////
/** @file
    Teleport

    Conjuration (Teleportation)
    Level: Sor/Wiz 5, Travel 5
    Components: V
    Casting Time: 1 standard action
    Range: Personal and touch
    Target: You and touched objects or other touched willing creatures
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: No

    This spell instantly transports you to a designated destination, which may
    be as distant as 100 miles per caster level. Interplanar travel is not
    possible. You may also bring one additional willing Medium or smaller
    creature or its equivalent (see below) per three caster levels. A Large
    creature counts as two Medium creatures, a Huge creature counts as two Large
    creatures, and so forth. All creatures to be transported must be in contact
    with one another, and at least one of those creatures must be in contact
    with you. *

    You must have some clear idea of the location and layout of the destination.
    The clearer your mental image, the more likely the teleportation works.
    Areas of strong physical or magical energy may make teleportation more
    hazardous or even impossible. **

    To see how well the teleportation works, roll d% and consult the Teleport
    table. Refer to the following information for definitions of the terms on
    the table.

    On Target: You appear where you want to be.
    Off Target: You appear safely a random distance away from the destination
      in a random direction.
    Far Off Target: You wind up somewhere completely different.
    Mishap: You and anyone else teleporting with you have gotten “scrambled.”
      You each take 1d10 points of damage, and you reroll on the chart to see
      where you wind up. For these rerolls, roll 1d20+80. Each time “Mishap”
      comes up, the characters take more damage and must reroll.

    On Target Off Target Way Off Target Mishap
    01–90     91–94      95–98          99–100


    Notes:
     *  Implemented as within 10ft of you due to the lovely quality of NWN location tracking code.
     ** Implemented as you having to have marked the location beforehand using the "Mark Location"
        feat, found under the Teleport Options radial.


    @author Ornedan
    @date   Created 2005.11.05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_teleport"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    /* Main script */
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    int nSpellID   = PRCGetSpellId();
    
    if(nSpellID == INVOKE_PATH_OF_SHADOW_SELF)
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(9999), oCaster);
    else
    {
        location lLoc = GetLocation(oCaster);
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lLoc, TRUE,
                          OBJECT_TYPE_CREATURE, GetPosition(oCaster));
        int nMaxCarry = nCasterLvl / 3,
            nCarry    = 0,
            nIncrease;
        while(GetIsObjectValid(oTarget))
        {
            if(GetFactionEqual(oCaster, oTarget) && oTarget != oCaster)
            {
                // Calculate how many carry slots the creature would take
                nIncrease = GetCreatureSize(oTarget) == CREATURE_SIZE_HUGE ? 4 :
                             GetCreatureSize(oTarget) == CREATURE_SIZE_LARGE ? 2 :
                             1;

                // Add others if the caster can carry them
                if(nCarry + nIncrease <= nMaxCarry)
                {
                    nCarry += nIncrease;
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(9999), oTarget);
                }
            }
            
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lLoc, TRUE,
                          OBJECT_TYPE_CREATURE, GetPosition(oCaster));
        }
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(9999), oCaster);
    }

    Teleport(oCaster, nCasterLvl, nSpellID == INVOKE_PATH_OF_SHADOW_PARTY, FALSE, "");
    

}
