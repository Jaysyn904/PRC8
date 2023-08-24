//::///////////////////////////////////////////////
//:: Bard Song
//:: NW_S2_BardSong
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spells applies bonuses to all of the
    bard's allies within 30ft for a set duration of
    10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 25, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller Oct 1, 2003
/*
bugfix by Kovi 2002.07.30
- loosing temporary hp resulted in loosing the other bonuses
*/

#include "prc_inc_clsfunc"

void main()
{

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

    RemoveOldSongEffects(OBJECT_SELF,0);
    RemoveOldSongs(OBJECT_SELF);
     
//    effect eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);
//    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, OBJECT_SELF,0.0,FALSE); 
    
    //Set and apply AOE object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_DRAGON_FEAR,"dslyr_songstra","dslyr_songstrb","dslyr_songstrc");
    SPApplyEffectToObject(DURATION_TYPE_PERMANENT,eAOE, OBJECT_SELF,0.0,FALSE);
    StoreSongRecipient(OBJECT_SELF, OBJECT_SELF, GetSpellId(), 0);
    //DecrementRemainingFeatUses(OBJECT_SELF, FEAT_LYRITHSONG1);
    SetLocalInt(OBJECT_SELF, "SpellConc", 1);   
}
