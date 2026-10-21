//::////////////////////////////////////////////////////////
//::
/*	
	Reverse Gravity (sp_revgravity.nss)
	Transmutation
	Level: 				Drd 8, Sor/Wiz 7
	Components: 		V, S, M/DF
	Casting time: 		1 action
	Range: 				Medium (100 ft. + 10 ft./level)
	Area: 				Up to one 10-ft. cube/2 levels (S)
	Duration: 			1 round/level (D)
	Saving Throw: 		None (see text)
	Spell Resistance: 	No
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 

	This spell reverses gravity in the spell's area, causing 
	all unattached objects and creatures within it to fall 
	upward and reach the top of the area in 1 round. If some 
	solid object is encountered in this fall, falling objects 
	and creatures strike it in the same manner as they would 
	during a normal downward fall. If an object or creature 
	reaches the top of the area without striking anything, it
	remains there, oscillating slightly, until the spell ends.
	At the end of the spell duration, affected objects and 
	creatures fall downward.

	Provided theres something for them to hold onto, creatures 
	caught in the area can attempt Reflex saves to secure 
	themselves when the spell strikes. Creatures who can fly
	or levitate can keep themselves from falling. 
	
   PnP notes:  
 - Victims "fall" up to the top of the area and hover  
   until the spell ends, then fall and take damage.  
 - Reflex save lets a creature grab onto something —  
   NWN can't detect grabbable terrain, so the save is  
   allowed for everyone (DM adjudication note).  
 - Flying/levitating creatures are exempt. 
	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-07 23:13:57
//::
//:://////////////////////////////////////////////////////// 
#include "prc_inc_spells"  
#include "prc_inc_skills"
#include "prc_add_spell_dc"
  
const float RG_LIFT_HEIGHT = 9.0;    // ~30 ft up  
const float RG_FALL_DMG    = 20.0;   // terminal-ish: 20d6 cap later  
  
// Called by the delayed-drop and the heartbeat re-loop.  
void RG_DropVictim(object oTarget, int nCasterLevel)  
{  
    if (!GetIsObjectValid(oTarget)) return;  
    // restore visual transform to ground  
    SetObjectVisualTransform(oTarget,  
        OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z, 0.0,  
        OBJECT_VISUAL_TRANSFORM_LERP_LINEAR, 3.0, 30);  
    DeleteLocalInt(oTarget, "PRC_REVGRAV_LIFTED");  
    DeleteLocalInt(oTarget, "PRC_REVGRAV_EXPIRY");  
  
    // falling damage: 1d6 per 10 ft, cap 20d6 (PnP fall rules)  
    int nDam = d6(PRCMin(nCasterLevel, 20));  
    ApplyEffectToObject(DURATION_TYPE_INSTANT,  
        PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_FALLING), oTarget);  
    ApplyEffectToObject(DURATION_TYPE_INSTANT,  
        EffectVisualEffect(VFX_IMP_DUST_EXPLOSION), oTarget);  
}  
  
// Keep them pinned aloft; gently oscillate via tiny lerp nudges.  
void RG_Heartbeat(object oTarget)  
{  
    if (!GetIsObjectValid(oTarget)) return;  
    if (!GetLocalInt(oTarget, "PRC_REVGRAV_LIFTED")) return;  
  
    int nExpiry = GetLocalInt(oTarget, "PRC_REVGRAV_EXPIRY");  
    if (GetTimeSecond() >= nExpiry) return; // drop handler does the rest  
  
    // small sinusoidal bob: alternate +0.15 / -0.15 around lift height  
    float fZ = RG_LIFT_HEIGHT  
        + (GetLocalInt(oTarget, "PRC_REVGRAV_BOB") ? -0.15 : 0.15);  
    SetLocalInt(oTarget, "PRC_REVGRAV_BOB",  
        !GetLocalInt(oTarget, "PRC_REVGRAV_BOB"));  
    SetObjectVisualTransform(oTarget,  
        OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z, fZ,  
        OBJECT_VISUAL_TRANSFORM_LERP_SMOOTHSTEP, 1.0, 1);  
  
    DelayCommand(0.5, RG_Heartbeat(oTarget));  
}  
  
void main()  
{  
    object oCaster = OBJECT_SELF;  
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);  
  
    if (!X2PreSpellCastCode())  
    {  
        PRCSetSchool();  
        return;  
    }  
  
    int nCasterLevel  = PRCGetCasterLevel(oCaster);  
    int nMetaMagic    = PRCGetMetaMagicFeat();  
    location lTarget  = PRCGetSpellTargetLocation();  
    int nSpellId      = PRCGetSpellId();  
  
    // 1 round/level, extendable  
    int nRounds = nCasterLevel;  
    if (nMetaMagic & METAMAGIC_EXTEND) nRounds *= 2;  
    float fDur = RoundsToSeconds(nRounds);  
    int nExpiry = GetTimeSecond() + nRounds * 6;  
   
    float fRadius = 3.05 + (nCasterLevel / 6) * 1.5;  
    if (fRadius > RADIUS_SIZE_HUGE) fRadius = RADIUS_SIZE_HUGE;  
  
    // Zone VFX — churning reversed-gravity field  
    effect eAOE = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);  
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAOE, lTarget);  
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,  
        EffectVisualEffect(VFX_FNF_STORM), lTarget);  
    // lingering ground-marking glow for the zone duration  
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,  
        EffectVisualEffect(VFX_DUR_GLOW_LIGHT_BLUE), lTarget, fDur);  
  
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius,  
        lTarget, TRUE, OBJECT_TYPE_CREATURE);  
    while (GetIsObjectValid(oTarget))  
    {  
        if (oTarget != oCaster &&  
            spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) &&  
            !PRCIsFlying(oTarget) &&  
            !GetLocalInt(oTarget, "PRC_REVGRAV_LIFTED"))  
        {  
            PRCSignalSpellEvent(oTarget, TRUE, nSpellId, oCaster);  
            float fDelay = PRCGetRandomDelay(0.2, 0.8);  
  
            // Reflex to grab onto something — PnP lets them try  
            // "provided there's something to hold onto"; we always  
            // allow it since NWN can't detect handholds.  
            int nDC = PRCGetSaveDC(oTarget, oCaster);  
            if (!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC))  
            {  
                // Launch upward — 1-round rise per PnP  
                SetLocalInt(oTarget, "PRC_REVGRAV_LIFTED", TRUE);  
                SetLocalInt(oTarget, "PRC_REVGRAV_EXPIRY", nExpiry);  
                SetObjectVisualTransform(oTarget,  
                    OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z, RG_LIFT_HEIGHT,  
                    OBJECT_VISUAL_TRANSFORM_LERP_LINEAR, 6.0, 6);  
                // some spin for flavor  
                SetObjectVisualTransform(oTarget,  
                    OBJECT_VISUAL_TRANSFORM_ROTATE_Z, 15.0);  
  
                // stunned in place while aloft — "oscillating  
                // slightly" and can't act meaningfully  
                effect eHold = EffectLinkEffects(  
                    EffectCutsceneParalyze(),  
                    EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT));  
                DelayCommand(fDelay, SPApplyEffectToObject(  
                    DURATION_TYPE_TEMPORARY, eHold, oTarget,  
                    fDur, TRUE, nSpellId, nCasterLevel, oCaster));  
  
                // bob them until expiry  
                DelayCommand(6.0, RG_Heartbeat(oTarget));  
  
                // when the spell ends, they fall and take damage  
                DelayCommand(fDur, RG_DropVictim(oTarget, nCasterLevel));  
            }  
            else  
            {  
                // grabbed a handhold — a little shake only  
                DelayCommand(fDelay, SPApplyEffectToObject(  
                    DURATION_TYPE_INSTANT,  
                    EffectVisualEffect(VFX_COM_HIT_SONIC), oTarget));  
            }  
        }  
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius,  
            lTarget, TRUE, OBJECT_TYPE_CREATURE);  
    }  
  
    PRCSetSchool();  
}