//::///////////////////////////////////////////////
//:: [Aranea Web]
//:: [race_aranea_web.nss]
//:: [Jaysyn / PRC 20220420]
//::///////////////////////////////////////////////
/**@file  Web (Ex): In spider or hybrid form (see below), an aranea
can throw a web up to six times per day. This is similar to an
attack with a net but has a maximum range of 50 feet, with a
range increment of 10 feet, and is effective against targets of
up to Large size. The web anchors the target in place, allowing
no movement.

/////////////////////////////////////////////////////////////////////////////*/

#include "NW_I0_SPELLS"
#include "x2_inc_switches"
#include "prc_inc_nwscript"
#include "prc_inc_combmove"

void main()
{

//:: Declare major varibles
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
	
    int nHD = GetHitDice(oCaster);
	int nCount = d6(1) + (nHD / 2);
	int TargetSize = PRCGetSizeModifier(oTarget);
	int nHumanoid = GetLocalInt(oCaster, "AraneaHumanoidForm");
	
    effect eVis = EffectVisualEffect(VFX_DUR_WEB);
    effect eStick = EffectEntangle();
    effect eLink = ExtraordinaryEffect(EffectLinkEffects(eVis, eStick));
	

//:: Sanity check
	if (nHumanoid)
		{
			SendMessageToPC(oCaster, "You can't throw webbing in humanoid form");
			IncrementRemainingFeatUses(oCaster, FEAT_ARANEA_WEB);
			return;
        }	
	
//:: Only affects large or smaller targets
      if (TargetSize > 4)
      {
         FloatingTextStringOnCreature("This creature is too large to web.", oTarget);
		 IncrementRemainingFeatUses(oCaster, FEAT_ARANEA_WEB);
         return;
      }

//:: Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ARANEA_WEB));
	
//:: Make a ranged touch attack
    if (PRCDoRangedTouchAttack(oTarget))
    {
       if(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE )
       {
           //Apply the VFX impact and effects
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCount));
        }
    }
}
