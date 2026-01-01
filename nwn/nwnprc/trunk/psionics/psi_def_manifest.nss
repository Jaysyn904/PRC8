//::///////////////////////////////////////////////  
//:: Defensive Manifestation 
//:: psi_def_manifest 
//::///////////////////////////////////////////////  
  
#include "prc_alterations"  
#include "prc_feat_const"  
#include "psi_inc_psifunc"  
  
void main()  
{  
    object oPC = OBJECT_SELF;  
      
    // Check if already active  
    int bActive = GetLocalInt(oPC, "PRC_DefensiveManifestActive");  
      
    if(!bActive)  
    {  
        // Activate defensive manifestation (no focus limit check needed)  
        SetLocalInt(oPC, "PRC_DefensiveManifestActive", TRUE);  
          
        // Apply temporary Epic Improved Combat Casting with unique tag  
        effect eBonusFeat = EffectBonusFeat(FEAT_EPIC_IMPROVED_COMBAT_CASTING);
		eBonusFeat = UnyieldingEffect(eBonusFeat);
        eBonusFeat = TagEffect(eBonusFeat, "DEFENSIVE_MANIFESTATION_BUFF");  
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonusFeat, oPC);  
          
        FloatingTextStringOnCreature("Defensive Manifestation Activated", oPC, FALSE);  
    }  
    else  
    {  
        // Deactivate defensive manifestation  
        DeleteLocalInt(oPC, "PRC_DefensiveManifestActive");  
          
        // Remove the bonus feat effect by tag  
        effect eTest = GetFirstEffect(oPC);  
        while(GetIsEffectValid(eTest))  
        {  
            if(GetEffectTag(eTest) == "DEFENSIVE_MANIFESTATION_BUFF")  
            {  
                RemoveEffect(oPC, eTest);  
                break;  
            }  
            eTest = GetNextEffect(oPC);  
        }  
          
        FloatingTextStringOnCreature("Defensive Manifestation Deactivated", oPC, FALSE);  
    }  
}