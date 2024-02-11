/////////////////////////////////////////////////////////////////////////////////////////////////
//:: This is the prc_dispel_magic functions declarations.   The functions themselves are at the bottom
//:: of the file.       I got tired of circular include statement errors and just decided to make
//:: these both be just one file by adding my text to theirs.
///////////////////////////////////////////////////////////////////////////////////////////////

//:: This function is called from withing PRCApplyEffectToObject().  It's purpose is to
//:: clean up the three arrays that hold the caster level and references to all
//:: effects on the object having this struct PRCeffect applied to it.
//:: It also returns the expected number of entries in the new arrays it will have set up.
int ReorderEffects(struct PRCeffect eIn, object oTarget);

//:: This function is called from withing ReorderEffects().  It's purpose is to verify
//:: that the struct PRCeffect referred to by an entry in the 3 arrays is still in effect, returning
//:: FALSE if it is not.
int IsStillRealEffect(struct PRCeffect eEffect, object oTarget);

//:: This is my remake of the spellsDispelMagic found in x0_i0_spells.   It's pretty much
//:: identical to the old one except instead of calling the EffectDispelMagicBest() and
//:: EffectDispelMagicAll() scripting functions it calls the ones I've specified in this
//:: file to replace them.
void spellsDispelMagicMod(object oTarget, int nCasterLevel, struct PRCeffect eVis, struct PRCeffect eImpac, int bAll = TRUE, int bBreachSpells = FALSE);

//:: This is my remake of spellsDispelAoE().  It's very different, and very short.   It
//:: takes advantage of the way I've reworked AoE's so that it can simply use the caster
//:: level stored in the AoE and do a proper dispel check against it.
void spellsDispelAoEMod(object oTargetAoE, object oCaster, int nCasterLevel);

//:: This function is to replace EffectDispelMagicBest().   It goes through the references
//:: in the three arrays that store the caster levels and references to effects on oTarget,
//:: chooses the one with the highest caster level, and attempts to dispel it using the
//:: caster level entry in the array that corresponds to the spell itself.
void DispelMagicBestMod(object oTarget, int nCasterLevel);

//:: This function is to replace EffectDispelMagicAll().  It goest through all the references
//:: in the three arrays that store the caster levels and references to effects on oTarget, and
//:: attempts a dispel on each of them.  It only checks to dispel whole spells, not individual
//:: separate effects one spell may place on a person.
void DispelMagicAllMod(object oTarget, int nCasterLevel);

//:: This function sorts the 3 arrays in descending order of caster level, so entry 0 is the
//:: highest, and the last entry is the lowest.  It only gets called from inside DispelMagicBest()
void SortAll3Arrays(object oTarget);

//:: This function is just a helper function to include Infestation of Maggots among the list
//:: of spells in struct PRCeffect on oTarget, so it can be sorted with the rest. It's only called by
//:: DispelMagicBest()
void HandleInfestationOfMaggots(object oTarget);

// This sets many things that would have been checked against GetAreaOfEffectCreator()
// as local ints making it so the AoE can now function entirely independantly of its caster.
// - The only problem is that this will never be called until the AoE does a heartbeat or
// something.
void SetAllAoEInts(int SpellID, object oAoE, int nBaseSaveDC,int SpecDispel = 0, int nCasterLevel = 0);

// This is only meant to be called withing SetAllAoEInts()  I've heard terrible stories that
// say if an object is destroyed, it's local variables may remain in place eating up memory
// so I decided I'd better mop up after setting all of these.
void DeleteAllAoEInts(object oAoE);

// Returns the AoE's entire caster level, including any from prc's as stored in the local variable
int AoECasterLevel(object oAoE = OBJECT_SELF);

float GetRandomDelay(float fMinimumTime = 0.4, float MaximumTime = 1.1);

