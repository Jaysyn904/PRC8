/*
12/12/19 by Stratovarius

Grasping Shadows, OnEnter

Master, Shadowscape
Level/School: 7th/Conjuration (Creation)
Range: Medium (100 ft. + 10 ft./level)
Area/Target: 20-ft.-radius spread
Duration: 1 round/level
Saving Throw: Will partial
Spell Resistance: See text

Stalks of shadows burst from the ground, as though desperate to escape the bonds of the earth, and immediately flail at everyone nearby.

This mystery creates an area of grasping tendrils that function as the spell Evard's black tentacles (PH 228), with one additional hazard: 
Anyone successfully grappled by a tentacle must attempt a Will save or go blind. A successful save means the individual is safe from blinding
during that particular grapple, but if she escapes and is then regrappled, she must make another saving throw. The blindness is permanent until magically cured.
*/

void DecrementTentacleCount(object oTarget, string sVar)
{
    SetLocalInt(oTarget, sVar, GetLocalInt(oTarget, sVar) - 1);
}

#include "shd_inc_shdfunc"
#include "prc_inc_combmove"

void main()
{
    object oShadow = GetAreaOfEffectCreator();
    object oTarget  = GetEnteringObject();
    object oAoE     = OBJECT_SELF;
    effect eDark = EffectDarkness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eDark, eDur);
    
    struct mystery myst = GetLocalMystery(oShadow, MYST_HOLD_MYST); 

    int iShadow = GetLevelByClass(CLASS_TYPE_SHADOWLORD, oTarget);  
  
	if (iShadow)    
	{      
		eLink = ShadowlordEffects(iShadow, eLink);  
		eLink = TagEffect(eLink, "SHADOWSIGHT+BLUR"); 		
	}  	

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oShadow) && GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE)
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_EVARDS_BLACK_TENTACLES));

        //Apply reduced movement effect and VFX_Impact
        //firstly, make them half-speed
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectMovementSpeedDecrease(50), oTarget);
        //now do grappling and stuff
        //cant already be grappled so no need to check that
        int nGrappleSucessful = FALSE;
        //this spell doesnt need to make a touch attack
        int nAttackerGrappleMod = myst.nShadowcasterLevel + 8;
        nGrappleSucessful = _DoGrappleCheck(OBJECT_INVALID, oTarget, nAttackerGrappleMod);
        if(nGrappleSucessful)
        {
            //now being grappled
            AssignCommand(oTarget, ClearAllActions());
            effect eHold = EffectCutsceneImmobilize();
            effect eEntangle = EffectVisualEffect(VFX_DUR_SPELLTURNING_R);
            effect eLink = EffectLinkEffects(eHold, eEntangle);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
            SetLocalInt(oTarget, "GrappledBy_"+ObjectToString(oAoE),
                GetLocalInt(oTarget, "GrappledBy_"+ObjectToString(oAoE))+1);
            DelayCommand(6.1, DecrementTentacleCount(oTarget, "GrappledBy_"+ObjectToString(oAoE)));
            
            // Apply the Blindness effect permanently if they fail
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_SPELL))
            {
                myst.eLink = EffectBlindness();
                if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, myst.eLink, oTarget, 0.0, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
            }            
        }
    }// end if - Difficulty check
}