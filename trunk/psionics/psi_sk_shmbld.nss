//::///////////////////////////////////////////////
//:: Soulknife: Shape Mindblade
//:: psi_sk_shmbld
//::///////////////////////////////////////////////
/*
    Changes the shape of mindblades that will be
    next manifested and calls the manifesting script.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"


//////////////////////////////////////////////////
/* Local constants                              */
//////////////////////////////////////////////////

const int SHORTSWORD        = 2405;
const int DUAL_SHORTSWORDS  = 2406;
const int LONGSWORD         = 2407;
const int BASTARDSWORD      = 2408;


void main()
{
    object oPC = OBJECT_SELF;
    int nShape;
    
    switch(GetSpellId())
    {
        case SHORTSWORD:
            nShape = MBLADE_SHAPE_SHORTSWORD;
            break;
        case DUAL_SHORTSWORDS:
            nShape = MBLADE_SHAPE_DUAL_SHORTSWORDS;
            break;
        case LONGSWORD:
            nShape = MBLADE_SHAPE_LONGSWORD;
            break;
        case BASTARDSWORD:
            nShape = MBLADE_SHAPE_BASTARDSWORD;
            break;
        
        default:
            WriteTimestampedLogEntry("Wrong SpellId in Shape Mindblade");
    }
    
    SetPersistantLocalInt(oPC, MBLADE_SHAPE, nShape);
    
    // Manifest the new blade
    ExecuteScript("psi_sk_manifmbld", oPC);
}