void PRCApplyEffectToObject(int nDurationType, struct PRCeffect eEffect, object oTarget, float fDuration = 0.0f, 
    int bDispellable = TRUE, int nSpellID = -1, int nCasterLevel = -1, object oCaster = OBJECT_SELF);

void PRCApplyEffectAtLocation(int nDurationType, struct PRCeffect eEffect, location lLocation, float fDuration=0.0f);

#include "NW_I0_GENERIC"
#include "prc_feat_const"
#include "lookup_2da_spell"
#include "prcsp_spell_adjs"
#include "prc_alterations"
#include "prc_inc_effect"

const string X2_EFFECT = "X2_Effects_";

///////////////////////////////////////////////////////////////////////////////////////////////////////

//:: Goes through the whole 3 stored lists of caster levels, spell id's, and casters,
//:: deletes any that aren't real anymore (refer to an struct PRCeffect no longer present), then
//:: builds a new list out of the ones that are still real/current (refer to effects that
//:: are still present)

//:: Thus, the list gets cleaned up every time it is added to.
//:: It returns the number of effects in the 3 new arrays.

int ReorderEffects(struct PRCeffect eIn, object oTarget)
{
    int nIndex = GetLocalInt(oTarget, X2_EFFECT+"Index_Number");
    struct PRCeffect eEffect;
    int nRealIndex = 0;
    int nPlace;

    for(nPlace = 0; nPlace <= nIndex; nPlace++)
    {
        // SendMessageToPC(OBJECT_SELF, "reorder for loop is happening at least once.");
        eEffect = GetLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nPlace));
        DeleteLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nPlace));

        if(IsStillRealEffect(eEffect, oTarget))
        {
            if(eEffect.nSpellID != eIn.nSpellID 
                || eEffect.oCaster != eIn.oCaster)
          // Take it out of the list if it's the spell now being cast, and by the same caster
          // This way spells that don't self dispel when they're recast don't flood the list
            {
                SetLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nRealIndex), eEffect);
 //             SendMessageToPC(OBJECT_SELF, "Index is incrementing.");
                nRealIndex++;
            }// end of if is the same as the current spell and caster
        }// end of if is valid struct PRCeffect statement
    }// end of for statement
   return nRealIndex; // This is the number of values currently in all 3 arrays -1.
}// end of function

//////////////////////////////////////////////////////////////////////////////////////////////////////

//:: This tests to make sure the data in my array still refers to an actual effect
//:: in case it has been dispelled or run out its duration since the data was put there.
int IsStillRealEffect(struct PRCeffect eEffect, object oTarget)
{
    struct PRCeffect eTest = GetEffectOnObjectFromPRCEffect(eEffect, oTarget);
    if(PRCGetIsEffectValid(eTest))
        return TRUE;
    return FALSE;
}

