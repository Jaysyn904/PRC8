//::///////////////////////////////////////////////
//:: Exhaled Barrier: On Enter
//:: prc_wallbreatha.nss
//:://////////////////////////////////////////////
/*
    Person within the AoE take breath damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
//:: Modified for Exhaled Barrier by Fox on Jan 23, 2008
#include "prc_inc_spells"

void main()
{

    //Declare major variables
    int nDamage = 0;
    effect eDam;
    object oTarget;
    int nSaveDamageType;
    int nVisualType;
    object oDragon = GetAreaOfEffectCreator();
    int nDamageType = GetLocalInt(oDragon, "BarrierDamageType");
    int nDiceType = GetLocalInt(oDragon, "BarrierDiceType");
    int nDiceNumber = GetLocalInt(oDragon, "BarrierDiceNumber");
    int nSaveDC = 10 + GetHitDice(oDragon) / 2 + PRCMax(GetAbilityModifier(ABILITY_CONSTITUTION, oDragon), 0);
    //Declare and assign personal impact visual effect.
    switch(nDamageType)
    {
    	case DAMAGE_TYPE_ACID:
    	     nSaveDamageType = SAVING_THROW_TYPE_ACID;
    	     nVisualType = VFX_IMP_ACID_S; break;
    	
    	case DAMAGE_TYPE_COLD:
    	     nSaveDamageType = SAVING_THROW_TYPE_COLD;
    	     nVisualType = VFX_IMP_FROST_S; break;
    	
    	case DAMAGE_TYPE_ELECTRICAL:
    	     nSaveDamageType = SAVING_THROW_TYPE_ELECTRICITY;
    	     nVisualType = VFX_IMP_LIGHTNING_S; break;
    	
    	case DAMAGE_TYPE_FIRE:
    	     nSaveDamageType = SAVING_THROW_TYPE_FIRE;
    	     nVisualType = VFX_IMP_FLAME_M; break;
    	
    	case DAMAGE_TYPE_NEGATIVE:
    	     nSaveDamageType = SAVING_THROW_TYPE_NEGATIVE;
    	     nVisualType = VFX_IMP_NEGATIVE_ENERGY; break;
    	     
    	case DAMAGE_TYPE_POSITIVE:
    	     nSaveDamageType = SAVING_THROW_TYPE_POSITIVE;
    	     nVisualType = VFX_IMP_HOLY_AID; break;
    	
    	case DAMAGE_TYPE_SONIC:
    	     nSaveDamageType = SAVING_THROW_TYPE_SONIC;
    	     nVisualType = VFX_IMP_SILENCE; break;
    }
    effect eVis = EffectVisualEffect(nVisualType);

    //Capture the first target object in the shape.
    oTarget = GetEnteringObject();
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oDragon))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        
        //Roll damage.
        switch(nDiceType)
        {
    	    case 4: 
    	        nDamage = d4(nDiceNumber); break;
    	    case 6: 
    	        nDamage = d6(nDiceNumber); break;
    	    case 8: 
    	        nDamage = d8(nDiceNumber); break;
    	    case 10: 
    	        nDamage = d10(nDiceNumber); break;
        }
        nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nSaveDC, nSaveDamageType);
        if(nDamage > 0)
        {
            // Apply effects to the currently selected target.
            eDam = EffectDamage(nDamage, nDamageType);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }

}
