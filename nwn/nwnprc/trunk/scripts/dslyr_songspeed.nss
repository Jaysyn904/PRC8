#include "prc_inc_clsfunc"

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

    //Declare major variables
    object oTarget;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eFast = EffectMovementSpeedIncrease(50);
    effect eHaste = EffectHaste();
    effect eLink = EffectLinkEffects(eFast, eDur);
    if (GetHasFeat(FEAT_EPIC_DRAGONSONG_SPEED))
       eLink = EffectLinkEffects(eLink, eHaste);

    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST);

    //Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
    int nDuration = nLevel;

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

    location lSpell = PRCGetSpellTargetLocation();

    RemoveOldSongEffects(OBJECT_SELF,SPELL_DSL_SONG_SPEED);
    RemoveOldSongs(OBJECT_SELF);

    effect eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);
    eLink = EffectLinkEffects(eLink, eVis);
   // SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF,RoundsToSeconds(nDuration),FALSE);


    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lSpell);
    //Cycle through the targets within the spell shape until an invalid object is captured or the number of
    //targets affected is equal to the caster level.
    while(GetIsObjectValid(oTarget))
    {
        //Make faction check on the target
        if(oTarget == OBJECT_SELF)
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oTarget, RoundsToSeconds(nDuration),FALSE);
            StoreSongRecipient(oTarget, OBJECT_SELF, GetSpellId(), nDuration);
        }
        else if(GetIsFriend(oTarget))
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oTarget, RoundsToSeconds(nDuration),FALSE);
            StoreSongRecipient(oTarget, OBJECT_SELF, GetSpellId(), nDuration);
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lSpell);
    }
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_DRAGONSONG_STRENGTH);

}