//:: Copy of the original function with 1 minor change: calls DispelMagicAll() and
//:: DispelMagicBest() instead of EffectDispelMagicAll() and EffectDispelMagicBest()
//:: That is the only change.
//------------------------------------------------------------------------------
// Attempts a dispel on one target, with all safety checks put in.
//------------------------------------------------------------------------------
void spellsDispelMagicMod(object oTarget, int nCasterLevel, struct PRCeffect eVis, struct PRCeffect eImpac, int bAll = TRUE, int bBreachSpells = FALSE)
{
    //--------------------------------------------------------------------------
    // Don't dispel magic on petrified targets
    // this change is in to prevent weird things from happening with 'statue'
    // creatures. Also creature can be scripted to be immune to dispel
    // magic as well.
    //--------------------------------------------------------------------------
    if (PRCGetHasEffect(EFFECT_TYPE_PETRIFY, oTarget) == TRUE 
        || GetLocalInt(oTarget, "X1_L_IMMUNE_TO_DISPEL") == 10)
    {
        return;
    }

    struct PRCeffect eDispel;
    float fDelay = GetRandomDelay(0.1, 0.3);
    int nId = PRCGetSpellId();

    //--------------------------------------------------------------------------
    // Fire hostile event only if the target is hostile...
    //--------------------------------------------------------------------------
    
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))    
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId));
    else
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId, FALSE));

    //--------------------------------------------------------------------------
    // GZ: Bugfix. Was always dispelling all effects, even if used for AoE
    //--------------------------------------------------------------------------
    if (bAll == TRUE )
    {
        //:: This is the first of 2 changes I made.
        DispelMagicAllMod(oTarget, nCasterLevel);

        // The way it used to get done.
        //eDispel = PRCEffectDispelMagicAll(nCasterLevel);

        //----------------------------------------------------------------------
        // GZ: Support for Mord's disjunction
        //----------------------------------------------------------------------
        if (bBreachSpells)
        {
            DoSpellBreach(oTarget, 6, 10, nId);
        }
    }
    else
    {
        //:: This is the second of the 2 changes I made.
        //:: There are no other changes.
        DispelMagicBestMod(oTarget, nCasterLevel);

        // The way it used to get done
        //eDispel = PRCEffectDispelMagicBest(nCasterLevel);

        if (bBreachSpells)
        {
           DoSpellBreach(oTarget, 2, 10, nId);
        }
    }

    DelayCommand(fDelay,PRCApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    DelayCommand(fDelay,PRCApplyEffectToObject(DURATION_TYPE_INSTANT, eDispel, oTarget));
}

/////////////////////////////////////////////////////////////////////////////////////
//::  This one's so small I hope not to lose track of it.

//:: Replaces the normal spellsDispelAoE
//:: I reworked all AoE's to store their caster level as a local int on themselves,
//:: so it's possible to just do a proper caster level check instead of doing
//:: something complicated.

void spellsDispelAoEMod(object oTargetAoE, object oCaster, int nCasterLevel)
{
   int ModWeave;
   int nBuffer = 0;
   int nGirding = 0;
   string SchoolWeave = lookup_spell_school(GetLocalInt(oTargetAoE, "X2_AoE_SpellID"));
   int Weave = GetHasFeat(FEAT_SHADOWWEAVE,oCaster)+ GetLocalInt(oCaster, "X2_AoE_SpecDispel");
   if (GetLocalInt(oTargetAoE, " X2_Effect_Weave_ID_") && !Weave) ModWeave = 4;
   if (SchoolWeave=="V" ||SchoolWeave=="T"  ) ModWeave = 0;
   if (GetLocalInt(oTargetAoE, "DispellingBuffer")) nBuffer = 5;
   if (GetHasFeat(FEAT_SPELL_GIRDING, oTargetAoE)) nGirding = 2;

   int iDice = d20(1);
//   SendMessageToPC(GetFirstPC(), "Spell :"+ IntToString(PRCGetSpellId())+" T "+GetName(oTargetAoE));
//   SendMessageToPC(GetFirstPC(), "Dispell :"+IntToString(iDice + nCasterLevel)+" vs DC :"+IntToString(11 + GetLocalInt(oTargetAoE, "X2_AoE_Caster_Level")+ModWeave)+" Weave :"+IntToString(ModWeave)+" "+SchoolWeave);

   if(iDice + nCasterLevel >= GetLocalInt(oTargetAoE, "X2_AoE_Caster_Level")+ModWeave+nBuffer+nGirding)
   {
     DestroyObject(oTargetAoE);
   }
}

 ///////////////////////////////////////////////////////////////////////////////////


//:: Goes through all the references to effects stored in the 3 variable arrays,
//:: picks the one with the highest caster level (breaking ties by just keeping the
//:: first one it comes to) and then attempts a dispel check on it.
//:: It goes by spell, not spell effect, so a successful check removes all spell
//:: affects from that spell itself.

