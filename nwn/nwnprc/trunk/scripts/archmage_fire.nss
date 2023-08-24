#include "x2_inc_spellhook"
#include "prc_inc_sp_tch"

/*
 * This is the spellhook code, called when the Arcane Fire feat is activated
 * Turns the spell into an arcane fire
 */
void main()
{
    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = GetLocalObject(OBJECT_SELF, "arcane_fire_target");
    int nCasterLvl = GetLevelByClass(CLASS_TYPE_ARCHMAGE, OBJECT_SELF);
    int nDamage = 0;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCnt;
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2, fTime;
    string nSpellLevel = lookup_spell_level(PRCGetSpellId());

    /* Whatever happens next we must restore the hook */
    PRCSetUserSpecificSpellScript(GetLocalString(OBJECT_SELF, "archmage_save_overridespellscript"));

    /* Tell to not execute the original spell */
    PRCSetUserSpecificSpellScriptFinished();

    /* Allow to use it once again */
    SetLocalInt(OBJECT_SELF, "arcane_fire_active", 0);

    /* Paranoia -- should never happen */
    if (!GetHasFeat(FEAT_ARCANE_FIRE, OBJECT_SELF)) return;

    /* Only wizard/sorc spells */
    if (nSpellLevel == "")
    {
        FloatingTextStringOnCreature("Arcane Fire can only consume arcane spells.", OBJECT_SELF, FALSE);
        return;
    }

    /* No item casting */
    if (GetIsObjectValid(GetSpellCastItem()))
    {
        FloatingTextStringOnCreature("Arcane Fire may not be used with scrolls.", OBJECT_SELF, FALSE);
        return;
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_MISSILE));

        //Make ranged touch attack check
        if (PRCDoRangedTouchAttack(oTarget))
        {
                //Roll damage
                int nDam = d6(nCasterLvl + StringToInt(nSpellLevel));

                fTime = fDelay;
                fDelay2 += 0.1;
                fTime += fDelay2;

                //Set damage effect
                effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
                //Apply the MIRV and damage effect
                DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
                DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
         }
         else
         {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
         }
     }
}
