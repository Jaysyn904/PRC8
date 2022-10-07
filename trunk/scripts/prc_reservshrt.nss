//Spell script for reserve feat ranged abilities
//prc_reservshrt
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    int nSpellID = PRCGetSpellId();
    int bSave = FALSE;

    effect eEffect, eEffectSave, eVis, eVisFail;

    int nBonus, nDuration, nDC, nSaveType, nMissChance, nRace, nShaken;
    int nPartial = 0;

    //Define individual spell parameters
    switch (nSpellID)
    {
        case SPELL_PROTECTIVE_WARD:
        {
            nBonus = GetLocalInt(oPC, "ProtectiveWardBonus");
            nDuration = 1;
            nPartial = 0;
            
            eEffect = EffectACIncrease(nBonus, AC_DODGE_BONUS);
            eEffect = SupernaturalEffect(eEffect);
            eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);

            if (nBonus == 0) 
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }
            break;
        }

        case SPELL_SHADOW_VEIL:
        {
            nBonus = GetLocalInt(oPC, "ShadowVeilBonus");
            nDuration = 1;
            bSave = TRUE;
            nSaveType = SAVING_THROW_WILL;
            nDC = 10 + nBonus + GetDCAbilityModForClass(GetPrimarySpellcastingClass(oPC), oPC);
            
            eEffect = EffectBlindness();
            eEffect = SupernaturalEffect(eEffect);
	        eVisFail = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);

            if (nBonus == 0) 
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }
            break;
        }

        case SPELL_TOUCH_OF_DISTRACTION:
        {
            nBonus = GetLocalInt(oPC, "TouchOfDistractionBonus");
            nDuration = 1;
            
            eEffect = EffectAttackDecrease(2);
            eEffect = SupernaturalEffect(eEffect);
	        eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);

            if (nBonus == 0) 
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }

            SetLocalInt(oTarget, "HasTouchOfDistraction", TRUE);
            DelayCommand(RoundsToSeconds(nBonus), DeleteLocalInt(oTarget, "HasTouchOfDistraction"));
            break;
        }

        case SPELL_UMBRAL_SHROUD:
        {
            nBonus = GetLocalInt(oPC, "UmbralShroudBonus");
            nMissChance = nBonus*5;
            nDuration = 1;
            bSave = TRUE;
            nSaveType = SAVING_THROW_WILL;
            nDC = 10 + nBonus + GetDCAbilityModForClass(GetPrimarySpellcastingClass(oPC), oPC);
            nRace = MyPRCGetRacialType(oTarget);
            
            eEffect = EffectMissChance(nMissChance);
            eEffect = SupernaturalEffect(eEffect);
	        eVisFail = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);

            if (nBonus == 0) 
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }

            if (GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS) || (nRace == RACIAL_TYPE_OOZE))
            {
                FloatingTextStringOnCreature("The creature is immune to Umbral Shroud", oPC, FALSE);
                return;
            }
            break;
        }

        case SPELL_CHARNEL_MIASMA:
        {
            nBonus = GetLocalInt(oPC, "CharnelMiasmaBonus");
            nDuration = 10;
            bSave = TRUE;
            nSaveType = SAVING_THROW_WILL;
            nDC = 10 + nBonus + GetDCAbilityModForClass(GetPrimarySpellcastingClass(oPC), oPC);
            nShaken = GetIsShaken(oTarget);
            nPartial = 1;
            
            if (nShaken == FALSE)
            {
                eEffect = EffectShaken();
                eEffect = SupernaturalEffect(eEffect);
            }
            else if (nShaken == TRUE)
            {
                eEffect = EffectFrightened();
                eEffect = SupernaturalEffect(eEffect);
            }
	        eVisFail = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

            if (nBonus == 0)
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }

            if (GetLocalInt(oTarget, "CharnelMiasmaSaved") == TRUE)
            {
                FloatingTextStringOnCreature("This target cannot be affected by Charnel Miasma again for 24 hours", oPC, FALSE);
                return;
            }
            break;
        }

        case SPELL_DROWNING_GLANCE:
        {
            nBonus = GetLocalInt(oPC, "DrowningGlanceBonus");
            nDuration = 1;
            bSave = TRUE;
            nSaveType = SAVING_THROW_FORT;
            nDC = 10 + nBonus + GetDCAbilityModForClass(GetPrimarySpellcastingClass(oPC), oPC);
            nPartial = 1;
            nRace = MyPRCGetRacialType(oTarget);
            
            eEffect = EffectExhausted();
            eEffect = SupernaturalEffect(eEffect);
            eEffectSave = EffectFatigue();
            eEffectSave = SupernaturalEffect(eEffectSave);
            eVis = EffectVisualEffect(VFX_IMP_FROST_S);
	        eVisFail = EffectVisualEffect(VFX_IMP_FROST_S);

            if (nBonus == 0)
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }

            if (GetLocalInt(oTarget, "HasDrowningGlance") == TRUE)
            {
                FloatingTextStringOnCreature("This target cannot be affected by Drowning Glance again for 24 hours", oPC, FALSE);
                return;
            }

            if ((nRace == RACIAL_TYPE_CONSTRUCT) || (nRace == RACIAL_TYPE_OOZE) || (nRace == RACIAL_TYPE_ELEMENTAL) || (nRace == RACIAL_TYPE_UNDEAD))
            {
                FloatingTextStringOnCreature("The creature is immune to Drowning Glance", oPC, FALSE);
                return;
            }
            break;
        }
    }

    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        SignalEvent(oTarget, EventSpellCastAt(oPC, nSpellID, TRUE));

        if (bSave && !PRCMySavingThrow(nSaveType, oTarget, nDC, SAVING_THROW_TYPE_NONE))
        {
            //Remove existing spell effects to prevent stacking
            GZPRCRemoveSpellEffects(nSpellID, oTarget, FALSE);

            //Apply Effects
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisFail, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, RoundsToSeconds(nDuration));

            if (nSpellID == SPELL_DROWNING_GLANCE)
            {
                SetLocalInt(oTarget, "HasDrowningGlance", TRUE);
                DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, "HasDrowningGlance"));
            }
        }
        else if (nPartial == 1)
        {
            //Add partial effects on made save here
            if (nSpellID == SPELL_DROWNING_GLANCE)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffectSave, oTarget, RoundsToSeconds(nDuration));
                SetLocalInt(oTarget, "HasDrowningGlance", TRUE);
                DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, "HasDrowningGlance"));
            }

            //Set preventers if needed
            if (nSpellID == SPELL_CHARNEL_MIASMA)
            {
                SetLocalInt(oTarget, "CharnelMiasmaSaved", TRUE);
                DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, "CharnelMiasmaSaved"));
            }
        }
        else if (bSave == FALSE)
        {
            //Remove existing spell effects to prevent stacking
            GZPRCRemoveSpellEffects(nSpellID, oTarget, FALSE);

            //Apply effects
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, RoundsToSeconds(nDuration));
        }
    }
}