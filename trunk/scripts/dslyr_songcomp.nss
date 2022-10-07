#include "prc_inc_clsfunc"

void DominatedDuration(object oTarget, object oCaster)
{
   int iConc = GetLocalInt(oCaster, "SpellConc");

   if (!iConc)
   {
        PRCRemoveEffectsFromSpell(oCaster,SPELL_DSL_SONG_COMPULSION);
        return ;
   }

   if (GetHasSpellEffect(SPELL_DSL_SONG_COMPULSION,oTarget))
   {
      DelayCommand(6.0f,DominatedDuration(oTarget,oCaster) );
   }
}

void main()
{
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

    RemoveOldSongEffects(OBJECT_SELF, 0);
    RemoveOldSongs(OBJECT_SELF);

    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    effect eDom = EffectDominated();
    eDom = PRCGetScaledEffect(eDom, oTarget);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link domination and persistant VFX
    effect eLink = EffectLinkEffects(eMind, eDom);

    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST);
    effect eVis2 = EffectVisualEffect(VFX_DUR_BARD_SONG);

    int nRacial = MyPRCGetRacialType(oTarget);

    int nFocSong;
    if (GetHasFeat(FEAT_EPIC_FOCUS_DRAGONSONG)) nFocSong = 6;
    else if (GetHasFeat(FEAT_GREATER_FOCUS_DRAGONSONG)) nFocSong = 4;
    else if (GetHasFeat(FEAT_FOCUS_DRAGONSONG)) nFocSong = 2;

    int nEpic = GetHasFeat(FEAT_EPIC_DRAGONSONG_COMPULSION) ? TRUE:FALSE;
    int nDC = 12 + nFocSong + GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST,OBJECT_SELF)+ GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF);

    if (nRacial== RACIAL_TYPE_DRAGON ) nDC-=2;

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_MONSTER, FALSE));
    //Make sure the target is a monster
    if(!GetIsReactionTypeFriendly(oTarget))
    {
          int iSave = PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS);
          if ( nEpic && iSave) iSave = PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS);

          //Make a Will Save
          if (!iSave)
          {
               //Apply linked effects and VFX Impact
               SPApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eLink), oTarget, 0.0,FALSE);
               SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
               SPApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eVis2), OBJECT_SELF,0.0,FALSE);
               SetLocalInt(OBJECT_SELF, "SpellConc", 1);
               DelayCommand(6.0f,DominatedDuration(oTarget,oCaster) );
               StoreSongRecipient(OBJECT_SELF, OBJECT_SELF, GetSpellId(), 0);
          }


     }

    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_DRAGONSONG_STRENGTH);


}
