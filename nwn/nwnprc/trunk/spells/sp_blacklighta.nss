//::///////////////////////////////////////////////
//:: Blacklight: On Enter
//:: sp_blacklighta.nss
//:://////////////////////////////////////////////
/*
    You create an area of total darkness.

	The darkness is impenetrable to normal vision 
	and darkvision, but you can see normally within 
	the blacklit area. Creatures outside the 
	spell's area, even you, cannot see through it. 
	You can cast the spell on a point in space, but 
	the effect is stationary unless you cast it cast 
	on a mobile object. You can cast the spell on a 
	creature, and the effect then radiates from the 
	creature and moves as it moves. Unattended 
	objects and points in space do not get saving 
	throws or benefit from spell resistance.

	Blacklight counters or dispels any light spell 
	of equal or lower level, such as daylight.
*/
//:://////////////////////////////////////////////
//:: Created By: Jaysyn
//:: Created On: 2026-05-28 12:07:02
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    int nMetaMagic 	= PRCGetMetaMagicFeat();
    effect eInvis 	= EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
    effect eInvis2 	= EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
    effect eDarkv 	= EffectUltravision();
    effect eCounc	= EffectConcealment(20);
    effect eDark 	= EffectDarkness();
    effect eBlind	= EffectBlindness();
	
    effect eDur 	= EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink 	= EffectLinkEffects(eDark, eDur);
           eLink 	= EffectLinkEffects(eLink, eBlind);
    effect eLink2 	=  EffectLinkEffects(eInvis, eDur);

			eLink2	= EffectLinkEffects(eInvis2,eDur);
			eLink2	= EffectLinkEffects(eDarkv, eLink2);
			eLink2	= EffectLinkEffects(eLink2,eCounc);

    object oTarget = GetEnteringObject();  
    int iShadow = GetLevelByClass(CLASS_TYPE_SHADOWLORD, oTarget);  
  
	if (iShadow)    
	{      
		eLink = ShadowlordEffects(iShadow, eLink);  
		eLink2 = ShadowlordEffects(iShadow, eLink2);
		eLink = TagEffect(eLink, "SHADOWSIGHT+BLUR");  
		eLink2 = TagEffect(eLink2, "SHADOWSIGHT+BLUR");			
	}  
   
    if(GetIsObjectValid(oTarget) && oTarget != GetAreaOfEffectCreator())
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLACKLIGHT));
            //Make SR Check
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget,SPGetPenetrAOE(GetAreaOfEffectCreator())))
            {
            	  //Fire cast spell at event for the specified target
                  SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
            }
        }
        else
        {
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLACKLIGHT, FALSE));
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