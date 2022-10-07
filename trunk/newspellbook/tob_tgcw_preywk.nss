//////////////////////////////////////////////////
//  Prey on the Weak
//  tob_tgcw_preywk.nss
//  Tenjac  10/19/07
//////////////////////////////////////////////////
/** @file Prey on the Weak
Tiger Claw (Stance)
Level: Swordsage 7, warblade 7
Prerequisite: Two Tiger Claw maneuvers
Initiation Action: 1 swift action
Range: Personal
Target: You
Duration: Stance

You scythe through weaker foes like a mighty predator turned loose among a herd of prey.

With each foe you strike, your bloodlust and battle fury rises ever higher. After a brief
moment of explosive rage, the foes around you are left bloodied, torn, and moaning.

Whenever an opponent within 10 feet of you drops to -1 or fewer hit points, whether from your
attack, an ally's strike, or some other cause, you can immediately make an attack of opportunity
against any opponent within your threatened area.
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
                effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        	if (GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER, oInitiator) >= 2)
        	{
    			eVis = EffectLinkEffects(eVis, EffectMovementSpeedIncrease(33));
    			eVis = EffectLinkEffects(eVis, EffectACIncrease(1));
    		}                
    		if (GetLocalInt(oInitiator, "TigerFangSharpClaw"))  eVis = EffectLinkEffects(eVis, EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_BASE_WEAPON));       	       
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
        }
}