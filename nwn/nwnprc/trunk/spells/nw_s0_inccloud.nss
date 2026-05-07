//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables, including the Area of Effect object.
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGFIRE);
    //Capture the spell target location so that the AoE object can be created.
    location lTarget = PRCGetSpellTargetLocation();
    int CasterLvl = PRCGetCasterLevel();
    int nDuration = CasterLvl;
    effect eImpact = EffectVisualEffect(260);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    if(nDuration < 1)
    {
        nDuration = 1;
    }
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Check for metamagic extend
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Create the object at the location so that the objects scripts will start working.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

    object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_FOGFIRE");
    SetAllAoEInts(SPELL_INCENDIARY_CLOUD, oAoE, PRCGetSpellSaveDC(SPELL_INCENDIARY_CLOUD, SPELL_SCHOOL_EVOCATION), 0, CasterLvl);
    SetLocalInt(oAoE, "IC_Damage", ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_FIRE));
	SetLocalObject(oAoE, "ExtraordinarySpellAim_Caster", OBJECT_SELF);

    PRCSetSchool();
}