void DispelMagicBestMod(object oTarget, int nCasterLevel)
{
    /// I *really*  want to rewrite this one so that it simply dispels the most useful effect
    /// instead of just the one with the highest caster level.
    /// Sure hate to dispel mage armor on somebody who's immune to necromancy.   Difficult Decision, these.

    //:: calls a function to determine whether infestation of maggots is in effect
    //:: on the target.   If so, it adds it to the 3 arrays so it can be sorted with them.
    HandleInfestationOfMaggots(oTarget);

    //:: calls a function to arrange the values in the 3 arrays in order of highest caster level to lowest
    //:: Index 0 will be the highest, and nLastEntry will be the lowest.

    SortAll3Arrays(oTarget);

    int nCurrentEntry;
    int nLastEntry = GetLocalInt(oTarget, X2_EFFECT+"Index_Number");

    struct PRCeffect eEffect;
    int nBuffer;
    if (GetLocalInt(oTarget, "DispellingBuffer")) 
        nBuffer = 5; // from psi_pow_displbuf

    string sSelf = "Dispelled: ";
    string sCast = "Dispelled on "+GetName(oTarget)+": ";
 
// SendMessageToPC(GetFirstPC(), "DispelMagicBestMod Weave Caster:"+ IntToString(Weave));

    for(nCurrentEntry = 0; nCurrentEntry <= nLastEntry; nCurrentEntry++)
    {
        eEffect = GetLocalPRCEffect(oTarget,X2_EFFECT+IntToString(nCurrentEntry));
        //:: Make sure the struct PRCeffect it refers to is still in place before making it
        //:: number one.
        if(IsStillRealEffect(eEffect, oTarget))
        {
            int nModWeave = 0;
            string SchoolWeave = lookup_spell_school(eEffect.nSpellID);
            string SpellName = GetStringByStrRef(StringToInt(lookup_spell_name(eEffect.nSpellID)));            

            int nRoll, nDC;
            nRoll += d20();
            nRoll += nCasterLevel;
            nDC += 11; //base
            nDC += eEffect.nCasterLevel;
            nDC += nBuffer; // from psi_pow_displbuf
            if (GetHasFeat(FEAT_TENACIOUSMAGIC, eEffect.oCaster)//effect creator has Tenacious Magic
                && !GetHasFeat(FEAT_SHADOWWEAVE, OBJECT_SELF) //other shadow weave users casting the dispel ignore this
                && SchoolWeave != "V" //evocation & transmutation spells dont benefit from Tenacious Magic
                && SchoolWeave != "T")  
                nDC += 4; //base goes from 11 to 15, +4
            if (GetHasFeat(FEAT_SPELL_GIRDING, eEffect.oCaster)) 
                nDC += 2; // from Spell Girding feat
//          SendMessageToPC(GetFirstPC(), "Spell :"+ IntToString(nEffectSpellID)+" T "+GetName(oTarget)+" C "+GetName(oEffectCaster));
//          SendMessageToPC(GetFirstPC(), "Dispell :"+ IntToString(iDice + nCasterLevel)+" vs DC :"+IntToString(11 + nEffectCastLevel+ModWeave)+" Mod Weave"+IntToString(ModWeave)+" "+SchoolWeave);
            if(nRoll >= nDC)

            {
                if(eEffect.nSpellID != SPELL_INFESTATION_OF_MAGGOTS)
                {// If it isn't infestation of maggots we remove it one way, if it is, we remove it another.
                    struct PRCeffect eToDispel = PRCGetFirstEffect(oTarget);
                    while(PRCGetIsEffectValid(eToDispel))
                    {
                        if(PRCGetEffectSpellId(eToDispel) == eEffect.nSpellID
                            && PRCGetEffectCreator(eToDispel) == eEffect.oCaster)
                        {
                            PRCRemoveEffect(oTarget, eToDispel);
                        }// end if struct PRCeffect comes from this spell
                        eToDispel = PRGetNextEffect(oTarget);
                    }// end of while loop
                }// end if infestation is not the spell
                else
                {   
                    DeleteLocalInt(oTarget, "XP2_L_SPELL_CASTER_LVL_" + IntToString (SPELL_INFESTATION_OF_MAGGOTS));
                    // Deleting this variable is what actually ends the spell effect's damage.
                    struct PRCeffect eToDispel = PRCGetFirstEffect(oTarget);
                    while(PRCGetIsEffectValid(eToDispel))
                    {
                        //:: We don't worry about who cast it.  A person can only really have one infestation
                        //:: going on at a time, I think.
                        if(PRCGetEffectSpellId(eToDispel) == eEffect.nSpellID)
                        {
                            PRCRemoveEffect(oTarget, eToDispel);
                        }// end if struct PRCeffect comes from this spell
                        eToDispel = PRGetNextEffect(oTarget);
                    }// end of while loop
                }// end else

                //:: Since the struct PRCeffect has been removed, delete the references to it.
                //:: This will help out the sweeping function when it gets called next (not now, though)
                DeleteLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nCurrentEntry));

                //:: Display a message to all involved.
                SendMessageToPC(OBJECT_SELF, sCast+SpellName);
                if (oTarget != OBJECT_SELF) 
                    SendMessageToPC(oTarget, sSelf+SpellName);

                //:: If the check was successful, then we're done.
                return;
            }// end if check is successful.
        }// end if is still a valid spell.
        else
        {
            // If it's not a real struct PRCeffect anymore, then delete the variables that refer to it.
            DeleteLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nCurrentEntry));
        }// end of else statement.
    }// end of for loop
    // If we got here, the return function above never ran, so nothing got removed:
    SendMessageToPC(OBJECT_SELF, sCast+"None");
    if (oTarget != OBJECT_SELF) 
        SendMessageToPC(oTarget, sSelf+"None");
} // End Of Function

