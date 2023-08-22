//::///////////////////////////////////////////////
//:: Shield
//:: x0_s0_shield.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Immune to magic Missile
    +4 general AC
    DIFFERENCES: should be +7 against one opponent
    but this cannot be done.
    Duration: 1 turn/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 15, 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_alterations"
#include "x2_inc_spellhook"

void ShieldDuration()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, 1, -1, -1, -1, -1);

   if (GetHasSpellEffect(SPELL_SHADOWSHIELD))
   {
     if ( !GetHasFeat(FEAT_SA_SHIELDSHADOW))
     {
       PRCRemoveSpellEffects(SPELL_SHADOWSHIELD,oCaster,oCaster);
       return;
     }
     else
      DecrementRemainingFeatUses(oCaster,FEAT_SA_SHIELDSHADOW);

     DelayCommand(6.0f,ShieldDuration() );
   }
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
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

   if (GetHasSpellEffect(SPELL_SHADOWSHIELD))
   {
       PRCRemoveSpellEffects(SPELL_SHADOWSHIELD,OBJECT_SELF,OBJECT_SELF);
       IncrementRemainingFeatUses(OBJECT_SELF,FEAT_SA_SHIELDSHADOW);
       return;
   }

    //Declare major variables
    object oTarget = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    int nMetaMagic = PRCGetMetaMagicFeat();

    int nClass = GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT,OBJECT_SELF);

    effect eArmor = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS);
    effect eSpell = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
    effect eSpell2 = EffectSpellImmunity(SPELL_MAJOR_MAGIC_MISSILE);
    effect eConc = EffectConcealment(20, MISS_CHANCE_TYPE_NORMAL);
    effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);

    effect eLink = EffectLinkEffects(eArmor, eDur);
    eLink = EffectLinkEffects(eLink, eSpell);
    eLink = EffectLinkEffects(eLink, eConc);

    if ( nClass>7)
       eLink = EffectLinkEffects(eLink, EffectSpellResistanceIncrease(12+nClass));

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 417, FALSE));

    PRCRemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());

    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eLink), oTarget);

    DelayCommand(6.0f,ShieldDuration() );

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}



