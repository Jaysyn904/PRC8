#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void main()
{
    int nEvent        = GetRunningEvent();
    object oInitiator = OBJECT_SELF;

    if(nEvent == FALSE)
    {
        if (!PreManeuverCastCode())
        {
            // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
            return;
        }

        // End of Spell Cast Hook

        object oTarget      = PRCGetSpellTargetObject();
        struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

        if(move.bCanManeuver)
        {
            AddEventScript(oInitiator, EVENT_ONHEARTBEAT, "tob_ssn_childsl", TRUE, FALSE);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL), oInitiator);
            SetLocalInt(oInitiator, "SSN_CHILDSL_SETP", 1);
            //, 0.0f, FALSE, 19313);
        }
    }
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), GetLocation(oInitiator));
        effect eLink, eVis;

        if(GetLocalInt(oInitiator, "SSN_CHILDSL_SETP") == 1)
        {// We dazzle this round
            eLink = EffectDazzle();
            eLink = SupernaturalEffect(eLink);
            eVis  = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

            // Loop through targets
            while(GetIsObjectValid(oTarget))
            {
                if(GetIsEnemy(oTarget))
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
                    // Let them know they've been hit by dazzle
                    //SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, -1/*INSERT SPELL HERE*/));
                }
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), GetLocation(oInitiator));
            }
            // Give oInitiator a little graphic
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oInitiator);
            SetLocalInt(oInitiator, "SSN_CHILDSL_SETP", 2);
            effect eEffect  = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_IOUNSTONE_BLUE));
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oInitiator, 6.0);
        }
        else if(GetLocalInt(oInitiator, "SSN_CHILDSL_SETP") == 2)
        {// The Darkness

            eLink = EffectDarkness();
            eLink = SupernaturalEffect(eLink);
            eVis  = EffectVisualEffect(VFX_DUR_DARKNESS);

            while(GetIsObjectValid(oTarget))
            {// Applies to everyone
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
				
				int iShadow = GetLevelByClass(CLASS_TYPE_SHADOWLORD, oTarget);  
  
				if (iShadow)    
				{      
					eLink = ShadowlordEffects(iShadow, eLink);  
					eLink = TagEffect(eLink, "SHADOWSIGHT+BLUR");  
				}  

                oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), GetLocation(oInitiator));
            }
            // Give oInitiator a little graphic
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oInitiator);
            SetLocalInt(oInitiator, "SSN_CHILDSL_SETP", 1);
            effect eEffect  = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_IOUNSTONE_BLUE));
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oInitiator, 6.0);
        }
    }
}
