/*
09/03/21 by Stratovarius

Dantalion, the Star Emperor
  
Dantalion, called the Star Emperor for his legend and appearance, is a composite of many souls. He grants binders the ability to teleport short distances, read thoughts, and stop foes.

Vestige Level: 5th
Binding DC: 25
Special Requirement: No

Influence: Dantalion’s influence causes you to be aloof and use stately gestures. Dantalion can’t help but be curious about the leaders of the day, 
so anytime you are within 100 feet of someone who clearly is (or professes to be) a leader of others, Dantalion requires that you try to read that 
person’s thoughts. Once you have made the attempt, regardless of success or failure, you need not try to read that person’s thoughts again.

Granted Abilities: 
Pact magic grimoires attest to Dantalion’s profound wisdom and his extensive knowledge about all subjects. Because he knows all thoughts, he can grant 
you a portion of that power, as well as the ability to travel just by thinking. You also gain a portion of his commanding presence, which many binders 
ascribe to his royal origins.

Awe of Dantalion: When you invoke this ability (a move action), any creature that sees you is unable to attack you or target you with a hostile spell 
for 1 round. If you attempt any hostile action, such as making an attack roll or casting an offensive spell against the affected creature or its allies, 
the effect ends. Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"
#include "spinc_dimdoor"
#include "prc_inc_template"

void ApplyCharm(object oTarget)
{
	object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
	int nRemove = FALSE;
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
    	if (GetItemPropertyType(ip) == ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS && GetItemPropertySubType(ip) == IP_CONST_IMMUNITYMISC_MINDSPELLS)
    	{
    		RemoveItemProperty(oItem, ip);
    		nRemove = TRUE;
    	}	
    	if (GetItemPropertyType(ip) == ITEM_PROPERTY_MIND_BLANK)
    	{
    		RemoveItemProperty(oItem, ip);
    		nRemove = TRUE;
    	}
        	
        ip = GetNextItemProperty(oItem);
    }	
	
    AssignCommand(oTarget, ClearAllActions(TRUE));
    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE), EffectCharmed());
    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oTarget, RoundsToSeconds(1)));   
    if (nRemove) DelayCommand(1.0, AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS), oItem));
}    

void main()
{
    object oBinder = OBJECT_SELF;

	if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_DANTALION)) return;	
	if (GetLevelByClass(CLASS_TYPE_SCION_DANTALION, oBinder) >= 2) if(!TakeSwiftAction(oBinder)) return;
	else if(!TakeMoveAction(oBinder)) return;
    
    location lTarget = GetLocation(oBinder);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(PSI_FNF_PSYCHIC_CRUSH), lTarget);
    // Use the function to get the closest creature as a target
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oBinder && GetIsEnemy(oTarget, oBinder)) // Only enemies
        	ApplyCharm(oTarget);

    //Select the next target within the spell shape.
    oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
        