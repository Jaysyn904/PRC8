//:://////////////////////////////////////////////
//:: Created By: Solowing
//:: Created On: September 2, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "x2_inc_switches"
#include "nw_o0_itemmaker"
#include "x2_inc_spellhook"

const int FEAT_ARCANE_STRIKE = 5172;

void StoreSpells (int nSpell, int nClevel, object oWeapon, object oPC)
{

	//This is the number of the already stored spells	
    	int temp = GetLocalInt(oPC,"charges");

	if(temp<10)
	{
    		SetLocalInt(oPC,"doarcstrike",TRUE);
    		if(temp<1)
    		{
    			temp = 1;
    		}
    		else
    		{
    			temp++;
    		}
    		int nLevel = StringToInt(Get2DACache("spells","Wiz_Sorc",nSpell));
    		if(nLevel > 0)
    		{
    			array_create(oPC, "arcstrike"); // This is used here and in prc_arc_feat2
    			array_set_int(oPC,"arcstrike",temp,nLevel);
    			FloatingTextStringOnCreature("You can store "+IntToString(10-temp)+" more spells into your weapon",OBJECT_SELF);
    			itemproperty ipTest = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,nClevel);
    			IPSafeAddItemProperty(oWeapon, ipTest, 9999.0);
    			SetLocalInt(oPC,"charges",temp);
    		}
    		else
    		{
    			FloatingTextStringOnCreature("Arcane Strike only stores arcane spells of 1st level or higher",OBJECT_SELF);
    		}
	}
	else
	{
		FloatingTextStringOnCreature("You have already stored the maximum allowed number of spells",OBJECT_SELF);
	}
}


//This function runs whenever the arcane strike feat is activated
void main()
{
    object oPC = OBJECT_SELF;


//If the caster does not have arcane strike or arcane strike isnt selected do nothing.
    if(!GetHasFeat(FEAT_ARCANE_STRIKE))
    {
    return;
    }
    if(!GetLocalInt(oPC,"arcstrikeactive"))
    {
    return;
    }

//we check the target of the spell
    object oWeapon = PRCGetSpellTargetObject();


if (oWeapon == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC))
{

//If the target is not a melee weapon or the ranged weapons ammo we inform the
//caster and cancel the storing
    if(IPGetIsMeleeWeapon(oWeapon)
    || GetBaseItemType(oWeapon)== BASE_ITEM_ARROW
    || GetBaseItemType(oWeapon)== BASE_ITEM_BOLT
    || GetBaseItemType(oWeapon)== BASE_ITEM_BULLET)
        {



//If the target is an equiped melee weapon, we get the spell ID of the casted
//spell the caster level of the spellsword and the metamagic feat.
int nSpell = GetSpellId();
int nClevel =PRCGetCasterLevel(OBJECT_SELF);


//This stops the original spellscript (and all craft item code)
// from being executed.
PRCSetUserSpecificSpellScriptFinished();


    StoreSpells (nSpell ,nClevel ,oWeapon , oPC);

}
else
{
    FloatingTextStringOnCreature("Arcane Strike only works with melee weapons or ammo",oPC);
    PRCSetUserSpecificSpellScriptFinished();
    return;
}
}
}
