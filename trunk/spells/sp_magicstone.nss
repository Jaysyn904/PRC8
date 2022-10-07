//::///////////////////////////////////////////////
//:: Magic Stone
//:: sp_magicstone.nss
//:://////////////////////////////////////////////
/*
Transmutation
Level:            Clr 1, Drd 1, Earth 1
Components:       V, S, DF
Casting Time:     1 standard action
Range:            Touch
Targets:          Up to three pebbles touched
Duration:         30 minutes or until discharged
Saving Throw:     Will negates (harmless, object)
Spell Resistance: Yes (harmless, object)


You transmute as many as three pebbles, which can
be no larger than sling bullets, so that they
strike with great force when thrown or slung. If
hurled, they have a range increment of 20 feet. If
slung, treat them as sling bullets (range
increment 50 feet). The spell gives them a +1
enhancement bonus on attack and damage rolls. The
user of the stones makes a normal ranged attack.
Each stone that hits deals 1d6+1 points of damage
(including the spell’s enhancement bonus), or
2d6+2 points against undead.

*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_alterations"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = TurnsToSeconds(30);
    object oStone = CreateItemOnObject("magicstone", oCaster, 3);

    itemproperty ipEnhanceBonus     = ItemPropertyEnhancementBonus(1);
    itemproperty ipDamageBonus      = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6);
    itemproperty ipUndEnhanceBonus  = ItemPropertyEnhancementBonusVsRace(RACIAL_TYPE_UNDEAD, 2);
    itemproperty ipUndDamageBonus   = ItemPropertyDamageBonusVsRace(RACIAL_TYPE_UNDEAD, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6);

    if(CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
        fDuration *= 2; //Duration is +100%

    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_MAGIC_STONE, FALSE));

    if(GetIsObjectValid(oStone)){
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipEnhanceBonus, oStone, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipDamageBonus, oStone, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipUndEnhanceBonus, oStone, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipUndDamageBonus, oStone, fDuration);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL), oStone, fDuration);
    }

    PRCSetSchool();
}