///////////////////////////////////////////////////////////////////////////////////////////////////////

//:: Goes through and tries to remove each and every spell effect, doing a
//:: separate caster level check for each spell.   It goes by spell, not spell
//:: effect, so a successful check removes all spell affects from that spell
//:: itself.

void DispelMagicAllMod(object oTarget, int nCasterLevel)
{

  int nIndex = 0;
  int nEffectSpellID;
  int nEffectCasterLevel;
  object oEffectCaster;
  int ModWeave;
  int nBuffer;
  int nGirding = 0;

  int nLastEntry = GetLocalInt(oTarget, X2_EFFECT+"Index_Number");
  struct PRCeffect eToDispel;
  
  string sList, SpellName;
  string sSelf = "Dispelled: ";
  string sCast = "Dispelled on "+GetName(oTarget)+": ";  

  int Weave = GetHasFeat(FEAT_SHADOWWEAVE,OBJECT_SELF)+ GetLocalInt(OBJECT_SELF, "X2_AoE_SpecDispel");
//  SendMessageToPC(GetFirstPC(), "DispelMagicAllMod Weave Caster:"+ IntToString(Weave));
  if (GetLocalInt(oTarget, "DispellingBuffer")) nBuffer = 5;

  //:: Do the dispel check for each and every spell in struct PRCeffect on oTarget.
  for(nIndex; nIndex <= nLastEntry; nIndex++)
  {
    nEffectSpellID = GetLocalInt(oTarget, " X2_Effect_Spell_ID_" + IntToString(nIndex));
    if(GetHasSpellEffect(nEffectSpellID, oTarget))
    {
      ModWeave = 0;
      string SchoolWeave = lookup_spell_school(nEffectSpellID);
      SpellName = GetStringByStrRef(StringToInt(lookup_spell_name(nEffectSpellID)));
      nEffectCasterLevel = GetLocalInt(oTarget, " X2_Effect_Cast_Level_" + IntToString(nIndex));
      if (GetLocalInt(oTarget, " X2_Effect_Weave_ID_"+ IntToString(nIndex)) && !Weave) ModWeave = 4;
      if (SchoolWeave=="V" ||SchoolWeave=="T"  ) ModWeave = 0;
      if (GetHasFeat(FEAT_SPELL_GIRDING, oTarget)) nGirding = 2;
      
      int iDice = d20(1);
 //     SendMessageToPC(GetFirstPC(), "Spell :"+ IntToString(nEffectSpellID)+" T "+GetName(oTarget)+" C "+GetName(GetLocalObject(oTarget, " X2_Effect_Caster_" + IntToString(nIndex))));
 //     SendMessageToPC(GetFirstPC(), "Dispell :"+IntToString(iDice + nCasterLevel)+" vs DC :"+IntToString(11 + nEffectCasterLevel+ModWeave)+" Weave :"+IntToString(ModWeave)+" "+SchoolWeave);

      if(iDice + nCasterLevel >= 11 + nEffectCasterLevel+ModWeave+nBuffer+nGirding)
      {
        sList += SpellName+", ";
        oEffectCaster = GetLocalObject(oTarget, " X2_Effect_Caster_" + IntToString(nIndex));

        //:: Was going to use this function but upon reading it it became apparent it might not remove
        //:: all of the given spells effects, but just one instead.

        //PRCRemoveSpellEffects(nEffectSpellID, oEffectCaster, oTarget);

        //:: If the check is successful, go through and remove all effects originating
        //:: from that particular spell.
        struct PRCeffect eToDispel = PRCGetFirstEffect(oTarget);
        while(PRCGetIsEffectValid(eToDispel))
        {
          if(PRCGetEffectSpellId(eToDispel) == nEffectSpellID)
          {
            if(PRCGetEffectCreator(eToDispel) == oEffectCaster)
            {
              PRCRemoveEffect(oTarget, eToDispel);
            }// end if struct PRCeffect comes from this caster
          }// end if struct PRCeffect comes from this spell
          eToDispel = PRGetNextEffect(oTarget);
        }// end of while loop



        // Delete the saved references to the spell's effects.
        // This will save some time when reordering things a bit.
        DeleteLocalInt(oTarget, " X2_Effect_Spell_ID_" + IntToString(nIndex));
        DeleteLocalInt(oTarget, " X2_Effect_Cast_Level_" + IntToString(nIndex));
        DeleteLocalObject(oTarget, " X2_Effect_Caster_" + IntToString(nIndex));
        DeleteLocalInt(oTarget, " X2_Effect_Weave_ID_" + IntToString(nIndex));

      }// end of if caster check is sucessful
    }// end of if oTarget has effects from this spell
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
    
    if(d20(1) + nCasterLevel >= bHasInfestationEffects + 11+ModWeave+nBuffer+nGirding)
    {
      DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_INFESTATION_OF_MAGGOTS));
      DeleteLocalInt(oTarget,"XP2_L_SPELL_CASTER_LVL_" + IntToString (SPELL_INFESTATION_OF_MAGGOTS));
      struct PRCeffect eToDispel = PRCGetFirstEffect(oTarget);
      nEffectSpellID = SPELL_INFESTATION_OF_MAGGOTS;

      SpellName = GetStringByStrRef(StringToInt(lookup_spell_name(nEffectSpellID)));
      sList += SpellName+", ";

      while(PRCGetIsEffectValid(eToDispel))
      {
        if(PRCGetEffectSpellId(eToDispel) == nEffectSpellID)
        {
          PRCRemoveEffect(oTarget, eToDispel);
        }// end if struct PRCeffect comes from this spell
        eToDispel = PRGetNextEffect(oTarget);
      }// end of while loop
    }// end if caster level check was a success.
  }// end if infestation of maggots is in struct PRCeffect on oTarget/

  // If the loop to rid the target of the effects of infestation of maggots
  // runs at all, this next loop won't because eToDispel has to be invalid for this
  // loop to terminate and the other to begin - but it won't begin if eToDispel is
  // already invalid :)

  if (sList == "") sList = "None  ";
  sList = GetStringLeft(sList, GetStringLength(sList) - 2); // truncate the last ", "
  
  SendMessageToPC(OBJECT_SELF, sCast+sList);
  if (oTarget != OBJECT_SELF) SendMessageToPC(oTarget, sSelf+sList);

}// End of function.

