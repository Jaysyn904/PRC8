/*
   ----------------
   Eternal Blade
   Blade guide vfx cast

   tob_etbl_bldg.nss
   ----------------

    10 MAR 09 by GC
*/ /** @file

    Adds vfx for blade guide so that is can be removed
    by PRCRemoveEffectsFromSpell()
*/

#include "tob_inc_tobfunc"
#include "tob_inc_recovery"
////#include "prc_alterations"

void main()
{
	object oInitiator = PRCGetSpellTargetObject();//OBJECT_SELF;
	effect eGuide  = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_IOUNSTONE_BLUE));

	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eGuide, oInitiator);//, 0.0f, FALSE, 19313);
	SetLocalInt(oInitiator, "ETBL_BladeGuideVis", TRUE);
}