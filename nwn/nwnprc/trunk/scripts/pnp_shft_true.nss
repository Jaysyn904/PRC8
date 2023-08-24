//:://////////////////////////////////////////////
//:: Shifter - return to true form
//:: pnp_shft_true
//:://////////////////////////////////////////////
/** @file
    Undoes any shifting that the character may
    have undergone. Also removes any polymorph
    effects.


    @author Shane Hennessy
    @date   Modified - 2006.10.08 - rewritten by Ornedan
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_shifting"


void main()
{
    object oPC = OBJECT_SELF;

    // Attempt to unshift and if it fails, inform the user with a message so they don't wonder whether something is happening or not
    if(UnShift(oPC, TRUE) == UNSHIFT_FAIL)
        FloatingTextStrRefOnCreature(16828383, oPC, FALSE); // "Failed to return to true form!"
}
