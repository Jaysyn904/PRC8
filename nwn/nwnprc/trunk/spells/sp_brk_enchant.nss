//::///////////////////////////////////////////////
//:: Name      Break Enchantment
//:: FileName  sp_brk_enchant.nss
//:://////////////////////////////////////////////
/**@file Break Enchantment
Abjuration
Level: Brd 4, Clr 5, Luck 5, Pal 4, Sor/Wiz 5, Hexblade 4
Components: V, S
Casting Time: 1 minute
Range: Close (25 ft. + 5 ft./2 levels)
Targets: Up to one creature per level, all within 30 ft. of 
each other
Duration: Instantaneous
Saving Throw: See text
Spell Resistance: No

This spell frees victims from enchantments, transmutations, 
and curses. Break enchantment can reverse even an 
instantaneous effect. For each such effect, you make a 
caster level check (1d20 + caster level, maximum +15) 
against a DC of 11 + caster level of the effect. Success 
means that the creature is free of the spell, curse, or 
effect. For a cursed magic item, the DC is 25.

If the spell is one that cannot be dispelled by dispel 
magic, break enchantment works only if that spell is 5th
level or lower. 
If the effect comes from some permanent magic item break 
enchantment does not remove the curse from the item, but 
it does frees the victim from the item’s effects. 

**/
void DispelLoop(object oTarget, int nCasterLevel);

#include "inc_dispel"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	
	object    oPC          = OBJECT_SELF;
	effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
	effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);
	object    oTarget      = PRCGetSpellTargetObject();
	location  lLocal       = PRCGetSpellTargetLocation();
	int       nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
	int       iTypeDispel  = GetLocalInt(GetModule(),"BIODispel");
	

	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());
	oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 9.14f, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE );
	
	//Set up for loop
	int i = nCasterLevel;
	
	while (i > 0)
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_REMOVE_CURSE));
		DispelLoop(oTarget, nCasterLevel);		
		i--;
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
	}
	PRCSetSchool();
}
	
