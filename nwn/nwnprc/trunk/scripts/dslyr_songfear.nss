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

#include "prc_inc_clsfunc"

void main()
{
    object oPC = OBJECT_SELF;

    if(!GetHasFeat(FEAT_DRAGONSONG_STRENGTH, oPC))
    {
        FloatingTextStringOnCreature("This ability is tied to your dragons song ability, which has no more uses for today.", oPC, FALSE); // no more bardsong uses left
        return;
    }

    if(PRCGetHasEffect(EFFECT_TYPE_SILENCE, oPC))
    {
        FloatingTextStrRefOnCreature(85764, oPC, FALSE); // not useable when silenced
        return;
    }

    if(PRCGetHasEffect(EFFECT_TYPE_DEAF, oPC) && d100(1) <= 20)
    {
        FloatingTextStringOnCreature("Your deafness has caused you to fail.", oPC, FALSE);
        DecrementRemainingFeatUses(oPC, FEAT_DRAGONSONG_STRENGTH);
        return;
    }

    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(oPC));

    RemoveOldSongEffects(oPC, SPELL_DSL_SONG_FEAR);
    RemoveOldSongs(oPC);

    //Set and apply AOE object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_DRAGON_FEAR, "dslyr_songfeara", "dslyr_songfearb");
    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oPC, 0.0, FALSE);
    StoreSongRecipient(oPC, oPC, SPELL_DSL_SONG_FEAR);

    DecrementRemainingFeatUses(oPC, FEAT_DRAGONSONG_STRENGTH);
    SetLocalInt(oPC, "SpellConc", 1);
}
