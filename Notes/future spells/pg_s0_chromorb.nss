//::///////////////////////////////////////////////
//:: Sihlbrane's Grove
//:: Chromatic Orb
//:: 00_S0_CHROMORB
//:://////////////////////////////////////////////
/*
    This spell creates a 4-inch-diameter sphere
    that can be hurled unerringly to its target.
    The orb's effect depends on the level of the
    wizard:
    A 1st-level sphere inflicts 1d4 damage and blinds
    the target for one round.
    A 2nd-level sphere inflicts 1d6 damage.
    A 3rd-level sphere deals 1d8 damage and burns the
    victim for 1d3 fire damage.
    A 4th-level sphere deals 1d10 damage and blinds
    the target for four rounds.
    A 5th to 6th-level sphere deals 1d12 damage and
    stuns the target for three rounds.
    The 7th+ level sphere deals 2d8 damage and
    paralyzes the victim for 13 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Yaballa
//:: Created On: 5/9/2003
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "pg_spell_CONST"
#include "x2_inc_spellhook"
#include "prc_inc_spells"

void RunWhiteOrb(object oTarget, int nDamage, int nColor);
void RunRedOrb(object oTarget, int nDamage, int nColor);
void RunOrangeOrb(object oTarget, int nDamage, int nDamage2, int nColor);
void RunYellowOrb(object oTarget, int nDamage, int nColor);
void RunGreenOrb(object oTarget, int nDamage, int nColor);
void RunBlackOrb(object oTarget, int nDamage, int nColor);

void main()
{

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

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nHD = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDamage, nDamage2, nColor;
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = (fDist/25.0f);
    float fDelay2, fTime;

    if(nHD < 1) {nHD = 1;}
    switch(nHD)
    {
        case 1: nDamage = d4(); nColor = VFX_DUR_LIGHT_WHITE_20; break;
        case 2: nDamage = d6(); nColor = VFX_DUR_LIGHT_RED_20; break;
        case 3: nDamage = d8(); nDamage2 = d3(); nColor = VFX_DUR_LIGHT_ORANGE_20; break;
        case 4: nDamage = d10(); nColor = VFX_DUR_LIGHT_YELLOW_20; break;
        case 5: case 6: nDamage = d12(); nColor = VFX_DUR_LIGHT_PURPLE_20; break;
        default: nDamage = d8(2); nColor = VFX_DUR_DARKNESS; break;
    }
    if(nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        switch(nHD)
        {
            case 1: nDamage = 4; break;
            case 2: nDamage = 6; break;
            case 3: nDamage = 8; nDamage2 = 3; break;
            case 4: nDamage = 10; break;
            case 5: case 6: nDamage = 12; break;
            default: nDamage = 16; break;
        }
    }
    else if(nMetaMagic == METAMAGIC_EMPOWER) {
        nDamage = nDamage + (nDamage/2); }
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        fTime = fDelay;
        fDelay2 += 0.1f;
        fTime += fDelay2;
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHROMATIC_ORB));
        if(!PRCDoResistSpell(OBJECT_SELF, oTarget, FloatToInt(fDelay)))
        {
            if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
            {
                switch(nHD)
                {
                    case 1: DelayCommand(fTime, RunWhiteOrb(oTarget, nDamage, nColor)); break;
                    case 2: DelayCommand(fTime, RunRedOrb(oTarget, nDamage, nColor)); break;
                    case 3: DelayCommand(fTime, RunOrangeOrb(oTarget, nDamage, nDamage2, nColor)); break;
                    case 4: DelayCommand(fTime, RunYellowOrb(oTarget, nDamage, nColor)); break;
                    case 5: case 6: DelayCommand(fTime, RunGreenOrb(oTarget, nDamage, nColor)); break;
                    default: DelayCommand(fTime, RunBlackOrb(oTarget, nDamage, nColor)); break;
                }
                DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_MAGBLUE), oTarget));
            }
        }
        DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
    }
}

void RunWhiteOrb(object oTarget, int nDamage, int nColor)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BLIND_DEAF_M), oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nColor), oTarget, 3.0f);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage), oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, 6.0f);
}

void RunRedOrb(object oTarget, int nDamage, int nColor)
{
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nColor), oTarget, 3.0f);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage), oTarget);
}

void RunOrangeOrb(object oTarget, int nDamage, int nDamage2, int nColor)
{
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nColor), oTarget, 3.0f);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage), oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage2, DAMAGE_TYPE_FIRE), oTarget);
}

void RunYellowOrb(object oTarget, int nDamage, int nColor)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BLIND_DEAF_M), oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nColor), oTarget, 3.0f);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage), oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, 24.0f);
}

void RunGreenOrb(object oTarget, int nDamage, int nColor)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_STUN), oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nColor), oTarget, 3.0f);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage), oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 18.0f);
}

void RunBlackOrb(object oTarget, int nDamage, int nColor)
{
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PARALYZE_HOLD), oTarget, 78.0f);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nColor), oTarget, 3.0f);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage), oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectParalyze(), oTarget, 78.0f);
}
