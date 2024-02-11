/*
   ----------------
   Lion's Roar

   tob_wtrn_lionror.nss
   ----------------

    18/08/07 by Stratovarius
*/ /** @file

    Lion's Roar

    Iron Heart (Boost)
    Level: Crusader 3, Warblade 3
    Initiation Action: 1 Swift Action
    Range: 60'
    Target: You
    Duration: 1 Round

    You unleash a sudden battle roar as your mighty blows fell an enemy. Inspired by
    your example, your allies fight with renewed energy and determination.
    
    All allies within range gain a +5 damage bonus.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void main()
{
    if (!PreManeuverCastCode())
    {
    // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
    	int nDuration = 1; //+ nChr;
    
    	effect eLink = EffectDamageIncrease(DAMAGE_BONUS_5);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	eLink = EffectLinkEffects(eLink, eDur);
    	effect eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);	
    	effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    	effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(oInitiator));
    	eLink = ExtraordinaryEffect(eLink);
	
    	oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), GetLocation(oInitiator));
    	while(GetIsObjectValid(oTarget))
    	{
             // Can't hear it if you're deaf
             if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget))
             {
                if(oTarget == oInitiator)
                {
                    effect eLinkBard = EffectLinkEffects(eLink, eVis);
                    eLinkBard = ExtraordinaryEffect(eLinkBard);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBard, oTarget, RoundsToSeconds(nDuration));

                }
                else if(GetIsFriend(oTarget))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                }
            }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), GetLocation(oInitiator));
    	}
    }
}