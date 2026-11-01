/*
Ultimate Sacrifice for Zuriel
As an immediate action, you can direct the damage dealt to a visible ally by a single attack,
spell, or ability onto yourself instead. The damage dealt to your ally is transferred to you
even if it kills you.
*/
#include "bnd_inc_bndfunc"

void ClearAllyUltimateSacrificeWard(object oAlly)
{
    if (!GetIsObjectValid(oAlly)) return;
    effect eOld = GetFirstEffect(oAlly);
    while (GetIsEffectValid(eOld))
    {
        if (GetEffectTag(eOld) == "ZurielUltimateSacrificeEff")
            RemoveEffect(oAlly, eOld);
        eOld = GetNextEffect(oAlly);
    }
    DeleteLocalObject(oAlly, "ZurielSacrificeBinder");
    int bKeepImmortal = GetLocalInt(oAlly, "ZurielSacPrevImmortal")
        || (GetLocalInt(oAlly, "GaiaRegenActive") && !GetLocalInt(oAlly, "GaiaRegenFireAcidLock") && GetPRCSwitch(PRC_GAIA_PLANETARY_HEALING_NERF) < 2)
        || HasActiveDelayDeathImmortal(oAlly);
    DeleteLocalInt(oAlly, "ZurielSacPrevImmortal");
    if (!bKeepImmortal)
        SetImmortal(oAlly, FALSE);
}

void main()
{
    object oBinder = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    // Canonical rule: must target a visible ally other than yourself
    if (!GetIsObjectValid(oTarget)
        || oTarget == oBinder
        || !GetIsFriend(oTarget, oBinder)
        || !GetObjectSeen(oTarget, oBinder))
    {
        FloatingTextStringOnCreature("Ultimate Sacrifice: You must target a visible ally other than yourself.", oBinder, FALSE);
        return;
    }

    // Clear any previous Ultimate Sacrifice target link from this Binder
    object oOldTarget = GetLocalObject(oBinder, "ZurielUltimateSacrificeTarget");
    if (GetIsObjectValid(oOldTarget))
    {
        ClearAllyUltimateSacrificeWard(oOldTarget);
    }

    // Also clear if another Binder had warded this same ally
    object oPrevBinder = GetLocalObject(oTarget, "ZurielSacrificeBinder");
    if (GetIsObjectValid(oPrevBinder) && oPrevBinder != oBinder)
    {
        DeleteLocalObject(oPrevBinder, "ZurielUltimateSacrificeTarget");
        ClearAllyUltimateSacrificeWard(oTarget);
    }

    effect eWard = TagEffect(SupernaturalEffect(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE)), "ZurielUltimateSacrificeEff");
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWard, oTarget, HoursToSeconds(24));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oTarget);

    SetLocalInt(oTarget, "ZurielSacPrevImmortal", GetImmortal(oTarget));
    SetImmortal(oTarget, TRUE);
    SetLocalObject(oBinder, "ZurielUltimateSacrificeTarget", oTarget);
    SetLocalObject(oTarget, "ZurielSacrificeBinder", oBinder);
    AddEventScript(oTarget, EVENT_VIRTUAL_ONDAMAGED, "bnd_events", TRUE, FALSE);
    AddEventScript(oTarget, EVENT_NPC_ONDAMAGED, "bnd_events", TRUE, FALSE);

    FloatingTextStringOnCreature(
        "Ultimate Sacrifice ward placed on " + GetName(oTarget) + " (the next damaging attack, spell, or ability against them will be redirected to you).",
        oBinder, FALSE
    );
}
