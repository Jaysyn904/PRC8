/*
5/1/20 by Stratovarius

Incarnate Weapon

Descriptors: Chaotic, evil, good, or lawful  
Classes: Incarnate 
Chakra: Arms 
Saving Throw: See text

Incarnum forms into a one-handed melee weapon that embodies your alignment. The weapon seems large for your hand, but it is balanced perfectly for you to wield it. Clutching it in your hand, you feel it resonate with your deepest convictions and firmest beliefs, and it hums with power.

You shape incarnum into a melee weapon. Chaotic incarnates create a battleaxe, evil incarnates create a flail, good incarnates create a warhammer, and lawful incarnates create a longsword. Nonproficiency penalties never apply to the use of an incarnate weapon, though any feats with effects that apply to a particular kind of weapon (such as Weapon Focus) function normally. If your incarnate weapon leaves your hand for any reason, it returns to your grasp.

Essentia: The incarnate weapon gains an enhancement bonus on attack rolls and damage rolls equal to the number of points of essentia you invest in it.

Chakra Bind (Arms) 

Bands of steel form around your forearms. When you hold your incarnate weapon, a chain of nearly invisible blue incarnum connects it to the steel bracer on your weapon hand, channeling the force of your conviction directly to your weapon.

As a move action, you can charge the incarnate weapon with the stunning power of pure conviction. If the next melee attack that you make is successful, the target (as long as at least one component of its alignment is opposed to your devoted alignment) must succeed on a Fortitude saving throw or be stunned for one round. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 15:17:05
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    object oWeapon;
    
    if (!IncarnateAlignment(oMeldshaper)) return;
    
	DestroyObject(GetItemPossessedBy(oMeldshaper, "moi_incarnatewpn")); // Remove any previous weapons created by Incarnate Weapon    

   	if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC)
   		oWeapon = CreateItemOnObject("moi_incarnwpn_ch", oMeldshaper);
   	else if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL)
   		oWeapon = CreateItemOnObject("moi_incarnwpn_ev", oMeldshaper);
   	else if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD)
   		oWeapon = CreateItemOnObject("moi_incarnwpn_gd", oMeldshaper);
   	else if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL)
   		oWeapon = CreateItemOnObject("moi_incarnwpn_lw", oMeldshaper);   
   		
   	DelayCommand(0.25, AssignCommand(oMeldshaper, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND)));	
	
	if (nEssentia) IPSafeAddItemProperty(oWeapon, ItemPropertyEnhancementBonus(nEssentia), 99999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_INCARNATE_WEAPON), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_SOUL || GetIsMeldBound(oMeldshaper) == CHAKRA_DOUBLE_SOUL) 
		IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_INCARNATE_WEAPON_ARMS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}