//::///////////////////////////////////////////////
//:: Heal
//:: [NW_S0_Heal.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Heals the target to full unless they are undead.
//:: If undead they reduced to 1d4 HP.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: Aug 1, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff

//::Added code to maximize for Faith Healing and Blast Infidel
//::Aaon Graywolf - Jan 7, 2004

#include "prc_inc_clsfunc"

void main()
{


  //Declare major variables
  object oTarget = OBJECT_SELF;
  effect eHeal;
  int  nHeal;
  effect eSun = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
  effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_S);

  effect eRegen = EffectRegenerate(3, 6.0);
  effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
  effect eLink = EffectLinkEffects(eRegen, eDur);
         eLink = EffectLinkEffects(eLink, eVis);


  if (!GetHasFeat(FEAT_DRAGONSONG_STRENGTH, OBJECT_SELF))
  {
        FloatingTextStringOnCreature("This ability is tied to your dragons song ability, which has no more uses for today.",OBJECT_SELF); // no more bardsong uses left
        return;
  }

  if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
  {
       FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
       return;
  }

  if (PRCGetHasEffect(EFFECT_TYPE_DEAF,OBJECT_SELF) && d100(1) <= 20)
  {
      FloatingTextStringOnCreature("Your deafness has caused you to fail.",OBJECT_SELF);
      DecrementRemainingFeatUses(OBJECT_SELF, FEAT_DRAGONSONG_STRENGTH);
      return;
  }

  effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

  RemoveOldSongEffects(OBJECT_SELF,SPELL_DSL_SONG_HEALING);
  RemoveOldSongs(OBJECT_SELF);

  int nEpic = GetHasFeat(FEAT_EPIC_DRAGONSONG_HEALING) ? TRUE:FALSE;
  //Fire cast spell at event for the specified target
  SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL, FALSE));

    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST);

    //Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
    int nDuration = 10*nLevel;

        //Check to see if the caster has Lasting Impression and increase duration.
    if(GetHasFeat(870))
    {
        nDuration *= 10;
    }

    // lingering song
    if(GetHasFeat(424)) // lingering song
    {
        nDuration += 5;
    }

  //Get first target in shape
  oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, PRCGetSpellTargetLocation());
  while (GetIsObjectValid(oTarget))
  {

     if(GetIsReactionTypeFriendly(oTarget)|| GetFactionEqual(oTarget))
     {
        //Figure out how much to heal
        nHeal = (nEpic) ? (d8(4) + 2 * nLevel) : (d8(2) + 2 * nLevel); // cure moderate or cure critical (epic)

        //Set the heal effect
        eHeal = EffectHeal(nHeal);
        //Apply the heal effect and the VFX impact
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);

        if (nEpic)
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oTarget, RoundsToSeconds(nDuration),FALSE);
            StoreSongRecipient(oTarget, OBJECT_SELF, GetSpellId(), nDuration);
         }
        // Code for FB to remove damage that would be caused at end of Frenzy
        SetLocalInt(oTarget, "PC_Damage", 0);
     }
     //Get next target in the shape
     oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, PRCGetSpellTargetLocation());
  }

  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_DRAGONSONG_STRENGTH);

}
