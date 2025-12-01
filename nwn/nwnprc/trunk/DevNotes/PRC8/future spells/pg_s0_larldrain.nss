//::///////////////////////////////////////////////
//:: Sihlbrane's Grove
//:: Larloch's Minor Drain
//:: 00_S0_LARLDRAIN
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Yaballa
//:: Created On: 7/9/2003
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "pg_spell_CONST"
#include "x2_inc_spellhook"
#include "prc_inc_spells"

void main()
{

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook


    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDamage = d4();

    if(nMetaMagic == METAMAGIC_MAXIMIZE) {
        nDamage = 4; }
    else if(nMetaMagic == METAMAGIC_EMPOWER) {
        nDamage = nDamage + (nDamage/2); }
    effect eHeal = EffectTemporaryHitpoints(nDamage);
    effect eRay = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LARLOCHS_MINOR_DRAIN));
        if(!PRCDoResistSpell(OBJECT_SELF, oTarget, 1))
        {
            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
            DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHeal, OBJECT_SELF, HoursToSeconds(1)));
            DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_EVIL), oTarget));
            DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_HEAL), OBJECT_SELF));
        }
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7f);
}

