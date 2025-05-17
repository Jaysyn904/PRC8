/*
    sp_enred

    Enlarge Person

    Transmutation
    Level: Sor/Wiz 1, Strength 1
    Components: V, S, M
    Casting Time: 1 round
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One humanoid creature
    Duration: 1 min./level (D)
    Saving Throw: Fortitude negates
    Spell Resistance: Yes
    This spell causes instant growth of a humanoid creature, doubling its height and multiplying its weight by 8. This increase changes the creature’s size category to the next larger one. The target gains a +2 size bonus to Strength, a –2 size penalty to Dexterity (to a minimum of 1), and a –1 penalty on attack rolls and AC due to its increased size.
    A humanoid creature whose size increases to Large has a space of 10 feet and a natural reach of 10 feet. This spell does not change the target’s speed.
    If insufficient room is available for the desired growth, the creature attains the maximum possible size and may make a Strength check (using its increased Strength) to burst any enclosures in the process. If it fails, it is constrained without harm by the materials enclosing it— the spell cannot be used to crush a creature by increasing its size.
    All equipment worn or carried by a creature is similarly enlarged by the spell. Melee and projectile weapons affected by this spell deal more damage. Other magical properties are not affected by this spell. Any enlarged item that leaves an enlarged creature’s possession (including a projectile or thrown weapon) instantly returns to its normal size. This means that thrown weapons deal their normal damage, and projectiles deal damage based on the size of the weapon that fired them. Magical properties of enlarged items are not increased by this spell.
    Multiple magical effects that increase size do not stack,.
    Enlarge person counters and dispels reduce person.
    Enlarge person can be made permanent with a permanency spell.
    Material Component: A pinch of powdered iron.

    Enlarge Person, Mass

    Transmutation
    Level: Sor/Wiz 4
    Target: One humanoid creature/level, no two of which can be more than 30 ft. apart
    This spell functions like enlarge person, except that it affects multiple creatures.

    Reduce Person

    Transmutation
    Level: Sor/Wiz 1
    Components: V, S, M
    Casting Time: 1 round
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One humanoid creature
    Duration: 1 min./level (D)
    Saving Throw: Fortitude negates
    Spell Resistance: Yes
    This spell causes instant diminution of a humanoid creature, halving its height, length, and width and dividing its weight by 8. This decrease changes the creature’s size category to the next smaller one. The target gains a +2 size bonus to Dexterity, a –2 size penalty to Strength (to a minimum of 1), and a +1 bonus on attack rolls and AC due to its reduced size.
    A Small humanoid creature whose size decreases to Tiny has a space of 2-1/2 feet and a natural reach of 0 feet (meaning that it must enter an opponent’s square to attack). A Large humanoid creature whose size decreases to Medium has a space of 5 feet and a natural reach of 5 feet. This spell doesn’t change the target’s speed.
    All equipment worn or carried by a creature is similarly reduced by the spell.
    Melee and projectile weapons deal less damage. Other magical properties are not affected by this spell. Any reduced item that leaves the reduced creature’s possession (including a projectile or thrown weapon) instantly returns to its normal size. This means that thrown weapons deal their normal damage (projectiles deal damage based on the size of the weapon that fired them).
    Multiple magical effects that reduce size do not stack.
    Reduce person counters and dispels enlarge person.
    Reduce person can be made permanent with a permanency spell.
    Material Component: A pinch of powdered iron.

    Reduce Person, Mass

    Transmutation
    Level: Sor/Wiz 4
    Target: One humanoid creature/level, no two of which can be more than 30 ft. apart
    This spell functions like reduce person, except that it affects multiple creatures.

    By: Flaming_Sword
    Created: Sept 27, 2006
    Modified: Sept 27, 2006

    Copied from psionics
*/

#include "prc_sp_func"
#include "prc_inc_function"
#include "prc_add_spell_dc"

void ResetSize(object oTarget)
{
	SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE, 1.0f);
	
	// Remove opposing size effect
	effect eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect))
	{
		string sTag = GetEffectTag(eEffect);
		if(sTag == "ARCANE_SIZE_INCREASE")
		{
			RemoveEffect(oTarget, eEffect);
			DeleteLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease");
		}
		if (sTag == "ARCANE_SIZE_DECREASE")
		{
			RemoveEffect(oTarget, eEffect);
			DeleteLocalInt(oTarget, "PRC_Power_Compression_SizeReduction");
		}		
		eEffect = GetNextEffect(oTarget);
	}		
}

