//::///////////////////////////////////////////////
//:: Name      Darkflame Arrow
//:: FileName  sp_drkflm_arrow.nss
//:://////////////////////////////////////////////
/**@file Darkflame Arrow
Evocation
Level: Assassin 3, Ranger 3
Components: V, M
Casting Time: 1 swift action
Range: Long
Target: One creature
Duration: Instantaneous; see text
Saving Throw: None
Spell Resistance: Yes

Upon casting this spell, you fire a magical or masterwork
arrow or bolt, engulfing its head in black fire. The arrow deals
normal damage and wreaths the target in black flame that deals an 
extra 2d6 points of damage.

The black flames continue to engulf the victim for 2 more rounds,
dealing 2d6 points of damage each subsequent round, and they cannot
be extinguished (although they can be dispelled). The arrow or bolt 
must be fired during the same round the spell is cast, or the magic 
dissipates and is lost. Creatures with immunity or resistance to fire 
take full damage from the black flames. 

Material Component: Masterwork arrow or bolt.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void Burn(object oTarget, int nCounter, int nCasterLvl, object oPC);

#include "prc_inc_spells"
#include "prc_craft_inc"
#include "prc_inc_combat"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_EVOCATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        effect eImp = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);
        effect eBurn = EffectVisualEffect(VFX_DUR_INFERNO);
        object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        object oAmmo;
        
        int nType = GetBaseItemType(oWeap);
                
        if(nType != BASE_ITEM_LONGBOW && 
           nType != BASE_ITEM_SHORTBOW &&
           nType != BASE_ITEM_LIGHTCROSSBOW && 
           nType != BASE_ITEM_HEAVYCROSSBOW)
        {
                PRCSetSchool();
                return;
        }
        
        if(nType == BASE_ITEM_LONGBOW || nType == BASE_ITEM_SHORTBOW)
        {
		oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
	}
	
	else if (nType == BASE_ITEM_LIGHTCROSSBOW || nType == BASE_ITEM_HEAVYCROSSBOW)
	{
		oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
	}
        
        //Check for Masterwork or magical
        string sMaterial = GetStringLeft(GetTag(oAmmo), 3);
        
        if((!(GetMaterialString(StringToInt(sMaterial)) == sMaterial && sMaterial != "000") && !GetIsMagicItem(oAmmo)))
        {
                PRCSetSchool();
                return;
        }
        
        PerformAttack(oTarget, oPC, eImp);
        
        //if hit
        if(GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
        {
                Burn(oTarget, 3, PRCGetCasterLevel(oPC), oPC);
        }
        
        PRCSetSchool();
        return;
}

void Burn(object oTarget, int nCounter, int nCasterLvl, object oPC)
{
        if(!PRCDoResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
        {
        	int nDam = SpellDamagePerDice(oPC, 2) + d6(2);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
                nCounter--;
                DelayCommand(RoundsToSeconds(1), Burn(oTarget, nCounter, nCasterLvl, oPC));
        }
}
        
        