///////////////////////////////////////////////////////////////////////////////////////////
//:: Sorts the 3 arrays in order of highest at index 0 on up to lowest at index nLastEntry
//////////////////////////////////////////////////////////////////////////////////////////

void SortAll3Arrays(object oTarget)
{

    int nLastEntry = GetLocalInt(oTarget, X2_EFFECT+"Index_Number");
    int nCurrEntry, nCurrEntry2, nCasterLvl, nCasterLvl2, nHighCastLvl, nHighestEntry;
    struct PRCeffect eTest;
    struct PRCeffect eTest2;
    struct PRCeffect eHigh;

    for(nCurrEntry = 0; nCurrEntry <= nLastEntry; nCurrEntry++)
    {
        eTest = GetLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nCurrEntry));
        nCasterLvl = eTest.nCasterLevel;
        nHighCastLvl = nCasterLvl;

        for(nCurrEntry2 = nCurrEntry + 1; nCurrEntry2 <= nLastEntry; nCurrEntry2++)
        {
            eTest2 = GetLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nCurrEntry));
            nCasterLvl2 = eTest.nCasterLevel;
            if(nCasterLvl2 >= nHighCastLvl)
            {
                nHighestEntry = nCurrEntry2;
                nHighCastLvl = nCasterLvl2;
            }
        }// End of second for statement.
        
        if(nHighCastLvl != nCasterLvl)
        // If the entry we're currently looking at already is the highest caster level left,
        // we leave it there.  Otherwise we swap the highest level entry with this one.
        // nHighCastLvl will still be equal to nCasterLvl unless a higher level struct PRCeffect was found.
        {
            eTest = GetLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nCurrEntry));
            eHigh = GetLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nHighestEntry));
            DeleteLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nCurrEntry));
            DeleteLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nHighestEntry));
            SetLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nCurrEntry), eHigh);
            SetLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nHighestEntry), eTest);
        }  // End if the caster levels of the 2 entries are actually different.
    }// End of first for statement.
}

