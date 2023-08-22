//::///////////////////////////////////////////////
//:: [Censure Daemons]
//:: [prc_s_censuredm.nss]
//:://////////////////////////////////////////////
//:: All allies in the area are immune to fear
//:: and other mind effects created by outsiders
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"

void HeavenDevotion(object oTarget)
{
	effect eMind = VersusRacialTypeEffect(EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_MIND_SPELLS), RACIAL_TYPE_OUTSIDER);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMind, oTarget);
}

void main()
{
    object oTarget = GetEnteringObject();
    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
        //Declare major variables
        effect eFear = VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_FEAR), RACIAL_TYPE_OUTSIDER);
        effect eSave = VersusRacialTypeEffect(EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_FEAR), RACIAL_TYPE_OUTSIDER);
        effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);

        effect eLink = EffectLinkEffects(eDur, eFear);
        effect eLink2 = EffectLinkEffects(eDur, eSave);

        //Apply the VFX impact and effects
        // Caster is immune to fear from outsiders
        // Allies get +4 bonus vs fear from outsiders.
        if (oTarget == GetAreaOfEffectCreator())
        {
        	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        }
        else
        {
        	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget);
        }
        
        // Heavenly Devotion for allies
        if (GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE, GetAreaOfEffectCreator()) >= 5)
        {
        	HeavenDevotion(oTarget);
        }
     }
}
