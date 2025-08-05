
/* 
	Lion’s Courage (Ex): A lion of Talisid is immune to fear
	(magical or otherwise) and gains a +4 sacred bonus on Will saves
	against other mind-affecting spells and effects. 
*/

#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
   
	if(GetHasFeat(FEAT_LOT_LIONS_COURAGE, oPC) )
	{
		effect eFearless 	= EffectImmunity(IMMUNITY_TYPE_FEAR);
		effect eLink;
		
		eLink = EffectLinkEffects(eFearless, eLink);
		eLink = ExtraordinaryEffect(eLink);
		
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
		SetCompositeBonus(oSkin, "LionsCourageWillBonus", 4, ITEM_PROPERTY_SAVING_THROW_BONUS, IP_CONST_SAVEVS_MINDAFFECTING);
	}
	
}