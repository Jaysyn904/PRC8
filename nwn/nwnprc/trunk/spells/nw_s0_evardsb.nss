//::///////////////////////////////////////////////
//:: Evards Black Tentacles: On Exit
//:: NW_S0_EvardsB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
This spell conjures a field of rubbery black tentacles, each 10 feet long.
These waving members seem to spring forth from the earth, floor, or whatever
surface is underfoot—including water. They grasp and entwine around creatures
that enter the area, holding them fast and crushing them with great strength.
Every creature within the area of the spell must make a grapple check, opposed
by the grapple check of the tentacles. Treat the tentacles attacking a particular
target as a Large creature with a base attack bonus equal to your caster level
and a Strength score of 19. Thus, its grapple check modifier is equal to your
caster level +8. The tentacles are immune to all types of damage.
Once the tentacles grapple an opponent, they may make a grapple check each round
on your turn to deal 1d6+4 points of bludgeoning damage. The tentacles continue
to crush the opponent until the spell ends or the opponent escapes.
Any creature that enters the area of the spell is immediately attacked by the
tentacles. Even creatures who aren’t grappling with the tentacles may move
through the area at only half normal speed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
//:: GZ: Removed SR, its not there by the book
//:: Primogenitor: Implemented 3.5ed rules
#include "prc_alterations"

void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(SPELL_EVARDS_BLACK_TENTACLES, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
                {
                    //If the effect was created by the Acid_Fog then remove it
                    if(GetEffectSpellId(eAOE) == SPELL_EVARDS_BLACK_TENTACLES)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}