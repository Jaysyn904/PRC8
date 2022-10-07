//::////////////////////////////////////////////////////////
//:: Name      Eye of the Beholder: Inlfict Moderate Wounds
//:: FileName  sp_ray_slow.nss
//::////////////////////////////////////////////////////////

#include "prc_inc_sp_tch"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    //Make touch attack
    int nTouch = PRCDoRangedTouchAttack(oTarget);

    //Beam VFX.  Ornedan is my hero.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_EVIL, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f);

    if(nTouch)
        DoSpellRay(SPELL_INFLICT_MODERATE_WOUNDS, 13, 18);
}