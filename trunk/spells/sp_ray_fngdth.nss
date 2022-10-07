//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Finger of Death
//:: FileName  sp_ray_fingdth.nss
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    //Make touch attack
    int nTouch = PRCDoRangedTouchAttack(oTarget);

    //Beam VFX.  Ornedan is my hero.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_EVIL, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f);

    if (nTouch)
        DoSpellRay(SPELL_FINGER_OF_DEATH, 13, 18);
}