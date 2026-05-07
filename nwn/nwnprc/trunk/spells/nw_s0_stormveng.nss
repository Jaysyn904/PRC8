//::///////////////////////////////////////////////
//:: Storm of Vengeance
//:: NW_S0_StormVeng.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates an AOE that decimates the enemies of
    the cleric over a 30ft radius around the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 8, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    effect eVis = EffectVisualEffect(VFX_FNF_STORM);
    int nAoE = AOE_PER_STORM;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(nAoE), lTarget, RoundsToSeconds(10) + 2.1);

    //Setup Area Of Effect object
    object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_STORM");
    SetAllAoEInts(SPELL_STORM_OF_VENGEANCE, oAoE, PRCGetSpellSaveDC(SPELL_STORM_OF_VENGEANCE, SPELL_SCHOOL_CONJURATION), 0, PRCGetCasterLevel(oCaster));
	SetLocalObject(oAoE, "ExtraordinarySpellAim_Caster", OBJECT_SELF);

    PRCSetSchool();
}