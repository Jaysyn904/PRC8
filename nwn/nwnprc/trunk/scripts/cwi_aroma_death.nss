//::///////////////////////////////////////////////  
//:: Aroma of Curdled Death:  
//:: FileName: cwi_aroma_death.nss  
//::///////////////////////////////////////////////
//::
/*
AROMA OF CURDLED DEATH
Price (Item Level): 4,500 gp (9th)
Body Slot: —
Caster Level: 9th
Aura: Moderate; (DC 19) conjuration
Activation: Standard (manipulation)
Weight: —

This elegant, stoppered glass bottle holds a dark,
viscous fluid.

One round after you apply this elixir to
your skin, it creates an invisible cloud of
gas in a 10-foot radius that moves with you
and persists for 1 minute. You are immune
to the cloud’s effects, but every other
creature in the area that has 3 Hit Dice or
fewer immediately dies (no save). A creature that 
has 4–6 Hit Dice must succeed on a DC 17 Fortitude 
save each round it remains in the area or die. A 
creature that has 7 Hit Dice or more takes 1d4 
points of Constitution damage (Fort DC 17 half)
per round of exposure.

 
Prerequisites: Craft Wondrous Item, cloudkill, 
Craft (alchemy) 4 ranks.

Cost to Create: 2,250 gp, 180 XP, 5 days

*/
//::
//::///////////////////////////////////////////////  
#include "prc_inc_spells"

void main()    
{    
    object oUser = GetItemActivator(); 
    object oItem = GetItemActivated();    
    location lTarget = GetItemActivatedTargetLocation();    
    object oTarget = GetItemActivatedTarget();

    if (GetHasSpellEffect(SPELL_AROMA_OF_CURDLED_DEATH, OBJECT_SELF))
        PRCRemoveSpellEffects(SPELL_AROMA_OF_CURDLED_DEATH, OBJECT_SELF, OBJECT_SELF);	
     
	SendMessageToPC (oUser, "Applying elixir to skin...");  
	  
	// Applied to skin - mobile 10ft cloud 
	effect eDur = EffectVisualEffect(VFX_DUR_AURA_GREEN_DARK);
	effect eAoE = EffectAreaOfEffect(185, "curdled_death_a", "curdled_death_c", "");
	eAoE = EffectLinkEffects(eDur, eAoE);
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_NATURE), OBJECT_SELF); 		
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAoE, OBJECT_SELF, 60.0f);       
   
}

/* void main()  
{  
    object oCaster = OBJECT_SELF;  
    location lTarget = PRCGetSpellTargetLocation();  
    object oTarget = PRCGetSpellTargetObject();  
      
    // Execute the elixir effect with proper spell context  
    ExecuteScript("curdled_death_x", oTarget);
}  */
/* void main()  
{  
    object oUser = GetItemActivator();  
    object oItem = GetItemActivated();  
    location lTarget = GetItemActivatedTargetLocation();  
    object oTarget = GetItemActivatedTarget();  
      
    // Check usage mode  
    if(oTarget == oUser)  
    {  
        // Applied to skin - mobile 10ft cloud  
        effect eAOE = EffectAreaOfEffect(185, "curdled_death_a", "curdled_death_c", "");  
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oUser, RoundsToSeconds(60));  
          
        // Delayed activation (1 round)  
        DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT,   
            EffectVisualEffect(VFX_IMP_PULSE_NATURE), oUser));  
    }  
    else  
    {  
        // Opened/poured - stationary 5ft cloud  
        effect eAOE = EffectAreaOfEffect(185, "curdled_death_a", "curdled_death_c", "");  
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(60));  
          
        // Visual effect  
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE), lTarget);  
    }  
       
} */