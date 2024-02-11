//::///////////////////////////////////////////////
//:: Darkness: On Enter
//:: NW_S0_DarknessA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
    effect eInvis2 = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
    effect eDarkv = EffectUltravision();
    effect eCounc=EffectConcealment(50);
    effect eDark = EffectDarkness();
    effect eBlind= EffectBlindness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eDark, eDur);
           eLink = EffectLinkEffects(eLink, eBlind);
    effect eLink2 =  EffectLinkEffects(eInvis, eDur);

    eLink2=EffectLinkEffects(eInvis2,eDur);
    eLink2=EffectLinkEffects(eDarkv, eLink2);
    eLink2=EffectLinkEffects(eLink2,eCounc);

    object oTarget = GetEnteringObject();

    int iShadow = GetLevelByClass(CLASS_TYPE_SHADOWLORD,oTarget);

    if (iShadow)
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectUltravision(), oTarget,0.0f,FALSE);
    if (iShadow>1)
      SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectConcealment(20), oTarget,0.0f,FALSE);

   
    if(GetIsObjectValid(oTarget) && oTarget != GetAreaOfEffectCreator())
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DARKNESS));
            //Make SR Check
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget,SPGetPenetrAOE(GetAreaOfEffectCreator())))
            {
            	if (!iShadow)
            	  //Fire cast spell at event for the specified target
                  SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
            }
        }
        else
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DARKNESS, FALSE));
            if (!iShadow)
              //Fire cast spell at event for the specified target
              SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        }

    }
    else if (oTarget == GetAreaOfEffectCreator())
    {
        //Fire cast spell at event for the specified target
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget);
       // FloatingTextStringOnCreature("Darkness " +GetName(oTarget), oTarget, FALSE);

    }
    
    PRCSetSchool();
}
