/*
15/02/19 by Stratovarius

Curtain of Shadows

Initiate, Veil of Shadows 
Level/School: 5th/Transmutation 
Range: Close (25 ft. + 5 ft./2 levels) 
Effect: Shadowy wall 
Duration: 1 minute/level 
Saving Throw: None 
Spell Resistance: No

You create a wall of frigid shadow that wracks all who pass through it with cold.

You create a wall of shadow. Any creature passing through the wall takes 1d6 points of cold damage per caster level (maximum 15d6).
*/

#include "shd_inc_shdfunc"

void main()
{
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    //Declare major variables
    object oShadow = GetAreaOfEffectCreator();
    struct mystery myst = GetLocalMystery(oShadow, MYST_HOLD_MYST+"6"); 

    if (myst.nMystId == MYST_FEARFUL_GLOOM)
    {
    	//Capture the first target object in the shape.
    	object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    	while(GetIsObjectValid(oTarget))
    	{    
    	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oShadow))
    	    {
    			if (GetHitDice(oTarget) > 4)
    			{
        		    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget,myst.nSaveDC, SAVING_THROW_TYPE_FEAR))
        		    {
        		        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFrightened(), oTarget, RoundsToSeconds(d6(2)), TRUE, myst.nMystId, myst.nShadowcasterLevel);
        		    }
        		    else 
        		    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oTarget, RoundsToSeconds(1), TRUE, myst.nMystId, myst.nShadowcasterLevel);
        		} 
        		else 
        			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFrightened(), oTarget, RoundsToSeconds(d6(2)), TRUE, myst.nMystId, myst.nShadowcasterLevel);
    	    }
    	    //Select the next target within the spell shape.
    	    oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    	} 
    }  
    if (myst.nMystId == MYST_SICKENING_SHADOW)
    {
    	//Capture the first target object in the shape.
    	object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    	while(GetIsObjectValid(oTarget))
    	{    
    	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oShadow))
    	    {
        		if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, myst.nSaveDC, SAVING_THROW_TYPE_SPELL))
        		{
        			float fDur = RoundsToSeconds(d4(1));
        		    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNausea(oTarget, fDur), oTarget, fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);
        		    DelayCommand(fDur, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSickened(), oTarget, RoundsToSeconds(d6(2)), TRUE, myst.nMystId, myst.nShadowcasterLevel));
        		}
        		else 
        			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSickened(), oTarget, RoundsToSeconds(d6(2)), TRUE, myst.nMystId, myst.nShadowcasterLevel);
    	    }
    	    //Select the next target within the spell shape.
    	    oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    	} 
    }    
}
