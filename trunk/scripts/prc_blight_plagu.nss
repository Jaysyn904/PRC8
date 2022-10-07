//::///////////////////////////////////////////////
/*
This ability functions like the contagious touch ability, except that no attack roll is required and it affects all targets the blighter designates within a 20-foot radius. Plague is usable once per day.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Jan 20, 2019
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void DoPlague(object oCaster, object oTarget)
{
     int nDC = PRCGetSaveDC(oTarget, oCaster);

        int nRand = Random(7)+1;
        int nDisease;
        //Use a random seed to determine the disease that will be delivered.
        switch (nRand)
        {
            case 1:
                nDisease = DISEASE_CONTAGION_BLINDING_SICKNESS;
            break;
            case 2:
                nDisease = DISEASE_CONTAGION_CACKLE_FEVER;
            break;
            case 3:
                nDisease = DISEASE_CONTAGION_FILTH_FEVER;
            break;
            case 4:
                nDisease = DISEASE_CONTAGION_MINDFIRE;
            break;
            case 5:
                nDisease = DISEASE_CONTAGION_RED_ACHE;
            break;
            case 6:
                nDisease = DISEASE_CONTAGION_SHAKES;
            break;
            case 7:
                nDisease = DISEASE_CONTAGION_SLIMY_DOOM;
            break;
        }
            effect eDisease = EffectDisease(nDisease);
            // Make the real first save against the spell's DC
             if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DISEASE))
                {
                    //The effect is permament because the disease subsystem has its own internal resolution
                    //system in place.
                    // The first disease save is against an impossible fake DC, since at this point the
                    // target has already failed their real first save.
                    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget, 0.0f, TRUE, -1);
                }
}

void main()
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nDamage;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_DUR_AURA_DISEASE);
    effect eVis = EffectVisualEffect(VFX_IMP_DISEASE_S);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = PRCGetSpellTargetLocation();

    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster) && GetIsObjectValid(oTarget))
    {
        //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                        // Apply effects to the currently selected target.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        //This visual effect is applied to the target object not the location as above.  This visual effect
                        //represents the flame that erupts on the target not on the ground.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        DelayCommand(fDelay, DoPlague(oCaster, oTarget));

       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}