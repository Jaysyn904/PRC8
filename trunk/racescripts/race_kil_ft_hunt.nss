/* Killoren Hunter, detect enemies in area*/
#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
        
    if(!GetLocalInt(oPC, "KillorenHunter")) return;
    
    location lTarget = GetLocation(oPC);

    //Get the first target in the radius around the caster
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget);
    while(GetIsObjectValid(oTarget))
    {
        FloatingTextStringOnCreature("A "+GetName(oTarget)+" approaches", oPC, FALSE);

        //Get the next target in the specified area around the caster
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget);
    }
}

