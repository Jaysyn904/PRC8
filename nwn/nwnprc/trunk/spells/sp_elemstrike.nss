//::///////////////////////////////////////////////
//:: Elemental Strike
//:: sp_elemstrike.nss
//:://////////////////////////////////////////////
/*
Evocation [see text]
Level:            Clr 5, Drd 4, Fiery Wrath 5, Tmp 5
Components:       V, S, DF
Casting Time:     1 standard action
Range:            Medium (100 ft. + 10 ft./level)
Area:             Cylinder (10-ft. radius, 40 ft. high)
Duration:         Instantaneous
Saving Throw:     Reflex half
Spell Resistance: Yes

A column of divine and elemental energy shoots downward
from the point you designate, striking those caught
beneath it with the fury of your element.

An elemental strike produces a vertical column. The
spell deals 1d6 points of damage per caster level
(maximum 15d6). Half the damage is energy damage, but
the other half results directly from divine power and is
therefore not subject to being reduced by resistance to
energy–based attacks. The type of energy damage, as well
as the energy descriptor of the spell, is chosen at the time
of casting. Clerics must choose the energy type that
corresponds to their patron element.

Air: Sonic
Earth: Acid
Fire: Fire
Magma: Fire
Rain: Electricity
Silt: Acid
Sun: Fire
Water: Cold

This spell’s subtype is the same as the type of energy
you cast.

Note: This spell replaces the flame strike spell from the
Player’s Handbook.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nSpellID = PRCGetSpellId();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nDice = min(15, nCasterLvl);
    int nPenter = nCasterLvl + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDamageType, nImpVfx, nDamage, nDamage2;
    effect eStrike;

    switch(nSpellID)
    {
        case SPELL_ELEMENTAL_STRIKE_ACID:{
            nDamageType = DAMAGE_TYPE_ACID;
            nImpVfx = VFX_IMP_ACID_S;
            eStrike = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_ACID);
            break;}
        case SPELL_ELEMENTAL_STRIKE_COLD:{
            nDamageType = DAMAGE_TYPE_COLD;
            nImpVfx = VFX_IMP_FROST_S;
            eStrike = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_COLD);
            break;}
        case SPELL_ELEMENTAL_STRIKE_ELECRICITY:{
            nDamageType = DAMAGE_TYPE_ELECTRICAL;
            nImpVfx = VFX_IMP_LIGHTNING_S;
            eStrike = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
            break;}
        case SPELL_ELEMENTAL_STRIKE_SONIC:{
            nDamageType = DAMAGE_TYPE_SONIC;
            nImpVfx = VFX_IMP_SONIC;
            eStrike = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_SONIC);
            break;}
        default:{
            nDamageType = DAMAGE_TYPE_FIRE;
            nImpVfx = VFX_IMP_FLAME_S;
            eStrike = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_FIRE);
            break;}
    }

    int EleDmg = ChangedElementalDamage(oCaster, nDamageType);
    int nSaveType = ChangedSaveType(EleDmg);
    effect eVis = EffectVisualEffect(nImpVfx);
    effect eHoly;
    effect eElem;

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_PLACEABLE|OBJECT_TYPE_DOOR);
    //Apply the location impact visual to the caster location instead of caster target creature.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, lTarget);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID));
            //Make SR check, and appropriate saving throw(s).
            if(!PRCDoResistSpell(oCaster, oTarget, nPenter, 0.6))
            {
                int nDC = PRCGetSaveDC(oTarget, oCaster);
                nDamage = d6(nDice);
                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                    nDamage = 6 * nDice;
                if(nMetaMagic & METAMAGIC_EMPOWER)
                    nDamage += (nDamage/2);
                // Acid Sheath adds +1 damage per die to acid descriptor spells
                if (GetHasDescriptor(nSpellID, DESCRIPTOR_ACID) && GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oCaster))
                	nDamage += nDice;              
                nDamage += SpellDamagePerDice(oCaster, nDice);	
                //Adjust the damage based on Reflex Save, Evasion and Improved Evasion
                nDamage2 = PRCGetReflexAdjustedDamage(nDamage/2, oTarget, (nDC), SAVING_THROW_TYPE_DIVINE);
                nDamage = PRCGetReflexAdjustedDamage(nDamage/2, oTarget, (nDC), nSaveType);
                //Make a faction check so that only enemies receieve the full brunt of the damage.
                if(!GetIsFriend(oTarget))
                {
                    eHoly = PRCEffectDamage(oTarget, nDamage2, DAMAGE_TYPE_DIVINE);
                    DelayCommand(0.6, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHoly, oTarget));
                }
                // Apply effects to the currently selected target.
                eElem = PRCEffectDamage(oTarget, nDamage, EleDmg);
                if(nDamage > 0)
                {
                    DelayCommand(0.6, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eElem, oTarget));
                    DelayCommand(0.6, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_PLACEABLE|OBJECT_TYPE_DOOR);
    }

    PRCSetSchool();
}
