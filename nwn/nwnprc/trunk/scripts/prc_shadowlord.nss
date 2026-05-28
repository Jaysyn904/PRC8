//::////////////////////////////////////////////////////////
//::
//:: prc_shadolord.nss
//::
//:: Handles Shadow Sight & Shadow Blur
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-05-28 13:54:50
//::
//::////////////////////////////////////////////////////////
//::
//:: Shadow Sight - Gains Darkvision and Ultravision in 
//::				darkness.
//::
//:: Shadow Blur - In darkness gains the benefit of Blur 
//;:				spell (20% concealment at night or in
//::				a Darkness spell).
//::
//:: Shadow Discorporation - When reduced to 0 or fewer HP,
//::  (NOT IMPLEMENTED)		 has a chance to teleport away.
//::
//:://////////////////////////////////////////////////////// 
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_alterations"

void Discorp(object oPC,int iEquip)
{
  object oItem ;

  if (iEquip==2)
  {
     oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
     if ( GetLocalInt(oItem,"ShaDiscorp")) return;

        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,9999.0);
        SetLocalInt(oItem,"ShaDiscorp",1);
  }
  else if (iEquip==1)
  {
      oItem=GetItemLastUnequipped();
      if (!GetLocalInt(oItem,"ShaDiscorp")) return;
         RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0,1,"",-1,DURATION_TYPE_TEMPORARY);
      DeleteLocalInt(oItem,"ShaDiscorp");
  }
   else
  {
     oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
     if ( !GetLocalInt(oItem,"ShaDiscorp"))
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,9999.0);
       SetLocalInt(oItem,"ShaDiscorp",1);
     }
  }


}

void main()
{

    //:: Declare main variables.
    object oPC 		= OBJECT_SELF;
    object oSkin	= GetPCSkin(oPC);
	object oArea 	= GetArea(oPC);
	
	int iShadow 	= GetLevelByClass(CLASS_TYPE_SHADOWLORD, oPC); 	
	int nNight 		= !GetIsDay();
	int nTopside 	= GetIsAreaAboveGround(oArea);
	int nOutside 	= !GetIsAreaInterior(oArea);
	
	effect eLink;
	effect eVis;
	
	if (iShadow && nNight && nTopside && nOutside)
	{
		//:: Create visual feedback effect link  
		eVis = EffectVisualEffect(VFX_DUR_ULTRAVISION);  
		eVis = EffectLinkEffects(eVis, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));  
		eVis = EffectLinkEffects(eVis, EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT)); 
		eVis = EffectLinkEffects(eVis, EffectIcon(EFFECT_ICON_ULTRAVISION));		
		  
		//:: Link Ultravision and visual feedback into base effect
		eLink = EffectLinkEffects(eLink, EffectUltravision()); 
		eLink = EffectLinkEffects(eLink, eVis);
		if(DEBUG) DoDebug("prc_shadowlord >> Setting up Ultravision");	
		  
		if (iShadow > 1)  
		{  
			//;: Add concealment for level 2+ Shadowlords  
			eLink = EffectLinkEffects(eLink, EffectConcealment(20)); 
			if(DEBUG) DoDebug("prc_shadowlord >> Setting up Concealment");			
		}

		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0f);
		
	}		

//:: Shadow Discorporation was never finished
/*     int bDiscor= GetHasFeat(FEAT_SHADOWDISCOPOR, oPC) ? 1 : 0;

    if (GetLocalInt(oPC,"ONENTER")) return;
    if (bDiscor>0)   Discorp(oPC,GetLocalInt(oPC,"ONEQUIP")); */
	
}