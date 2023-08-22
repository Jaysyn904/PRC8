//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Flesh to Stone
//:: FileName  sp_ray_flshstn.nss
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = 13;
    int nDC = 18;

    //Make touch attack
    int nTouch = PRCDoRangedTouchAttack(oTarget);

    //Beam VFX.  Ornedan is my hero.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_MIND, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f);

    if(nTouch)
        DoSpellRay(SPELL_FLESH_TO_STONE, 13, 18);
}