//////////////////////////////////////////////////////////////////////////////////////////////
//:: Finished sorting.
/////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////
//:: Infestation of maggots is a special case because it won't end until a local
//:: int is deleted.   It must be handled specially.
/////////////////////////////////////////////////////////////////////////////////
void HandleInfestationOfMaggots(object oTarget)
{
    //:: Special to trap an infestation of maggots effect.
    int nHasInfestationEffect = GetLocalInt(oTarget, "XP2_L_SPELL_CASTER_LVL_" + IntToString (SPELL_INFESTATION_OF_MAGGOTS));

    int nLastEntry = GetLocalInt(oTarget, "X2_Effects_Index_Number");
    if(nHasInfestationEffect)
    {  
        // If they have infestation of maggots on them, then add it to the end of the list.
        // I would add it during the spell script itself but it might get swept up before the spell has
        // really ended, I fear.
        nLastEntry++;
        DeleteLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nLastEntry));

        SetLocalInt(oTarget, " X2_Effect_Spell_ID_" + IntToString(nLastEntry), SPELL_INFESTATION_OF_MAGGOTS);
        SetLocalInt(oTarget, " X2_Effect_Cast_Level_" + IntToString(nLastEntry), nHasInfestationEffect);
        SetLocalInt(oTarget, " X2_Effect_Weave_ID_" + IntToString(nLastEntry), GetLocalInt(oTarget, " XP2_L_SPELL_WEAVE" +IntToString (SPELL_INFESTATION_OF_MAGGOTS)));
        //:: Won't bother with this one. I think a creature can only have one infestation at a time.
        //SetLocalObject(oTarget, " X2_Effect_Caster_" + IntToString(nLastEntry));
        SetLocalInt(oTarget, "X2_Effects_Index_Number", nLastEntry);
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////
//:: End of section to trap infestation of maggots.
////////////////////////////////////////////////////////////////////////////////////////////

