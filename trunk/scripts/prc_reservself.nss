//Spell script for reserve feats cast on self
//prc_reservself
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

void RemoveClaws(object oPC, string sResRef)
{
    object oNatWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
    object oNatWeapon2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
    object oNatWeapon3 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
    string sResRef1 = GetResRef(oNatWeapon1);
    string sResRef2 = GetResRef(oNatWeapon2);
    string sResRef3 = GetResRef(oNatWeapon3);

    if (sResRef1 == sResRef)
        DestroyObject(oNatWeapon1);
    if (sResRef2 == sResRef)
        DestroyObject(oNatWeapon2);
    if (sResRef3 == sResRef)
        DestroyObject(oNatWeapon3);
}

void main()
{
    object oPC = OBJECT_SELF;

    int nSpellID = PRCGetSpellId();
    int nDuration, nHD, nBonus, nSize;

    string sResRef;

    effect eEffect, eVis;

    //Define individual spell parameters
    switch (nSpellID)
    {
        case SPELL_SUNLIGHT_EYES:
        {
            nBonus = GetLocalInt(oPC, "SunlightEyesBonus");
            nDuration = 1;
            
            eEffect = EffectUltravision();
            eEffect = SupernaturalEffect(eEffect);
            eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);

            if (nBonus == 0) 
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }
            break;
        }

        case SPELL_MINOR_SHAPESHIFT_MIGHT:
        {
            nBonus = GetLocalInt(oPC, "MinorShapeshiftBonus");
            nDuration = nBonus;
            
            eEffect = EffectDamageIncrease(2, DAMAGE_TYPE_SLASHING);
            eEffect = SupernaturalEffect(eEffect);
            eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);

            if (nBonus == 0) 
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }

            //Remove Shapeshift effects as you can only have one
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_MIGHT, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_MOBILITY, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_SAVAGERY, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_SPEED, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_VIGOR, oPC, FALSE);
            break;
        }

        case SPELL_MINOR_SHAPESHIFT_MOBILITY:
        {
            nBonus = GetLocalInt(oPC, "MinorShapeshiftBonus");
            nDuration = nBonus;
            
            eEffect = EffectSkillIncrease(SKILL_CLIMB, 2);
            eEffect = EffectLinkEffects(EffectSkillIncrease(SKILL_BALANCE, 2), eEffect);
            eEffect = EffectLinkEffects(EffectSkillIncrease(SKILL_JUMP, 2), eEffect);
            eEffect = SupernaturalEffect(eEffect);
            eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);

            if (nBonus == 0) 
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }

            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_MIGHT, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_MOBILITY, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_SAVAGERY, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_SPEED, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_VIGOR, oPC, FALSE);
            break;
        }

        case SPELL_MINOR_SHAPESHIFT_SAVAGERY:
        {
            nBonus = GetLocalInt(oPC, "MinorShapeshiftBonus");
            nDuration = nBonus;
            
            eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);

            if (nBonus == 0)
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }

            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_MIGHT, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_MOBILITY, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_SAVAGERY, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_SPEED, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_VIGOR, oPC, FALSE);
            break;
        }

        case SPELL_MINOR_SHAPESHIFT_SPEED:
        {
            nBonus = GetLocalInt(oPC, "MinorShapeshiftBonus");
            nDuration = nBonus;
            
            eEffect = EffectMovementSpeedIncrease(15);
            eEffect = SupernaturalEffect(eEffect);
            eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);

            if (nBonus == 0) 
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }

            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_MIGHT, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_MOBILITY, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_SAVAGERY, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_SPEED, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_VIGOR, oPC, FALSE);
            break;
        }

        case SPELL_MINOR_SHAPESHIFT_VIGOR:
        {
            nBonus = GetLocalInt(oPC, "MinorShapeshiftBonus");
            nDuration = nBonus;
            nHD = GetHitDice(oPC);
            
            eEffect = EffectTemporaryHitpoints(nHD);
            eEffect = SupernaturalEffect(eEffect);
            eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);

            if (nBonus == 0) 
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }

            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_MIGHT, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_MOBILITY, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_SAVAGERY, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_SPEED, oPC, FALSE);
            GZPRCRemoveSpellEffects(SPELL_MINOR_SHAPESHIFT_VIGOR, oPC, FALSE);
            break;
        }
    }

    if (nSpellID != SPELL_MINOR_SHAPESHIFT_SAVAGERY)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, RoundsToSeconds(nDuration));
    }
    else
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
        sResRef = "prc_claw_1d6l_";
        // Gets up to the proper size
        nSize = PRCGetCreatureSize(oPC) + 1;
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2);
        DelayCommand(RoundsToSeconds(nBonus), RemoveNaturalPrimaryWeapon(oPC, sResRef));
        DelayCommand((RoundsToSeconds(nBonus) + 0.2), RemoveClaws(oPC, sResRef));
    }
}