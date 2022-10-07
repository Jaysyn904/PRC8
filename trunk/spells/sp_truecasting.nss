//::///////////////////////////////////////////////
//:: True Casting
//:: sp_truecasting.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
+10 spell penetration bonus for 9 seconds.
*/
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_alterations"
#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oCaster = OBJECT_SELF;
    int CasterLvl = PRCGetCasterLevel(oCaster);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);


    // * determine the damage bonus to apply
    //effect eSP = (SetLocalInt(oCaster, "TrueCastingSpell", 1) && DelayCommand(9.0,DeleteLocalInt(oCaster, "TrueCastingSpell"));


    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    //effect eLink = eSP;
    //eLink = EffectLinkEffects(eLink, eDur);

    //Fire spell cast at event for target
    SignalEvent(oCaster, EventSpellCastAt(OBJECT_SELF, SPELL_TRUE_CASTING, FALSE));
    //Apply VFX impact and bonus effects
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, 9.0,TRUE,-1,CasterLvl);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}