void PRCApplyEffectToObject(int nDurationType, struct PRCeffect eEffect, object oTarget, float fDuration = 0.0f, 
    int bDispellable = TRUE, int nSpellID = -1, int nCasterLevel = -1, object oCaster = OBJECT_SELF)
{
    //this should be passed in, for testing its set here
    struct PRCeffect prceEffect;

    // Extraordinary/Supernatural effects are not supposed to be dispellable.
    if (PRCGetEffectSubType(eEffect) == SUBTYPE_EXTRAORDINARY 
        || PRCGetEffectSubType(eEffect) == SUBTYPE_SUPERNATURAL)
    {
        bDispellable = FALSE;
    }

    // Instant duration effects can use BioWare code, the PRC code doesn't care about those
    if (DURATION_TYPE_INSTANT == nDurationType)
    {
       ApplyEffectToObject(nDurationType, prceEffect.eEffect, oTarget, fDuration);
    }
    else
    {

        // Invoke the PRC apply function passing the extra data.
       int nIndex = ReorderEffects(prceEffect, oTarget);
       // Add this new struct PRCeffect to the slot after the last struct PRCeffect already on the character.
       ApplyEffectToObject(nDurationType, prceEffect.eEffect, oTarget, fDuration);
       // may have code travers the lists right here and not add the new effect
       // if an identical one already appears in the list somewhere
       SetLocalPRCEffect(oTarget, X2_EFFECT+IntToString(nIndex), prceEffect);

       //nIndex++;
       /// Set new index number to the character.
       SetLocalInt(oTarget, X2_EFFECT+"Index_Number", nIndex);
    }
}

void PRCApplyEffectAtLocation(int nDurationType, struct PRCeffect eEffect, location lLocation, float fDuration=0.0f)
{
    ApplyEffectAtLocation(nDurationType, eEffect.eEffect, lLocation, fDuration);
}

// Sets up all of the AoE's int values, but only if they aren't already set.
// When called in a function nMetamagic should be GetMetamagicFeat(), and nBaseSaveDC should be PRCGetSaveDC()
void SetAllAoEInts(int SpellID, object oAoE, int nBaseSaveDC ,int SpecDispel = 0 , int nCasterLevel = 0)
{
    if(GetLocalInt(oAoE, "X2_AoE_Is_Modified") != 1)
    {

       // I keep making calls to GetAreaOfEffectCreator()
       // I'm not sure if it would be better to just set it one time as an object variable
       // It would certainly be better in terms of number of operations, but I'm not sure
       // if it's as accurate.
       // It's a total of 7 calls, so I figure it doesn't matter that much.  Still, 1 would be better than 7.
       // Also: the 7 calls only happen once per casting of the AoE.
       if ( !nCasterLevel) nCasterLevel = PRCGetCasterLevel(GetAreaOfEffectCreator());

       ActionDoCommand(SetLocalInt(oAoE, "X2_AoE_Caster_Level", nCasterLevel));
       ActionDoCommand(SetLocalInt(oAoE, "X2_AoE_SpellID", SpellID));
       ActionDoCommand(SetLocalInt(oAoE, "X2_AoE_Weave", GetHasFeat(FEAT_SHADOWWEAVE,GetAreaOfEffectCreator())));
       if (SpecDispel) ActionDoCommand(SetLocalInt(oAoE, "X2_AoE_SpecDispel", SpecDispel));
       ActionDoCommand(SetLocalInt(oAoE, "X2_AoE_Is_Modified", 1));
    }
 
}

// Just returns the stored value.
int AoECasterLevel(object oAoE = OBJECT_SELF)
{
   int toReturn = GetLocalInt(oAoE, "X2_AoE_Caster_Level");
   return toReturn;
}