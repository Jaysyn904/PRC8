//::///////////////////////////////////////////////
//:: Name      Bloodfreeze Arrow
//:: FileName  sp_bldfrz_arrow.nss
//:://////////////////////////////////////////////
/**@file Bloodfreeze Arrow
Transmutation
Level: Assassin 4, ranger 4, justice of weald and woe 4
Components: V, M
Casting Time: 1 swift action
Range: Long
Target: One creature
Duration: Instantaneous
Saving Throw: Fortitude partial; see text
Spell Resistance: Yes

When you cast this spell, you fire an arrow at the target and transform
the arrow head into blue ice. In addition to taking normal damage from
the missile, the target takes 2d6 points of cold damage and is
paralyzed. A successful Fortitude save negates the paralysis, and
the target can make a new save each round (at the start of the
caster’s turn).

Material Component: Masterwork arrow or bolt.

Author:    Tenjac
Created:   8/22/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void ParaLoop(object oTarget, int nDC, object oPC);

#include "prc_inc_spells"
#include "prc_craft_inc"
#include "prc_add_spell_dc"
#include "prc_inc_combat"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
        object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);                
        int nType = GetBaseItemType(oWeap);
        object oAmmo;
        
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
        
        //Normal Attack
        PerformAttack(oTarget, oPC, eVis);
        
        //if hit
        if(GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
        {
                if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
                {
                		int nDam = d6(2) + SpellDamagePerDice(oPC, 2);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_COLD), oTarget);
                        
                        int nDC = PRCGetSaveDC(oTarget, oPC);
                        
                        //Save
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_COLD))            
                        {
                                //Paralyze
                                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectParalyze(), oTarget);
                                
                                //Start saving loop
                                DelayCommand(RoundsToSeconds(1), ParaLoop(oTarget, nDC, oPC));
                        }
                }
        }
        
        PRCSetSchool();
}

void ParaLoop(object oTarget, int nDC, object oPC)
{
        if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_COLD))
        {
                effect eTest = GetFirstEffect(oTarget);
                while(GetIsEffectValid(eTest))
                {
                        if(GetEffectCreator(eTest) == oPC)
                        {
                                if(GetEffectType(eTest) == EFFECT_TYPE_PARALYZE)
                                {
                                        if(GetEffectSpellId(eTest) == SPELL_BLOODFREEZE_ARROW)
                                        {
                                                RemoveEffect(oTarget, eTest);
                                        }
                                }
                        }
                        eTest = GetNextEffect(oTarget);
                }
        }
        
        else DelayCommand(RoundsToSeconds(1), ParaLoop(oTarget, nDC, oPC));
}        