void DispelMonitor(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0)                                         ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster)
       )
    {
        if(DEBUG) DoDebug("sp_enred: Spell expired, clearing");

        // Clear the marker
        DeleteLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease");
        DeleteLocalInt(oTarget, "PRC_Power_Compression_SizeReduction");

		// Remove opposing size effect
		effect eEffect = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eEffect))
		{
			string sTag = GetEffectTag(eEffect);
			if ((sTag == "ARCANE_SIZE_DECREASE") ||
				(sTag == "ARCANE_SIZE_INCREASE"))
			{
				RemoveEffect(oTarget, eEffect);
			}
			eEffect = GetNextEffect(oTarget);
		}		

        // Size has changed, evaluate PrC feats again
        EvalPRCFeats(oTarget);
    }
    else
       DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, nSpellID, nBeatsRemaining));
}

void main()
{
        //Declare main variables.
    int nEvent = GetRunningEvent();
    object oCaster;
    switch(nEvent)
    {
		case EVENT_ONPLAYERREST_STARTED:	oCaster = GetLastBeingRested();	break;

        default:
            oCaster = OBJECT_SELF;
    }

	if(nEvent == EVENT_ONPLAYERREST_STARTED)
	{
		ResetSize(oCaster);
	}
	else if(nEvent == FALSE)
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
						
		effect eLink;
		eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SANCTUARY));
		eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
		if (bEnlarge)
		{
			eLink = EffectLinkEffects(eLink, EffectAttackDecrease(1));
			eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_DEXTERITY, 2));
			eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 2));
			eLink = EffectLinkEffects(eLink, EffectACDecrease(1));  
			eLink = TagEffect(eLink, "ARCANE_SIZE_INCREASE");
		}
		else
		{
			eLink = EffectLinkEffects(eLink, EffectAttackIncrease(1));
			eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_DEXTERITY, 2));
			eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_STRENGTH, 2));
			eLink = EffectLinkEffects(eLink, EffectACIncrease(1)); 
			eLink = TagEffect(eLink, "ARCANE_SIZE_DECREASE");			
		}

		int nRacial, bApply, bRace;
		
		AddEventScript(oTarget, EVENT_ONPLAYERREST_STARTED, "sp_enred", TRUE, FALSE);

		if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;
		location lTarget;
		if(bMass)
		{
			lTarget = PRCGetSpellTargetLocation();
			object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		}
		while(GetIsObjectValid(oTarget))
		{
			if (PRCAmIAHumanoid(oTarget))
			{
				if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
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
								if (sTag == "ARCANE_SIZE_DECREASE")
								{
									RemoveEffect(oTarget, eEffect);
									DelayCommand(0.0f, ResetSize(oTarget));
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
							SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, nSpellID, nCasterLevel);
							SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE, 1.5);
							DelayCommand(fDuration, ResetSize(oTarget));
						}
					}
					else
					{
						if(GetLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease"))
						{
						// Remove opposing size effect
							effect eEffect = GetFirstEffect(oTarget);
							while (GetIsEffectValid(eEffect))
							{
								string sTag = GetEffectTag(eEffect);
								if (sTag == "ARCANE_SIZE_INCREASE")
								{
									RemoveEffect(oTarget, eEffect);
									DelayCommand(0.0f, ResetSize(oTarget));
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
							SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, nSpellID, nCasterLevel);
							SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE, 0.5);
							DelayCommand(fDuration, ResetSize(oTarget));
						}					
							
						EvalPRCFeats(oTarget);
						DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, nSpellID, FloatToInt(fDuration) / 6));				
					}
				}
				else if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC))
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
								if (sTag == "ARCANE_SIZE_DECREASE")
								{
									RemoveEffect(oTarget, eEffect);
									DelayCommand(0.0f, ResetSize(oTarget));
								}
								eEffect = GetNextEffect(oTarget);						
							}
						}
						else	
						{
							SetLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease", 1);
							SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, nSpellID, nCasterLevel);
							SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE, 1.5);
							DelayCommand(fDuration, ResetSize(oTarget));
						}
					}
					else				
					{
						if(GetLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease"))
						{
						// Remove opposing size effect
							effect eEffect = GetFirstEffect(oTarget);
							while (GetIsEffectValid(eEffect))
							{
								string sTag = GetEffectTag(eEffect);
								if (sTag == "ARCANE_SIZE_INCREASE")
								{
									RemoveEffect(oTarget, eEffect);
									DelayCommand(0.0f, ResetSize(oTarget));
								}
								eEffect = GetNextEffect(oTarget);						
							}
						}
						else						
						{
							SetLocalInt(oTarget, "PRC_Power_Compression_SizeReduction", 1);
							SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, nSpellID, nCasterLevel);
							SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE, 1.5);
							DelayCommand(fDuration, ResetSize(oTarget));
						}		
					}	
					
					EvalPRCFeats(oTarget);
					DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, nSpellID, FloatToInt(fDuration) / 6));
				}
			}	
			if(!bMass) break;
			oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		}
	}

    PRCSetSchool();
}