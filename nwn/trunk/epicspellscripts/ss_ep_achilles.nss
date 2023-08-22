//::///////////////////////////////////////////////
//:: Achille's Heel
//:: tm_s0_epachilles.nss
//:://////////////////////////////////////////////
/*
    Grants the caster immunity to all spells level 9 and lower
    at the price of CON:  dropping to 3.
*/
//:://////////////////////////////////////////////
//:: Created By: Nron Ksr
//:: Created On: March 9, 2004
//:://////////////////////////////////////////////

/*
    March 17, 2004- Boneshank - added RunHeel() func to keep CON penalty
*/
#include "prc_alterations"
#include "inc_epicspells"
#include "inc_dispel"
//#include "x2_inc_spellhook"

void RunHeel(object oTarget, int nDuration);

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_ACHHEEL))
    {
        //Declare major variables
        object oPC = OBJECT_SELF;
        effect eVis = EffectVisualEffect( VFX_DUR_SPELLTURNING );
        effect eVis2 = EffectVisualEffect( VFX_DUR_GLOBE_INVULNERABILITY );
        effect eDur = EffectVisualEffect( VFX_DUR_CESSATE_NEGATIVE );
        int nDuration = 20;

        //Link Effects
    //    effect eAbsorb = EffectSpellLevelAbsortption( 9, 0, SPELL_SCHOOL_GENERAL );
        effect eAbsorb = EffectSpellImmunity( SPELL_ALL_SPELLS );
        effect eLink = EffectLinkEffects( eVis, eAbsorb );
        eLink = EffectLinkEffects( eLink, eVis2 );
        eLink = EffectLinkEffects( eLink, eDur );

        //Fire cast spell at event for the specified target
    //    SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellID(), FALSE) );
        SignalEvent(oPC,
            EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_SPELL_MANTLE, FALSE));
        //Apply the VFX impact and effects

        // * Can not be dispelled
        eLink = ExtraordinaryEffect(eLink);

        SPApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink,
            oPC, RoundsToSeconds(nDuration), TRUE, -1, GetTotalCastingLevel(OBJECT_SELF) );
        RunHeel(oPC, nDuration);
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

void RunHeel(object oTarget, int nDuration)
{
    int nPen = GetAbilityScore(oTarget, ABILITY_CONSTITUTION) - 3;
    effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, nPen);
    if (nDuration > 0)
    {
        UnequipAnyImmunityItems(oTarget, IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN);
        DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,
            eCon, oTarget, 6.0, TRUE, -1, GetTotalCastingLevel(OBJECT_SELF)));
        nDuration -= 1;
        DelayCommand(6.0, RunHeel(oTarget, nDuration));
    }
}
