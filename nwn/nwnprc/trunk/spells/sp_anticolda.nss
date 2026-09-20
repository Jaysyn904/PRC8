//::///////////////////////////////////////////////  
//:: Name      Anticold Sphere - OnEnter  
//:: FileName  sp_anticoldA.nss  
//::///////////////////////////////////////////////  
#include "prc_inc_spells"  
#include "prc_inc_turning"  
  
void DoPush(object oTarget, object oCaster);  
  
void main()  
{  
    object oTarget = GetEnteringObject();  
    object oCaster = GetAreaOfEffectCreator();  
  
    if(!GetIsObjectValid(oTarget) || !GetIsObjectValid(oCaster)) return;  
    if(oTarget == oCaster) return;  
  
    // Hedge out creatures with the cold subtype  
    string sSubrace = GetStringLowerCase(GetSubRace(oTarget));  
    if(GetIsColdCreature(oTarget, GetAppearanceType(oTarget))  
    || FindSubString(sSubrace, "cold") != -1)  
    {  
        FloatingTextStringOnCreature("You are hedged out by the anticold sphere!", oTarget, FALSE);  
        DoPush(oTarget, oCaster);  
        return;  
    }  
  
	// Grant cold immunity, tagged uniquely per-caster so it can be stripped OnExit  
	string sTag = "ANTICOLD_SPHERE_" + ObjectToString(oCaster);  
	  
	effect eImmune = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100);  
	effect eVis    = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);  
	effect eLink   = EffectLinkEffects(eImmune, eVis);  
	eLink = TagEffect(eLink, sTag);  
	  
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget); 
}

 
void DoPush(object oTarget, object oCaster)  
{  
    // Calculate how far the creature gets pushed back out of the sphere  
    float fDistance = FeetToMeters(11.0f);  
    location lTrueSpeaker  = GetLocation(oCaster);  
    location lTargetOrigin = GetLocation(oTarget);  
    vector vAngle        = AngleToVector(GetRelativeAngleBetweenLocations(lTrueSpeaker, lTargetOrigin));  
    vector vTargetOrigin = GetPosition(oTarget);  
    vector vTarget       = vTargetOrigin + (vAngle * fDistance);  
  
    if(!LineOfSightVector(vTargetOrigin, vTarget))  
    {  
        // Hit a wall, binary search for the wall  
        float fEpsilon    = 1.0f;  
        float fLowerBound = 0.0f;  
        float fUpperBound = fDistance;  
        fDistance         = fDistance / 2;  
  
        do  
        {  
            vTarget = vTargetOrigin + (vAngle * fDistance);  
            if(LineOfSightVector(vTargetOrigin, vTarget))  
                fLowerBound = fDistance;  
            else  
                fUpperBound = fDistance;  
            fDistance = fLowerBound + (fUpperBound - fLowerBound) / 2;  
        }  
        while(fUpperBound - fLowerBound > fEpsilon);  
    }  
  
    AssignCommand(oTarget, ClearAllActions());  
    AssignCommand(oTarget, ActionJumpToLocation(Location(GetArea(oTarget), vTarget, 0.0f)));  
}