//::///////////////////////////////////////////////
//:: Regenerate Ring / Circle
//:: sp_regen_ring_circle.nss
//:: Jaysyn - PRC8 2025-08-01
//:: 
//:: Group fast healing aura spells
//::///////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));

    object oCaster = OBJECT_SELF;
    int nSpellId = PRCGetSpellId();
    int nMetamagic = PRCGetMetaMagicFeat();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nDuration = 10 + (nCasterLevel / 2);
    int nMaxTargets = nCasterLevel / 2;
    float fMaxDistance = 30.0;
    int nRegenRate = 1;

    if (nSpellId == 9999)
    {
        nRegenRate = 3;
    }

    if (nMetamagic == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }

    location lCaster = GetLocation(oCaster);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fMaxDistance, lCaster, FALSE, OBJECT_TYPE_CREATURE);
    int nCount = 0;

    while (GetIsObjectValid(oTarget) && nCount < nMaxTargets)
    {
        if (!GetIsEnemy(oCaster, oTarget) &&
            GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
            GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
        {
            int nCurrentHP = GetCurrentHitPoints(oTarget);
            int nInitialHP = GetLocalInt(oTarget, "INITIAL_HIT_POINTS");

            if (nCurrentHP > nInitialHP)
            {
                nInitialHP = nCurrentHP;
                SetLocalInt(oTarget, "INITIAL_HIT_POINTS", nInitialHP);
            }

            int nCurrentRegen = GetLocalInt(oTarget, "REGEN_RATE");
            int nExistingDuration = 0;
            int bSameSpell = FALSE;

            effect e = GetFirstEffect(oTarget);
            while (GetIsEffectValid(e))
            {
                if (GetEffectTag(e) == "REGEN_WOUNDS")
                {
                    if (nCurrentRegen == nRegenRate)
                    {
                        bSameSpell = TRUE;
                        nExistingDuration = GetEffectDurationRemaining(e) / 6;
                        if (nRegenRate >= nCurrentRegen) RemoveEffect(oTarget, e);
                        else return;
                    }
                    else if (nRegenRate >= nCurrentRegen)
                    {
                        RemoveEffect(oTarget, e);
                    }
                }
                e = GetNextEffect(oTarget);
            }

            if (bSameSpell)
            {
                nDuration += nExistingDuration;
            }

            SetLocalInt(oTarget, "REGEN_RATE", nRegenRate);
            SetLocalInt(oTarget, "REGEN_WOUNDS_REMAINING", nDuration);

            effect eVis = EffectVisualEffect(1330/* VFX_DUR_BF_IOUN_STONE_GREEN */);
            effect eRegen = EffectRunScript("rs_regen_wounds", "rs_regen_wounds", "rs_regen_wounds", 6.0f, IntToString(nRegenRate));
            eRegen = SetEffectSpellId(eRegen, nSpellId);
            eRegen = EffectLinkEffects(eVis, eRegen);
            eRegen = TagEffect(eRegen, "REGEN_WOUNDS");

            PRCRemoveEffectsFromSpell(oTarget, nSpellId);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oTarget, RoundsToSeconds(nDuration));

            nCount++;
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fMaxDistance, lCaster, FALSE, OBJECT_TYPE_CREATURE);
    }

    PRCSetSchool();
}