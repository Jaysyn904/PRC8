//::///////////////////////////////////////////////
//:: Aura of Fear
//:: NW_S1_AuraFear.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
//:: Modified By: Brian Greinke
//:: Modified On: 2004/01/30
//:: Re: Added disable/reenable support
//:://////////////////////////////////////////////
//:: Modified By: Jaysyn
//:: Modified On: 2023/02/11
//:: Re: Added PnP Aura behavior support
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "utl_i_sqluuid"

void main()
{
//:: Declare major variables
	object oMob = GetAreaOfEffectCreator();
	
	int bPNPAuras = GetPRCSwitch(PRC_PNP_FEAR_AURAS);
	
	string sMobUUID = GetObjectUUID(oMob);
	
    //first, look to see if effect is already activated
    if ( GetHasSpellEffect(SPELLABILITY_AURA_FEAR, OBJECT_SELF) )
    {
        PRCRemoveSpellEffects( SPELLABILITY_AURA_FEAR, OBJECT_SELF, OBJECT_SELF );
        return;
    }

    //Set and apply AOE object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_FEAR);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, HoursToSeconds(100));
}
