//::///////////////////////////////////////////////
//:: Name      Foresight
//:: FileName  sp_foresight.nss
//::///////////////////////////////////////////////
/** @file Foresight
Divination
Level:  Drd 9, Knowledge 9, Sor/Wiz 9, Hlr 9
Components:       V, S, M/DF
Casting Time:     1 standard action
Range:            Personal
Target:       See text
Duration:     10 min./level
Saving Throw:     None 
Spell Resistance: No 

This spell grants you a powerful sixth sense in 
relation to yourself or another. Once foresight is 
cast, you receive instantaneous warnings of 
impending danger or harm to the subject of the spell.
You are never surprised or flat-footed. In addition,
the spell gives you a general idea of what action you
might take to best protect yourself and gives you a 
+2 insight bonus to AC and Reflex saves. This insight
bonus is lost whenever you would lose a Dexterity 
bonus to AC.

Arcane Material Component: A hummingbird’s feather. 
**/

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;
    
    PRCSetSchool(SPELL_SCHOOL_DIVINATION);
    
    object oPC = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDur = (600.0f * nCasterLvl);
    
    if(nMetaMagic & METAMAGIC_EXTEND)
    {
        fDur += fDur;
    }
        
    itemproperty iDodge = PRCItemPropertyBonusFeat(FEAT_UNCANNY_DODGE_1);
    effect eLink = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK), EffectACIncrease(2, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL));
    eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 2, SAVING_THROW_TYPE_ALL));
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
    IPSafeAddItemProperty(oArmor, iDodge, fDur);
    
    PRCSetSchool();
}
    
    