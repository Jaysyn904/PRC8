#include "prc_sp_func"  
#include "prc_add_spell_dc"  
#include "prc_effect_inc" 
#include "prc_inc_size" 

void DispelMonitor(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining)    
{    
    if((--nBeatsRemaining == 0) ||    
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster)    
       )    
    {    
        if(DEBUG) DoDebug("sp_enred: Spell expired, clearing");    
            
        // Clear the marker variables FIRST    
        DeleteLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease");    
        DeleteLocalInt(oTarget, "PRC_Power_Compression_SizeReduction");    
            
        // Remove any size effects with the new tags    
        effect eEffect = GetFirstEffect(oTarget);    
        while (GetIsEffectValid(eEffect))    
        {    
            string sTag = GetEffectTag(eEffect);    
            if (sTag == "PRC_SIZE_INCREASE" || sTag == "PRC_SIZE_DECREASE")    
            {    
                RemoveEffect(oTarget, eEffect);    
            }    
            eEffect = GetNextEffect(oTarget);    
        }    
            
        // Reset to ORIGINAL scale, not 1.0f    
        float fOriginalSize = GetLocalFloat(oTarget, "PRC_ORIGINAL_SIZE");    
        if(fOriginalSize == 0.0f) fOriginalSize = 1.0f; // fallback    
        SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE, fOriginalSize);    
            
        // DON'T delete PRC_ORIGINAL_SIZE here - keep it for future casts    
            
        // Remove remaining spell effects    
        PRCRemoveEffectsFromSpell(oTarget, nSpellID);    
            
        // Size has changed, evaluate PrC feats again    
        EvalPRCFeats(oTarget);    
    }    
    else    
        DelayCommand(1.0f, DispelMonitor(oCaster, oTarget, nSpellID, nBeatsRemaining));    
}    
    
