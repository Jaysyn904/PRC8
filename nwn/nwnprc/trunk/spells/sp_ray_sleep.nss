//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Sleep
//:: FileName  sp_ray_sleep.nss
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"


void main()
{
    //Declare major variables
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    //Make touch attack
    int nTouch = PRCDoRangedTouchAttack(oTarget);

    //Beam VFX.  Ornedan is my hero.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_MIND, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f);

    if(nTouch)
        DoSpellRay(SPELL_SLEEP, 13, 18);
}