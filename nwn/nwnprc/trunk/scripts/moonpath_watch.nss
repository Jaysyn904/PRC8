#include "moonpath_inc"

// Native NWScript cannot intercept every resolved weapon hit. While an archer
// aims through a registered surface, give that attacker a ranged-only miss
// effect. It never grants blanket protection to the target or changes AI.
// A target change between 0.1-second samples and arrows already resolved before
// the first sample remain engine limitations and require in-game testing.
const string MPATH_ARROW_TAG = "MPATH_NATIVE_ARROW";
const float MPATH_ARROW_LIFETIME = 0.25f;

int MoonPathCasterHasController(object oCaster, int nSerial)
{
    if(!GetIsObjectValid(oCaster))
        return FALSE;

    string sCasterKey = GetObjectUUID(oCaster);
    if(sCasterKey == "")
        sCasterKey = ObjectToString(oCaster);
    string sTag = "MPC_" + sCasterKey + "_" + IntToString(nSerial);
    effect eTest = GetFirstEffect(oCaster);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectTag(eTest) == sTag)
            return TRUE;
        eTest = GetNextEffect(oCaster);
    }
    return FALSE;
}

void MoonPathRequestCleanup(object oAnchor)
{
    object oCaster = GetLocalObject(oAnchor, MPATH_ANCHOR_CASTER);
    int nSerial = GetLocalInt(oAnchor, MPATH_ANCHOR_SERIAL);
    // Stop combat gates immediately, including while the cleanup script runs.
    DeleteLocalInt(oAnchor, MPATH_ANCHOR_ACTIVE);
    if(GetIsObjectValid(oCaster) && nSerial > 0)
    {
        SetLocalInt(oCaster, "PRC_MoonPathCleanup", nSerial);
        ExecuteScript("sp_moonpath", oCaster);
        DeleteLocalInt(oCaster, "PRC_MoonPathCleanup");
    }
}

void MoonPathRemoveArrowEffect(object oArcher)
{
    effect eTest = GetFirstEffect(oArcher);
    while(GetIsEffectValid(eTest))
    {
        effect eNext = GetNextEffect(oArcher);
        if(GetEffectTag(eTest) == MPATH_ARROW_TAG)
            RemoveEffect(oArcher, eTest);
        eTest = eNext;
    }
}

void MoonPathUpdateArchers(object oArea)
{
    int bEnabled = MoonPathEnforcementIsEnabled()
        && GetIsObjectValid(MoonPathFirstSurfaceInArea(oArea));
    object oArcher = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oArcher))
    {
        if(GetObjectType(oArcher) == OBJECT_TYPE_CREATURE)
        {
            MoonPathRemoveArrowEffect(oArcher);
            if(bEnabled && !GetIsDead(oArcher)
                && GetWeaponRanged(GetItemInSlot(
                    INVENTORY_SLOT_RIGHTHAND, oArcher)))
            {
                object oTarget = GetAttackTarget(oArcher);
                object oSurface = MoonPathFindAttackSurface(oArcher, oTarget);
                if(GetIsObjectValid(oSurface))
                {
                    effect eMiss = EffectMissChance(100,
                        MISS_CHANCE_TYPE_VS_RANGED);
                    eMiss = TagEffect(SupernaturalEffect(eMiss),
                        MPATH_ARROW_TAG);
                    // The timeout is a fail-safe if the owner vanishes or a
                    // save/load interrupts cleanup. No permanent debuff remains.
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        HideEffectIcon(eMiss), oArcher, MPATH_ARROW_LIFETIME);
                }
            }
        }
        oArcher = GetNextObjectInArea(oArea);
    }
}

void main()
{
    object oArea = GetArea(OBJECT_SELF);
    if(!GetIsObjectValid(oArea))
        return;

    // Cleanup also invokes this script after unregistering the surface. Do
    // not recursively request teardown from that synchronous refresh.
    if(!GetLocalInt(OBJECT_SELF, MPATH_ANCHOR_ACTIVE))
    {
        MoonPathUpdateArchers(oArea);
        return;
    }

    int nEvent = GetLastRunScriptEffectScriptType();
    if(nEvent == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_REMOVED)
    {
        MoonPathRequestCleanup(OBJECT_SELF);
        MoonPathUpdateArchers(oArea);
        return;
    }

    // This placeable survives the caster's rest. Check every casting before
    // choosing which anchor scans combat: instant/forced rest can finish
    // between samples, so missing controllers matter as well as resting.
    // ON_APPLIED runs before the caster controller is installed; defer the
    // liveness check until the first interval.
    if(nEvent == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_INTERVAL)
    {
        object oCaster = GetLocalObject(OBJECT_SELF, MPATH_ANCHOR_CASTER);
        int nSerial = GetLocalInt(OBJECT_SELF, MPATH_ANCHOR_SERIAL);
        if(!MoonPathCasterHasController(oCaster, nSerial)
            || GetIsResting(oCaster))
        {
            MoonPathRequestCleanup(OBJECT_SELF);
            MoonPathUpdateArchers(oArea);
            return;
        }
    }

    // Every path owns a native interval effect, but only the first live anchor
    // scans the area. If it expires, another overlapping path takes over.
    if(nEvent == 0
        || MoonPathFirstSurfaceInArea(oArea) == OBJECT_SELF)
        MoonPathUpdateArchers(oArea);
}
