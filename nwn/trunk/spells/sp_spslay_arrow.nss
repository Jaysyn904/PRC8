//::///////////////////////////////////////////////
//:: Name      Spellslayer Arrow
//:: FileName  sp_spslay_arrow.nss
//:://////////////////////////////////////////////
/**@file Spellslayer Arrow
Transmutation
Level: Assassin 2, ranger 2
Components: V, S, M
Casting Time: 1 swift action
Range: Long
Target: One creature
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

As you cast this spell, your fire a masterwork or 
magical arrow or bolt, and transform it into a glowing
missile that destabilizes other forms of magic.In 
addition to dealing normal damage, a spellslayer arrow
deals an extra 1d4 points of damage for the highest level
spell currently in effect on the target. 

Material Component: Masterwork arrow or bolt.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_craft_inc"
#include "prc_inc_combat"

int GetHighestSpellLevel(object oTarget);

void main()
{
       if(!X2PreSpellCastCode()) return;

       PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

       object oPC = OBJECT_SELF;
       object oTarget = PRCGetSpellTargetObject();
       int nCasterLvl = PRCGetCasterLevel(oPC);
       object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
       int nType = GetBaseItemType(oWeap);
       object oAmmo;
       int nDam;
       effect eVis;

       //Has to be a bow of some sort
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
               SendMessageToPC(oPC, "Invalid ammo type.");
               return;
       }

       //The meat
       PerformAttack(oTarget, oPC, eVis);

       //if hit
       if(GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
       {
               if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
               {
                       int nHighest = GetHighestSpellLevel(oTarget);
                       nDam = d4(nHighest);
                       nDam += SpellDamagePerDice(oPC, nHighest);
                       ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
               }
       }

       PRCSetSchool();
}

int GetHighestSpellLevel(object oTarget)
{
        effect eTest = GetFirstEffect(oTarget);
        int nMax = 1;
        
        while(GetIsEffectValid(eTest))
        {
                int nSpell = GetEffectSpellId(eTest);
                int nSpellLevel = StringToInt(Get2DACache("spells", "Innate", nSpell)); 
                
                if(nSpellLevel > nMax) nMax = nSpellLevel;
                                
                eTest = GetNextEffect(oTarget);
        }
        
        return nMax;
}