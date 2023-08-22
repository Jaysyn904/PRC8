/*
14/02/19 by Stratovarius

Unravel Dweomer

Initiate, Unbinding Shade 
Level/School: 5th/Abjuration 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: Up to one creature/level, all within 30 ft. of each other 
Duration: Instantaneous 
Saving Throw: See text 
Spell Resistance: No

You open a conduit to the Plane of Shadow, leaching out the energy maintaining an ongoing magical effect.

This mystery functions like the spell break enchantment
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "inc_dispel"

void DispelLoop(object oTarget, int nShadowcasterLevel);

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);
    
    if(DEBUG) DoDebug("shd_myst_unrvldw: Main");    

    if(myst.bCanMyst)
    {
        location  lLocal       = PRCGetSpellTargetLocation();
        int       iTypeDispel  = GetLocalInt(GetModule(),"BIODispel");
        effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
        effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);
    
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lLocal);
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 9.14f, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE );
        if(DEBUG) DoDebug("shd_myst_unrvldw: bCanMyst");    
    
        //Set up for loop
        int i = myst.nShadowcasterLevel;
        
        while (i > 0)
        {
            if(DEBUG) DoDebug("shd_myst_unrvldw: i = "+IntToString(i));    
            SignalEvent(oTarget, EventSpellCastAt(oShadow, myst.nMystId));
            DispelLoop(oTarget, myst.nShadowcasterLevel);      
            i--;
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
    }
}

void DispelLoop(object oTarget, int nShadowcasterLevel)
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
                if (GetLocalInt(oTarget, " X2_Effect_Weave_ID_"+ IntToString(nIndex))) ModWeave = 4;
                if (SchoolWeave=="V" ||SchoolWeave=="T"  ) ModWeave = 0;
                
                // Penalty against non-Mysteries
                if (!GetIsMystery(nEffectSpellID)) nShadowcasterLevel -= 4;                
                
                int iDice = d20(1);
                //     SendMessageToPC(GetFirstPC(), "Spell :"+ IntToString(nEffectSpellID)+" T "+GetName(oTarget)+" C "+GetName(GetLocalObject(oTarget, " X2_Effect_Caster_" + IntToString(nIndex))));
                //     SendMessageToPC(GetFirstPC(), "Dispell :"+IntToString(iDice + nShadowcasterLevel)+" vs DC :"+IntToString(11 + nEffectCasterLevel+ModWeave)+" Weave :"+IntToString(ModWeave)+" "+SchoolWeave);
                
                
                if(iDice + nShadowcasterLevel >= 11 + nEffectCasterLevel + ModWeave + nBonus)
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
        if (GetLocalInt(oTarget, " XP2_L_SPELL_WEAVE" +IntToString (SPELL_INFESTATION_OF_MAGGOTS))) ModWeave = 4;
        // We know this isn't a mystery, so -4
        if(d20(1) + nShadowcasterLevel - 4 >= bHasInfestationEffects + 11 + ModWeave + nBonus)
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
    