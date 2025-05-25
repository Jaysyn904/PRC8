/*
   ----------------
   White Raven Tactics

   tob_wtrn_whtrvnt.nss
   ----------------

    18/08/07 by Stratovarius
*/ /** @file

    White Raven Tactics

    White Raven (Boost)
    Level: Crusader 3, Warblade 3
    Initiation Action: 1 Swift Action
    Range: 10 ft.
    Target: One ally

    You can inspire your allies to astounding feats of martial prowess
    With a few short orders, you cajole them into seizing the initiative
    and driving back the enemy.
    
    Your ally gets to go again this turn. You cannot target yourself with this maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

//inc_vfx_const

// Needed for applying time stop effects directly to Initator & Target when PRC_TIMESTOP_LOCAL flag is set
//#include "inc_timestop"

void main()
{
    if(!PreManeuverCastCode()) return;

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();

    if(oInitiator == oTarget)
    {
        FloatingTextStringOnCreature("White Raven Tactics may not be used on yourself.", oInitiator, FALSE);    
        return;
    }

    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);
    float fDuration = RoundsToSeconds(1); // One Combat Round

    if(move.bCanManeuver)
    {
        effect eTime;

        // Create visual effect for the target
        effect eVisTarget = EffectVisualEffect(PSI_DUR_TEMPORAL_ACCELERATION);

        // Apply impact VFX (Impact must be done before global Timestop effect, or impact is frozen too)
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HASTE), oTarget);

        // PRC_TIMESTOP_LOCAL (VFX_PER_NEW_TIMESTOP) alwasy applies its effects to all creatures except the *caster* (oInitiator),
        // and the target passed into it via a local on the caster, so we need to manually freeze the Initiator and set the Target.
        if(GetPRCSwitch(PRC_TIMESTOP_LOCAL))
        {
            //Create extraordinary Time Stop effect
            eTime = ExtraordinaryEffect(EffectAreaOfEffect(VFX_PER_NEW_TIMESTOP));

            // Link Ethereal and the duration visuals
            eVisTarget = EffectLinkEffects(eVisTarget, EffectEthereal());

            // Set a local object on the creator/Initator  to make the Target exempt from the time stop effect
            SetLocalObject(oInitiator, "PRC_WRT_TARGET", oTarget);

            // Directly apply a temporary freeze to the Initator
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION), EffectCutsceneParalyze()), oInitiator, fDuration);
            SetCommandable(FALSE, oInitiator); // If this does not prevent move recovery during the time stop round, then remove it
            DelayCommand(fDuration, SetCommandable(TRUE, oInitiator));
            // Not performing blank screen since, thematically, the effect is the Initator giving the Target orders, so teh initator shooudl be aware of what the target does
            // Blank screen and delayed Blank screen removal could be placed here

            // Apply area effect to initator instead of target, so it is not removed incorrectly
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTime, oInitiator, fDuration);

            // Apply visual & Ethereal effects to the target
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisTarget, oTarget, fDuration);

            // Apply the time stop impact VFX (Cannot be used with bioware time stop, since it freezes the VFX animation until the timestop is over)
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_TIME_STOP_DN_ORANGE), GetLocation(oInitiator));

            //AssignCommand(oTarget,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisTarget, oTarget, fDuration));

            // Clean up
            DelayCommand(fDuration, DeleteLocalObject(oInitiator, "PRC_WRT_TARGET"));
        }
        else
        {
            //Create extraordinary Time Stop effect
            eTime = ExtraordinaryEffect(EffectTimeStop());

            // Link up the visual effects
            eTime = EffectLinkEffects(eTime, eVisTarget);
            // Apply effect directly to target
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTime, oTarget, fDuration);
        }
    }
}



/*
// recolored time stop VFX
const int VFX_IMP_TIME_STOP_DN_SOUNDFX          = 1049;
const int VFX_IMP_TIME_STOP_DN_RED              = 1050;
const int VFX_IMP_TIME_STOP_DN_ORANGE           = 1051;
const int VFX_IMP_TIME_STOP_DN_YELLOW           = 1052;
const int VFX_IMP_TIME_STOP_DN_GREEN            = 1053;
const int VFX_IMP_TIME_STOP_DN_BLUE             = 1054;
const int VFX_IMP_TIME_STOP_DN_PURPLE           = 1055;
const int VFX_IMP_TIME_STOP_DN_SILENT           = 1056;
*/