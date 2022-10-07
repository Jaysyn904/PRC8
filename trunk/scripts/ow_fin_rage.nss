//::///////////////////////////////////////////////
//:: Orc Warlord
//:://////////////////////////////////////////////
/*
    Final Rage - All allies within 10 feet enter a rage.
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:://////////////////////////////////////////////

void main()
{
    // Declare major variables 
    object oTarget;
    location oLoc = GetLocation(OBJECT_SELF);

    //Determine friends in the radius around the character
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, oLoc);
    while (GetIsObjectValid(oTarget))
    {
        if(GetIsFriend(oTarget))
        {
            // Casts rage on target
            AssignCommand(oTarget, ClearAllActions());
            AssignCommand(oTarget, ActionCastSpellAtObject(307, oTarget, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE) );
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, oLoc);
    }
}