void main()    
{    
    //Declare main variables.    
    int nEvent = GetRunningEvent();    
    object oCaster;    
    switch(nEvent)    
    {    
        case EVENT_ONPLAYERREST_FINISHED:    oCaster = GetLastBeingRested();    break;    
    
        default:    
            oCaster = OBJECT_SELF;    
    }    
    
    if(nEvent == FALSE)    
    {            
        int nCasterLevel = PRCGetCasterLevel(oCaster);    
        int nSpellID = PRCGetSpellId();    
        PRCSetSchool(GetSpellSchool(nSpellID));    
        if (!X2PreSpellCastCode()) return;    
        object oTarget = PRCGetSpellTargetObject();    
        int nMetaMagic = PRCGetMetaMagicFeat();    
        int nSaveDC = PRCGetSaveDC(oTarget, oCaster);    
        int nPenetr = nCasterLevel + SPGetPenetr();    
        float fDuration = 60.0 * nCasterLevel; //modify if necessary    
        if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;    
    
        int bMass = ((nSpellID == SPELL_ENLARGE_PERSON_MASS) ||    
                        (nSpellID == SPELL_REDUCE_PERSON_MASS));    
                            
        int bEnlarge = ((nSpellID == SPELL_ENLARGE_PERSON) ||    
                        (nSpellID == SPELL_ENLARGE_PERSON_MASS));    
    
        AddEventScript(oTarget, EVENT_ONPLAYERREST_FINISHED, "sp_enred", TRUE, FALSE);    
    
        if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;    
        location lTarget;    
        if(bMass)    
        {    
            lTarget = PRCGetSpellTargetLocation();    
            oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);    
        }    
        while(GetIsObjectValid(oTarget))    
        {    
            if (PRCAmIAHumanoid(oTarget))    
            {    
                if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))  //:: Allied Branch  
                {    
                    if(bEnlarge)    
                    {    
                        if(GetLocalInt(oTarget, "PRC_Power_Compression_SizeReduction"))    
                        {    
                            // Remove opposing size effect    
                            effect eEffect = GetFirstEffect(oTarget);    
                            while (GetIsEffectValid(eEffect))    
                            {    
                                string sTag = GetEffectTag(eEffect);    
								if (sTag == "PRC_SIZE_DECREASE")    
								{    
									RemoveEffect(oTarget, eEffect);    
									effect eReset = EffectSizeChange(oTarget, OBJECT_TYPE_CREATURE, TRUE, 0);    
									SPApplyEffectToObject(DURATION_TYPE_INSTANT, eReset, oTarget);    
									DeleteLocalInt(oTarget, "PRC_Power_Compression_SizeReduction");    
									DispelMonitor(oCaster, oTarget, nSpellID, 0); // 0 beats for immediate cleanup    
								}  
                                eEffect = GetNextEffect(oTarget);                            
                            }    
                        }    
                        else if(GetLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease"))    
                        {    
                            FloatingTextStringOnCreature("This creature's size cannot be increased further.", oTarget);    
                        }                        
                        else    
                        {    
							SetLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease", 1);    
							effect eSize = EffectSizeChange(oTarget, OBJECT_TYPE_CREATURE, TRUE, 1);    
							SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSize, oTarget, fDuration, TRUE, nSpellID, nCasterLevel);    
							DelayCommand(1.0f, DispelMonitor(oCaster, oTarget, nSpellID, FloatToInt(fDuration) / 6));    
                        }    
                    }    
                    else  // Reduce    
                    {    
                        if(GetLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease"))    
                        {    
                            // Remove opposing size effect    
                            effect eEffect = GetFirstEffect(oTarget);    
                            while (GetIsEffectValid(eEffect))    
                            {    
                                string sTag = GetEffectTag(eEffect);    
								if (sTag == "PRC_SIZE_INCREASE")    
								{    
									RemoveEffect(oTarget, eEffect);    
									effect eReset = EffectSizeChange(oTarget, OBJECT_TYPE_CREATURE, TRUE, 0);    
									SPApplyEffectToObject(DURATION_TYPE_INSTANT, eReset, oTarget);    
									DeleteLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease");    
									DispelMonitor(oCaster, oTarget, nSpellID, 0);    
								}   
                                eEffect = GetNextEffect(oTarget);                            
                            }    
                        }    
                        else if(GetLocalInt(oTarget, "PRC_Power_Compression_SizeReduction"))    
                        {    
                            FloatingTextStringOnCreature("This creature's size cannot be decreased further.", oTarget);    
                        }                        
                        else                            
                        {    
							SetLocalInt(oTarget, "PRC_Power_Compression_SizeReduction", 1);    
							effect eSize = EffectSizeChange(oTarget, OBJECT_TYPE_CREATURE, FALSE, 1);    
							SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSize, oTarget, fDuration, TRUE, nSpellID, nCasterLevel);    
							DelayCommand(1.0f, DispelMonitor(oCaster, oTarget, nSpellID, FloatToInt(fDuration) / 6));   
                        }                            
                    }    
                }    
                else if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC))    
                {    
                    // Same logic as above for hostile targets    
                    if(bEnlarge)    
                    {    
                        if(GetLocalInt(oTarget, "PRC_Power_Compression_SizeReduction"))    
                        {    
                            // Remove opposing size effect (same as above)    
                            effect eEffect = GetFirstEffect(oTarget);    
                            while (GetIsEffectValid(eEffect))    
                            {    
                                string sTag = GetEffectTag(eEffect);    
								if (sTag == "PRC_SIZE_DECREASE")    
								{    
									RemoveEffect(oTarget, eEffect);    
									effect eReset = EffectSizeChange(oTarget, OBJECT_TYPE_CREATURE, TRUE, 0);    
									SPApplyEffectToObject(DURATION_TYPE_INSTANT, eReset, oTarget);    
									DeleteLocalInt(oTarget, "PRC_Power_Compression_SizeReduction");    
									DispelMonitor(oCaster, oTarget, nSpellID, 0);    
								}  
                                eEffect = GetNextEffect(oTarget);                            
                            }    
                        }    
                        else if(GetLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease"))    
                        {    
                            FloatingTextStringOnCreature("This creature's size cannot be increased further.", oTarget);                            
                        }    
                        else    
                        {        
							SetLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease", 1);    
							effect eSize = EffectSizeChange(oTarget, OBJECT_TYPE_CREATURE, TRUE, 1);    
							SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSize, oTarget, fDuration, TRUE, nSpellID, nCasterLevel);    
							DelayCommand(1.0f, DispelMonitor(oCaster, oTarget, nSpellID, FloatToInt(fDuration) / 6));   
                        }    
                    }    
                    else    // Reduce                
                    {    
                        if(GetLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease"))    
                        {    
                            // Remove opposing size effect (same as above)    
                            effect eEffect = GetFirstEffect(oTarget);    
                            while (GetIsEffectValid(eEffect))    
                            {    
                                string sTag = GetEffectTag(eEffect);    
								if (sTag == "PRC_SIZE_INCREASE")    
								{    
									RemoveEffect(oTarget, eEffect);    
									effect eReset = EffectSizeChange(oTarget, OBJECT_TYPE_CREATURE, TRUE, 0);    
									SPApplyEffectToObject(DURATION_TYPE_INSTANT, eReset, oTarget);    
									DeleteLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease");    
									DispelMonitor(oCaster, oTarget, nSpellID, 0);    
								}  
                                eEffect = GetNextEffect(oTarget);                            
                            }    
                        }    
                        else if(GetLocalInt(oTarget, "PRC_Power_Compression_SizeReduction"))    
                        {    
                            FloatingTextStringOnCreature("This creature's size cannot be reduced further.", oTarget);                            
                        }                            
                        else                            
                        {    
							SetLocalInt(oTarget, "PRC_Power_Compression_SizeReduction", 1);    
							effect eSize = EffectSizeChange(oTarget, OBJECT_TYPE_CREATURE, FALSE, 1);    
							SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSize, oTarget, fDuration, TRUE, nSpellID, nCasterLevel);    
							DelayCommand(1.0f, DispelMonitor(oCaster, oTarget, nSpellID, FloatToInt(fDuration) / 6));  
                        }            
                    }                            
                }    
            }        
            if(!bMass) break;    
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);    
        }    
            
        EvalPRCFeats(oTarget);    
            
    }    
	else if(nEvent == EVENT_ONPLAYERREST_FINISHED)    
	{    
		// Reset size on rest - this is where we fully clean up    
		float fOriginalSize = GetLocalFloat(oCaster, "PRC_ORIGINAL_SIZE");    
		if(fOriginalSize == 0.0f) fOriginalSize = 1.0f;    
		SetObjectVisualTransform(oCaster, OBJECT_VISUAL_TRANSFORM_SCALE, fOriginalSize);    
		    
		// Clear ALL size state variables including original size    
		DeleteLocalInt(oCaster, "PRC_Power_Expansion_SizeIncrease");    
		DeleteLocalInt(oCaster, "PRC_Power_Compression_SizeReduction");    
		DeleteLocalFloat(oCaster, "PRC_ORIGINAL_SIZE");    
	} 	  
    
    PRCSetSchool();    
}