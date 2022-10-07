//::///////////////////////////////////////////////
//:: Mass Contagion
//:: sp_mcontagion
//:://////////////////////////////////////////////
/** @file
    
    All targets in a RADIUS_SIZE_HUGE sphere must
    or be struck down with Blidning Sickness, Cackle
    Fever, Filth Fever Mind Fire, Red Ache,
    the Shakes or Slimy Doom.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
if (!X2PreSpellCastCode()) return;


    // Get the spell target location as opposed to the spell target.
    location lTarget = PRCGetSpellTargetLocation();

    // Get the effective caster level.
    int nCasterLvl = PRCGetCasterLevel();
    int nPenetr = nCasterLvl + SPGetPenetr();
    float fDelay;
    int nRand = Random(7)+1;
    int nDisease, nDC;
    
    //Use a random seed to determine the disease that will be delivered.
    switch (nRand)
    {
        case 1:
        nDisease = DISEASE_BLINDING_SICKNESS;
        break;
        case 2:
        nDisease = DISEASE_CACKLE_FEVER;
        break;
        case 3:
        nDisease = DISEASE_FILTH_FEVER;
        break;
        case 4:
        nDisease = DISEASE_MINDFIRE;
        break;
        case 5:
        nDisease = DISEASE_RED_ACHE;
        break;
        case 6:
        nDisease = DISEASE_SHAKES;
        break;
        case 7:
        nDisease = DISEASE_SLIMY_DOOM;
        break;
    }

    effect eDisease = EffectDisease(nDisease);

    // Declare the spell shape, size and the location.  Capture the first target object in the shape.
    // Cycle through the targets within the spell shape until an invalid object is captured.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        fDelay = PRCGetSpellEffectDelay(lTarget, oTarget);
        nDC = PRCGetSaveDC(oTarget, OBJECT_SELF);
        
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            PRCSignalSpellEvent(oTarget);

            if (!PRCDoResistSpell(OBJECT_SELF, oTarget, nPenetr))
            {
                // Make the real first save against the spell's DC
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                {
                    //The effect is permament because the disease subsystem has its own internal resolution
                    //system in place.
                    // The first disease save is against an impossible fake DC, since at this point the
                    // target has already failed their real first save.
                    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget, 0.0f, TRUE, -1, nCasterLvl);
                }
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

PRCSetSchool();
}
