//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Disintegrate
//:: FileName  sp_ray_disint.nss
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    //Make touch attack
    int nTouch = PRCDoRangedTouchAttack(oTarget);

    //Beam VFX.  Ornedan is my hero.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_DISINTEGRATE, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f);

    if(nTouch)
        DoSpellRay(SPELL_DISINTEGRATE, 13, 18);
}