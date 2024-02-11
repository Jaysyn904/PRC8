/*::///////////////////////////////////////////////
//:: Name      Resistance
//:: FileName  nw_s0_resis.nss
//:://////////////////////////////////////////////

Resistance
Abjuration
Level:            Brd 0, Clr 0, Drd 0, Pal 1, Sor/Wiz 0
Components:       V, S, M/DF
Casting Time:     1 standard action
Range:            Touch
Target:           Creature touched
Duration:         2 Turns
Saving Throw:     Will negates (harmless)
Spell Resistance: Yes (harmless)

You imbue the subject with magical en-ergy that protects it from harm, granting it a +1 resistance bonus on saves.
Resistance can be made permanent with a permanency spell.
Arcane Material Component: A miniature cloak.


Greater Resistance
Abjuration
Level:            Bard 4, cleric 4, druid 4, sorcerer/wizard 4
Components:       V, S, M/DF
Casting Time:     1 standard action
Range:            Touch
Target:           Creature touched
Duration:         24 hours
Saving Throw:     Will negates (harmless)
Spell Resistance: Yes (harmless)

Just as you touch the spell’s subject, a feeling of peace and watchful guardianship fills your being.
This spell functions like resistance (PH 272), except as noted here. You grant the subject a +3 resistance bonus on saves.
Arcane Material Component: A miniature cloak.


Superior Resistance
Abjuration
Level:            Bard 6, cleric 6, druid 6, sorcerer/wizard 6
Components:       V, S, M/DF
Casting Time:     1 standard action
Range:            Touch
Target:           Creature touched
Duration:         24 hours
Saving Throw:     Will negates (harmless)
Spell Resistance: Yes (harmless)

As you finish casting the spell, you feel imbued with the feeling that something greater than yourself is protecting you. When you touch your intended subject and release the spell, the feeling disappears.
This spell functions like resistance (PH 272), except as noted here. You grant the subject a +6 resistance bonus on saves.
Arcane Material Component: A miniature cloak.

//:://////////////////////////////////////////////
//:: Sources:
//:: Resistance          - Player's Handbook
//:: Greater Resistance  - Spell Compendium
//:: Superior Resistance - Spell Compendium
//:: Note: PnP duration of Resistance is 1 min
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan
//:: Created On: Jan 12, 2001
//::*/////////////////////////////////////////////
#include "prc_sp_func"

int DoSpell(object oCaster, object oTarget)
{
    int nSpellID = PRCGetSpellId();
    int nBonus;
    float fDuration;
    switch(nSpellID)
    {
        case SPELL_RESISTANCE:          nBonus = 1; fDuration = TurnsToSeconds(2);  break;
        case SPELL_GREATER_RESISTANCE:  nBonus = 3; fDuration = HoursToSeconds(24); break;
        case SPELL_SUPERIOR_RESISTANCE: nBonus = 6; fDuration = HoursToSeconds(24); break;
    }

    if(PRCGetMetaMagicFeat() & METAMAGIC_EXTEND)
        fDuration *= 2;

    effect eLink = EffectLinkEffects(EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));

    //Apply the bonus effect and VFX impact
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, nSpellID);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_HOLY), oTarget);

    return TRUE;
}

void main()
{
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);
    if(!X2PreSpellCastCode()) return;
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}