/*
Planetary Healing for Gaia (Share 1 point at a time / Recall all points;
controlled by PRC_GAIA_PLANETARY_HEALING_NERF:
  0 = everyone with >= 1 point gets NWN Troll regeneration overcome by Fire & Acid
  1 = Option 1a: Troll regeneration stays on Binder down to 1 point, or moves to a single ally if all points are transferred to that ally
  2 = Fast healing only)
*/
#include "bnd_inc_bndfunc"

void RegisterGaiaSharedAlly(object oBinder, object oAlly)
{
    int nCount = GetLocalInt(oBinder, "GaiaSharedAllyCount");
    int i;
    for (i = 0; i < nCount; i++)
    {
        if (GetLocalObject(oBinder, "GaiaSharedAlly_" + IntToString(i)) == oAlly)
            return;
    }
    SetLocalObject(oBinder, "GaiaSharedAlly_" + IntToString(nCount), oAlly);
    SetLocalInt(oBinder, "GaiaSharedAllyCount", nCount + 1);
}

void main()
{
    object oBinder = OBJECT_SELF;
    int nSpellId = PRCGetSpellId();
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_GAIA);
    int nMaxRegen = GetLocalInt(oBinder, "GaiaPlanetaryRegenMax");
    if (nMaxRegen <= 0)
    {
        nMaxRegen = PRCMax(1, nBinderLevel / 4);
        SetLocalInt(oBinder, "GaiaPlanetaryRegenMax", nMaxRegen);
        SetLocalInt(oBinder, "GaiaPlanetaryRegen", nMaxRegen);
    }

    if (nSpellId == VESTIGE_GAIA_PLANET_SHARE_SPELL)
    {
        object oTarget = PRCGetSpellTargetObject();
        if (!GetIsObjectValid(oTarget) || oTarget == oBinder)
        {
            FloatingTextStringOnCreature("Select an ally to share 1 point of Gaia's Planetary Healing with.", oBinder, FALSE);
            return;
        }
        if (!PRCGetIsAliveCreature(oTarget))
        {
            FloatingTextStringOnCreature("Planetary Healing can only be shared with living creatures.", oBinder, FALSE);
            return;
        }
        int nSelfPts = GetLocalInt(oBinder, "GaiaPlanetaryRegenSelf");
        if (nSelfPts <= 0)
        {
            FloatingTextStringOnCreature("You have no remaining Planetary Healing points to share (use Recall to reclaim them).", oBinder, FALSE);
            return;
        }

        // Transfer 1 point of regeneration from oBinder to oTarget
        nSelfPts -= 1;
        SetLocalInt(oBinder, "GaiaPlanetaryRegenSelf", nSelfPts);
        SetCreatureGaiaRegenEff(oBinder, nSelfPts, "GaiaPlanetaryRegenEff", HoursToSeconds(24));

        int nAllyPts = GetLocalInt(oTarget, "GaiaSharedRegenPoints") + 1;
        SetLocalInt(oTarget, "GaiaSharedRegenPoints", nAllyPts);
        SetLocalObject(oTarget, "GaiaRegenSourceBinder", oBinder);
        RegisterGaiaSharedAlly(oBinder, oTarget);
        SetLocalObject(oBinder, "GaiaSharedRegenAlly", oTarget);

        SetCreatureGaiaRegenEff(oTarget, nAllyPts, "GaiaSharedRegenEff", HoursToSeconds(24));
        ReconcileGaiaTrollImmunity(oBinder);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G), oTarget);
        FloatingTextStringOnCreature(
            "Shared 1 point of Planetary Healing with " + GetName(oTarget) +
            " (Ally: " + IntToString(nAllyPts) + " regen/round; You: " + IntToString(nSelfPts) + "/" + IntToString(nMaxRegen) + " regen/round).",
            oBinder, FALSE
        );
    }
    else
    {
        // Recall: immediate action that reclaims all shared points from all allies at once
        int nCount = GetLocalInt(oBinder, "GaiaSharedAllyCount");
        int i;
        for (i = 0; i < nCount; i++)
        {
            object oAlly = GetLocalObject(oBinder, "GaiaSharedAlly_" + IntToString(i));
            if (GetIsObjectValid(oAlly))
            {
                SetCreatureGaiaRegenEff(oAlly, 0, "GaiaSharedRegenEff", 0.0f);
                DeleteLocalInt(oAlly, "GaiaSharedRegenPoints");
                DeleteLocalInt(oAlly, "GaiaRegenActive");
                DeleteLocalObject(oAlly, "GaiaRegenSourceBinder");
                if (!HasAnyBinderImmortalProtection(oAlly))
                    SetImmortal(oAlly, FALSE);
                else
                    SetImmortal(oAlly, TRUE);
            }
            DeleteLocalObject(oBinder, "GaiaSharedAlly_" + IntToString(i));
        }
        DeleteLocalInt(oBinder, "GaiaSharedAllyCount");
        DeleteLocalObject(oBinder, "GaiaSharedRegenAlly");

        SetLocalInt(oBinder, "GaiaPlanetaryRegenSelf", nMaxRegen);
        SetCreatureGaiaRegenEff(oBinder, nMaxRegen, "GaiaPlanetaryRegenEff", HoursToSeconds(24));
        ReconcileGaiaTrollImmunity(oBinder);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_NATURE), oBinder);
        FloatingTextStringOnCreature(
            "Recalled Gaia's Planetary Healing (" + IntToString(nMaxRegen) + " regen/round) to yourself.",
            oBinder, FALSE
        );
    }
}
