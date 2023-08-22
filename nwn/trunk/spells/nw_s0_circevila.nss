//::///////////////////////////////////////////////
//:: Magic Cirle Against Evil
//:: NW_S0_CircEvilA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Add basic protection from evil effects to
    entering allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 20, 2001
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"
#include "prc_inc_template"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);

    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    object oAOE    = OBJECT_SELF;
    int nSpellID   = GetLocalInt(oAOE, "X2_AoE_SpellID");
	effect eLink;

    if(GetIsFriend(oTarget, oCaster))
    {
        //Declare major variables
		if (GetHasTemplate(TEMPLATE_SAINT, oCaster))
        {
			eLink = PRCCreateProtectionFromAlignmentLink(ALIGNMENT_EVIL, 2);
		}
		
		else 
		{
			eLink = PRCCreateProtectionFromAlignmentLink(ALIGNMENT_EVIL);
		}
		
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_MAGIC_CIRCLE_AGAINST_EVIL, FALSE));

        //Apply the VFX impact and effects
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, FALSE);
    }
    if (nSpellID == SPELL_HALLOW)
    	SetLocalInt(oTarget, "HallowTurn", TRUE);
    PRCSetSchool();
}