void DispelLoop(object oTarget, int nCasterLevel)
{
	int nIndex = 0;
	int nEffectSpellID;
	int nEffectCasterLevel;
	object oEffectCaster;
	int ModWeave;
	int nBonus = 0;
	int nSchool;
	
	int nLastEntry = GetLocalInt(oTarget, "X2_Effects_Index_Number");
	effect eToDispel;
	
	string sList, SpellName;
	string sSelf = "Dispelled: ";
	string sCast = "Dispelled on "+GetName(oTarget)+": ";
	
	int Weave = GetHasFeat(FEAT_SHADOWWEAVE,OBJECT_SELF)+ GetLocalInt(OBJECT_SELF, "X2_AoE_SpecDispel");
	if (GetLocalInt(oTarget, "PRC_Power_DispellingBuffer_Active")) nBonus += 5;
	if (GetHasFeat(FEAT_SPELL_GIRDING, oTarget)) nBonus += 2;
	if (GetLevelByClass(CLASS_TYPE_SUEL_ARCHANAMACH, oTarget) >= 1) nBonus += 6;
	
	//:: Do the dispel check for each and every spell in effect on oTarget.
	for(nIndex; nIndex <= nLastEntry; nIndex++)
	{
		nEffectSpellID = GetLocalInt(oTarget, " X2_Effect_Spell_ID_" + IntToString(nIndex));
		
		nSchool = GetSpellSchool(nEffectSpellID);
		
		//Only dispells enchantments and transmutations
		if(nSchool == SPELL_SCHOOL_ENCHANTMENT || 
		   nSchool == SPELL_SCHOOL_TRANSMUTATION)
		{
			if(GetHasSpellEffect(nEffectSpellID, oTarget))
			{
				ModWeave = 0;
				string SchoolWeave = lookup_spell_school(nEffectSpellID);
				SpellName = GetStringByStrRef(StringToInt(lookup_spell_name(nEffectSpellID)));
				nEffectCasterLevel = GetLocalInt(oTarget, " X2_Effect_Cast_Level_" + IntToString(nIndex));
				if (GetLocalInt(oTarget, " X2_Effect_Weave_ID_"+ IntToString(nIndex)) && !Weave) ModWeave = 4;
				if (SchoolWeave=="V" ||SchoolWeave=="T"  ) ModWeave = 0;
				
				int iDice = d20(1);
				//     SendMessageToPC(GetFirstPC(), "Spell :"+ IntToString(nEffectSpellID)+" T "+GetName(oTarget)+" C "+GetName(GetLocalObject(oTarget, " X2_Effect_Caster_" + IntToString(nIndex))));
				//     SendMessageToPC(GetFirstPC(), "Dispell :"+IntToString(iDice + nCasterLevel)+" vs DC :"+IntToString(11 + nEffectCasterLevel+ModWeave)+" Weave :"+IntToString(ModWeave)+" "+SchoolWeave);
				
				
				if(iDice + nCasterLevel >= 11 + nEffectCasterLevel + ModWeave + nBonus)
				{
					sList += SpellName+", ";
					oEffectCaster = GetLocalObject(oTarget, " X2_Effect_Caster_" + IntToString(nIndex));
					
					//:: If the check is successful, go through and remove all effects originating
					//:: from that particular spell.
					effect eToDispel = GetFirstEffect(oTarget);
					
					while(GetIsEffectValid(eToDispel))
					{
						if(GetEffectSpellId(eToDispel) == nEffectSpellID)
						{
							if(GetEffectCreator(eToDispel) == oEffectCaster)
							{
								RemoveEffect(oTarget, eToDispel);
								
								//Spell Removal Check
								SpellRemovalCheck(oEffectCaster, oTarget);
							}// end if effect comes from this caster
						}// end if effect comes from this spell
						eToDispel = GetNextEffect(oTarget);
					}// end of while loop
					
					// These are stored for one round for Spell Rebirth
					SetLocalInt(oTarget, "TrueSpellRebirthSpellId", GetLocalInt(oTarget, " X2_Effect_Spell_ID_" + IntToString(nIndex))); 
					SetLocalInt(oTarget, "TrueSpellRebirthCasterLvl", GetLocalInt(oTarget, " X2_Effect_Cast_Level_" + IntToString(nIndex)));
					DelayCommand(6.0, DeleteLocalInt(oTarget, "TrueSpellRebirthSpellId"));
					DelayCommand(6.0, DeleteLocalInt(oTarget, "TrueSpellRebirthCasterLvl"));
					
					// Delete the saved references to the spell's effects.
					// This will save some time when reordering things a bit.
					DeleteLocalInt(oTarget, " X2_Effect_Spell_ID_" + IntToString(nIndex));
					DeleteLocalInt(oTarget, " X2_Effect_Cast_Level_" + IntToString(nIndex));
					DeleteLocalObject(oTarget, " X2_Effect_Caster_" + IntToString(nIndex));
					DeleteLocalInt(oTarget, " X2_Effect_Weave_ID_" + IntToString(nIndex));
					
				}// end of if caster check is sucessful
			}// end of if oTarget has effects from this spell
		}
	}// end of for statement
	
	
	// Additional Code to dispel any infestation of maggots effects.
	
	// If check to take care of infestation of maggots is in effect.
	// with the highest caster level on it right now.
	// If it is, we remove it instead of the other effect.
	int bHasInfestationEffects = GetLocalInt(oTarget,"XP2_L_SPELL_CASTER_LVL_" + IntToString (SPELL_INFESTATION_OF_MAGGOTS));
	
	if(bHasInfestationEffects)
	{
		ModWeave =0;
		if (GetLocalInt(oTarget, " XP2_L_SPELL_WEAVE" +IntToString (SPELL_INFESTATION_OF_MAGGOTS)) && !Weave) ModWeave = 4;
		
		if(d20(1) + nCasterLevel >= bHasInfestationEffects + 11 + ModWeave + nBonus)
		{
			DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_INFESTATION_OF_MAGGOTS));
			DeleteLocalInt(oTarget,"XP2_L_SPELL_CASTER_LVL_" + IntToString (SPELL_INFESTATION_OF_MAGGOTS));
			effect eToDispel = GetFirstEffect(oTarget);
			nEffectSpellID = SPELL_INFESTATION_OF_MAGGOTS;
			
			SpellName = GetStringByStrRef(StringToInt(lookup_spell_name(nEffectSpellID)));
			sList += SpellName+", ";
			
			while(GetIsEffectValid(eToDispel))
			{	      
				if(GetEffectSpellId(eToDispel) == nEffectSpellID)
				{
					RemoveEffect(oTarget, eToDispel);
				}// end if effect comes from this spell
				eToDispel = GetNextEffect(oTarget);
			}// end of while loop
		}// end if caster level check was a success.
	}// end if infestation of maggots is in effect on oTarget/
	
	// If the loop to rid the target of the effects of infestation of maggots
	// runs at all, this next loop won't because eToDispel has to be invalid for this
	// loop to terminate and the other to begin - but it won't begin if eToDispel is
	// already invalid :)
	
	if (sList == "") sList = "None  ";
	sList = GetStringLeft(sList, GetStringLength(sList) - 2); // truncate the last ", "
	
	SendMessageToPC(OBJECT_SELF, sCast+sList);
	if (oTarget != OBJECT_SELF) SendMessageToPC(oTarget, sSelf+sList);
	
}// End of function.	
	