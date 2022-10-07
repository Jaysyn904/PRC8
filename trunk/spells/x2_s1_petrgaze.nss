//::///////////////////////////////////////////////
//:: Gaze attack for shifter forms
//:: x2_s1_petrgaze
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

  Petrification gaze  for polymorph type
  basilisk and medusa

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July, 09, 2003
//:://////////////////////////////////////////////

//:: modified by AshLancer 1/23/2020 for PRC stuff

#include "prc_inc_spells"
#include "x0_i0_match"
#include "x2_inc_shifter"

void main()
{

    //--------------------------------------------------------------------------
    // Enforce artifical use limit on that ability
    //--------------------------------------------------------------------------
    if (ShifterDecrementGWildShapeSpellUsesLeft() <1 )
    {
        FloatingTextStrRefOnCreature(83576, OBJECT_SELF);
        return;
    }

    //--------------------------------------------------------------------------
    // Make sure we are not blind
    //--------------------------------------------------------------------------
    if (GetHasEffect(EFFECT_TYPE_BLINDNESS, OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(84530, OBJECT_SELF, FALSE);
        return;
    }

    //--------------------------------------------------------------------------
    // Calculate Save DC
    //--------------------------------------------------------------------------
    int nDC = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_EASY_MEDIUM);

    float fDelay;
    object oSelf = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nHitDice = PRCGetCasterLevel(oSelf);
    int nSpellID = PRCGetSpellId();   

    //--------------------------------------------------------------------------
    // Loop through all available targets in spellcone
    //--------------------------------------------------------------------------
    location lFinalTarget = PRCGetSpellTargetLocation();
    vector vFinalPosition;
    if ( lFinalTarget == GetLocation(oSelf) )
    {
        // Since the target and origin are the same, we have to determine the
        // direction of the spell from the facing of OBJECT_SELF (which is more
        // intuitive than defaulting to East everytime).

        // In order to use the direction that OBJECT_SELF is facing, we have to
        // instead we pick a point slightly in front of OBJECT_SELF as the target.
        vector lTargetPosition = GetPositionFromLocation(lFinalTarget);
        vFinalPosition.x = lTargetPosition.x +  cos(GetFacing(oSelf));
        vFinalPosition.y = lTargetPosition.y +  sin(GetFacing(oSelf));
        lFinalTarget = Location(GetAreaFromLocation(lFinalTarget),vFinalPosition,GetFacingFromLocation(lFinalTarget));
    }
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lFinalTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        fDelay = GetDistanceBetween(oSelf, oTarget)/20;

        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oSelf) && oTarget != oSelf)
        {
            DelayCommand(fDelay, PRCDoPetrification(nHitDice, oSelf, oTarget, nSpellID, nDC));
            //Get next target in spell area
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lFinalTarget, TRUE);
    }

}


