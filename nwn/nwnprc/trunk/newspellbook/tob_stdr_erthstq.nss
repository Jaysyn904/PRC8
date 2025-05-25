//////////////////////////////////////////////////
// Earthstrike Quake
// tob_stdr_erthstq.nss
// Tenjac  9/11/07
//////////////////////////////////////////////////
/** @file Earthstrike Quake
Stone Dragon (Strike)
Level: Crusader 8, swordsage 8, warblade 8
Prerequisite: Two Stone Dragon maneuvers
Initiation Action: 1 standard action
Range: 20ft
Area: 20 ft radius burst, centered on you
Duration: Instantaneous
Saving Throw: Reflex negates

You swind your weapon in a wild arc, slamming it into the ground at your feet. Energy
surges out from you, causing the ground to shudder with a sharp tremor.

You channel ki into the earth with your mighty strike, causing the ground to rumble
and shake briefly. Anyone standing on the ground in this maneuver's area must make
a successful Reflex save (DC 18 + your Str modifier) or be knocked prone. Any creature
 in this area that is currently casting a spell must succeed on a Concentration check 
 (DC 20 + spell level) or lose the spell.

You are immune to the effect of the earthstrike quake maneuver. Your allies must still
save as normal against its effect.

Walls and similar barriers don't block the line of effect of an earth-strike quake.

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
                //Animation
                PlayAnimation(ANIMATION_FIREFORGET_VICTORY1);
                                                        
                location lLoc = GetLocation(oInitiator);
                int nDC = 18 + (GetAbilityModifier(ABILITY_STRENGTH, oInitiator));
				
				int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));;
				if (nBladeMed)
				{
					nDC += 1;
				}				
                
                //Shaking
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), lLoc);
                
                object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
                
                while(GetIsObjectValid(oTarget))
                {                                                
                        if(oTarget != oInitiator)
                        {
                                if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE, oInitiator, 1.0))
                                {
                                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, RoundsToSeconds(1));
                                }
                        }
                        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
                }
        }
}
                                        
                
                