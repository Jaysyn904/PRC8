#include "sp_moon_inc"

const string MOONFIRE_CONTROLLER_PREFIX = "MFC_";
const string MOONFIRE_IMMUNITY_PREFIX   = "MFI_";
const string MOONFIRE_AURA_PREFIX       = "MFA_";
const string MOONFIRE_REVEAL_PREFIX     = "MFR_";

const float MOONFIRE_RANGE = 18.28f; // 60 feet.
const float MOONFIRE_INTERVAL = 0.5f;
const int VFX_IMP_MOONFIRE = 10101;
const int VFX_IMP_MOONFIRE_BURST = 10102;
const int VFX_IMP_MOONFIRE_CROWN = 10103;
const float MOONFIRE_VFX_SPEED = 35.0f; // Native Sunbeam particle velocity.

int MoonfireStartsWith(string sText, string sPrefix)
{
    return GetStringLeft(sText, GetStringLength(sPrefix)) == sPrefix;
}

string MoonfireStateKey(int nSerial)
{
    return "MF" + IntToString(nSerial) + "_";
}

string MoonfireCastKey(object oCaster, int nSerial)
{
    return ObjectToString(oCaster) + "_" + IntToString(nSerial);
}

string MoonfireEffectTag(string sPrefix, object oCaster, int nSerial)
{
    return sPrefix + MoonfireCastKey(oCaster, nSerial);
}

void MoonfireRemoveTaggedEffects(object oTarget, string sTag)
{
    if(!GetIsObjectValid(oTarget))
        return;

    int bRemoved = TRUE;
    while(bRemoved)
    {
        bRemoved = FALSE;
        effect eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectTag(eTest) == sTag)
            {
                RemoveEffect(oTarget, eTest);
                bRemoved = TRUE;
                break;
            }

            eTest = GetNextEffect(oTarget);
        }
    }
}

int MoonfireItemHasMagicAura(object oItem)
{
    if(!GetIsObjectValid(oItem)
        || GetObjectType(oItem) != OBJECT_TYPE_ITEM)
        return FALSE;

    return GetIsItemPropertyValid(GetFirstItemProperty(oItem));
}

int MoonfireObjectHasMagicAura(object oTarget)
{
    if(!GetIsObjectValid(oTarget))
        return FALSE;

    if(MoonfireItemHasMagicAura(oTarget))
        return TRUE;

    effect eTest = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectSubType(eTest) == SUBTYPE_MAGICAL
            || GetEffectSpellId(eTest) >= 0)
            return TRUE;

        eTest = GetNextEffect(oTarget);
    }

    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        object oItem = GetFirstItemInInventory(oTarget);
        while(GetIsObjectValid(oItem))
        {
            if(MoonfireItemHasMagicAura(oItem))
                return TRUE;
            oItem = GetNextItemInInventory(oTarget);
        }
    }

    return FALSE;
}

int MoonfireHasStoredDisguise(object oTarget)
{
    if(GetPersistantLocalInt(oTarget, "AppearanceIsStored") != 6)
        return FALSE;

    int bKnownDisguise = GetHasFeat(FEAT_SVIRF_DISGUISE, oTarget)
        || GetHasFeat(FEAT_RAK_DISGUISE, oTarget)
        || GetHasFeat(FEAT_HOUND_DISGUISE, oTarget)
        || GetHasFeat(FEAT_FEYRI_ALTER, oTarget)
        || GetHasFeat(FEAT_RACE_MINOR_SHAPE_CHANGE, oTarget)
        || GetHasFeat(FEAT_1000FACES_MEDIUM, oTarget)
        || GetHasFeat(FEAT_TEMPLATE_DEMILICH_ALTER_SELF, oTarget);
    if(!bKnownDisguise)
        return FALSE;

    return GetAppearanceType(oTarget)
        != GetPersistantLocalInt(oTarget, "AppearanceStored");
}

int MoonfireIsAlteredForm(object oTarget)
{
    return MoonSpellHasPolymorph(oTarget)
        || MoonSpellHasPersistentShift(oTarget)
        || MoonSpellHasWerewolfTemplateFormState(oTarget)
        || GetLocalInt(oTarget, "WWWolf")
        || GetLocalInt(oTarget, "WWHybrid")
        || MoonfireHasStoredDisguise(oTarget);
}

int MoonfireHasShapechangerType(object oTarget)
{
    return GetRacialType(oTarget) == RACIAL_TYPE_SHAPECHANGER
        || MyPRCGetRacialType(oTarget) == RACIAL_TYPE_SHAPECHANGER
        || GetHasFeat(FEAT_SHAPECHANGER, oTarget)
        || MoonSpellHasWerewolfTemplate(oTarget)
        || MoonSpellIsLycanthrope(oTarget);
}

int MoonfireControllerIsActive(object oCaster, int nSerial)
{
    string sTag = MOONFIRE_CONTROLLER_PREFIX
        + MoonfireCastKey(oCaster, nSerial);
    effect eTest = GetFirstEffect(oCaster);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectTag(eTest) == sTag)
            return TRUE;
        eTest = GetNextEffect(oCaster);
    }

    return FALSE;
}

void MoonfireRestoreStoredBodyParts(object oTarget, int nAppearance)
{
    if(!GetIsObjectValid(oTarget)
        || GetPersistantLocalInt(oTarget, "AppearanceIsStored") != 6
        || GetAppearanceType(oTarget) != nAppearance
        || MoonSpellHasPolymorph(oTarget)
        || MoonSpellHasPersistentShift(oTarget)
        || GetLocalInt(oTarget, "WWWolf")
        || GetLocalInt(oTarget, "WWHybrid"))
        return;

    int i;
    for(i = 0; i <= 20; i++)
    {
        SetCreatureBodyPart(i,
            GetPersistantLocalInt(oTarget,
                "AppearanceStoredPart" + IntToString(i)), oTarget);
    }
}

void MoonfireRestoreStoredAppearance(object oTarget)
{
    if(!GetIsObjectValid(oTarget)
        || GetPersistantLocalInt(oTarget, "AppearanceIsStored") != 6)
        return;

    int nAppearance = GetPersistantLocalInt(oTarget, "AppearanceStored");
    SetCreatureAppearanceType(oTarget, nAppearance);
    SetPortraitId(oTarget,
        GetPersistantLocalInt(oTarget, "AppearanceStoredPortraitID"));
    SetPortraitResRef(oTarget,
        GetPersistantLocalString(oTarget,
            "AppearanceStoredPortraitResRef"));
    SetCreatureTailType(
        GetPersistantLocalInt(oTarget, "AppearanceStoredTail"), oTarget);
    SetCreatureWingType(
        GetPersistantLocalInt(oTarget, "AppearanceStoredWing"), oTarget);

    // NWN needs the new phenotype loaded before individual body parts are
    // restored. Both callbacks are guarded so a later voluntary form change
    // is never overwritten.
    DelayCommand(1.1f,
        MoonfireRestoreStoredBodyParts(oTarget, nAppearance));
    DelayCommand(2.25f,
        MoonfireRestoreStoredBodyParts(oTarget, nAppearance));
}

void MoonfireRestoreNaturalForm(object oTarget)
{
    if(!GetIsObjectValid(oTarget))
        return;

    MoonSpellStripPolymorph(oTarget);

    // Stock racial disguise abilities store the true model separately from
    // the PRC shifting marker. Restore that appearance as well.
    if(MoonfireHasStoredDisguise(oTarget))
        MoonfireRestoreStoredAppearance(oTarget);
}

location MoonfireGetCastCone(object oCaster, location lAim)
{
    location lCaster = GetLocation(oCaster);
    object oArea = GetAreaFromLocation(lCaster);
    vector vOrigin = GetPositionFromLocation(lCaster);
    float fFacing = GetFacingFromLocation(lCaster);

    // PRC/NUI location targeting supplies the clicked point, while native
    // cone targeting may supply a caster-rooted location whose facing carries
    // the aim. Preserve both cases, but always snapshot the cone's origin at
    // the caster's cast-time position.
    if(GetAreaFromLocation(lAim) == oArea)
    {
        vector vAim = GetPositionFromLocation(lAim);
        vector vDirection = Vector(vAim.x - vOrigin.x,
            vAim.y - vOrigin.y, 0.0f);
        if(VectorMagnitude(vDirection) > 0.01f)
            fFacing = VectorToAngle(vDirection);
        else
            fFacing = GetFacingFromLocation(lAim);
    }

    return Location(oArea, vOrigin, fFacing);
}

location MoonfireGetConeEnd(location lCone)
{
    object oArea = GetAreaFromLocation(lCone);
    vector vOrigin = GetPositionFromLocation(lCone);
    float fFacing = GetFacingFromLocation(lCone);
    vector vForward = AngleToVector(fFacing);
    vector vEnd = Vector(vOrigin.x + vForward.x * MOONFIRE_RANGE,
        vOrigin.y + vForward.y * MOONFIRE_RANGE, vOrigin.z);
    return Location(oArea, vEnd, fFacing);
}

void MoonfireApplyTaggedVisual(object oCaster, object oTarget, int nVFX,
    string sTag, float fDuration)
{
    if(!GetIsObjectValid(oTarget))
        return;

    effect eVisual = MagicalEffect(EffectVisualEffect(nVFX));
    eVisual = SetEffectCreator(eVisual, oCaster);
    eVisual = TagEffect(eVisual, sTag);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisual, oTarget,
        fDuration);
}

object MoonfireCreateVisualNode(object oCaster, int nSerial, int nNode,
    location lNode, int bLight)
{
    string sKey = MoonfireStateKey(nSerial);
    object oNode = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lNode,
        FALSE, "MFire" + IntToString(nSerial) + "_" + IntToString(nNode));
    if(!GetIsObjectValid(oNode))
        return OBJECT_INVALID;

    SetPlotFlag(oNode, TRUE);
    SetUseableFlag(oNode, FALSE);
    SetLocalObject(oCaster, sKey + "V" + IntToString(nNode), oNode);
    if(bLight)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
            EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20), oNode);

    float fNodeLifetime = GetLocalFloat(oCaster, sKey + "D") + 1.0f;
    AssignCommand(oNode,
        DelayCommand(fNodeLifetime, DestroyObject(OBJECT_SELF)));
    return oNode;
}

void MoonfireLightVisualNode(object oNode)
{
    if(!GetIsObjectValid(oNode))
        return;

    // The lasting cone is brightly illuminated without leaving laser lines or
    // floating endpoint orbs over the terrain.
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
        EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20), oNode);
}

void MoonfireCreateVisualCone(object oCaster, int nSerial, location lCone)
{
    string sKey = MoonfireStateKey(nSerial);
    object oArea = GetAreaFromLocation(lCone);
    vector vOrigin = GetPositionFromLocation(lCone);
    float fFacing = GetFacingFromLocation(lCone);
    vector vForward = AngleToVector(fFacing);
    vector vSide = Vector(-vForward.y, vForward.x, 0.0f);
    int nNode = 0;
    int nLane;

    vector vStart = Vector(vOrigin.x + vForward.x * 0.5f,
        vOrigin.y + vForward.y * 0.5f, vOrigin.z + 0.2f);
    object oStart = MoonfireCreateVisualNode(oCaster, nSerial, nNode,
        Location(oArea, vStart, fFacing), FALSE);
    DelayCommand(0.60f, MoonfireLightVisualNode(oStart));
    nNode++;

    // Preserve the lasting illumination independently of the one-shot cast
    // artwork. Only the center and two outer endpoints need dynamic lights.
    for(nLane = -2; nLane <= 2; nLane++)
    {
        float fEndOffset = IntToFloat(nLane) * MOONFIRE_RANGE * 0.25f;
        vector vEnd = Vector(
            vOrigin.x + vForward.x * MOONFIRE_RANGE
                + vSide.x * fEndOffset,
            vOrigin.y + vForward.y * MOONFIRE_RANGE
                + vSide.y * fEndOffset,
            vOrigin.z + 0.2f);
        object oEnd = MoonfireCreateVisualNode(oCaster, nSerial, nNode,
            Location(oArea, vEnd, fFacing), FALSE);
        nNode++;
        // Keep the persistent cone readable without filling the renderer's
        // dynamic-light budget when two Moonfire cones overlap.
        if(GetIsObjectValid(oEnd) && (nLane == -2 || nLane == 0 || nLane == 2))
            DelayCommand(0.60f, MoonfireLightVisualNode(oEnd));
    }

    // The hand launch is now var_moonfire (spells.2da CastHandVisual): native
    // Sunbeam Fountain/Motion_Blur particles, not EffectBeam laser segments.
    // Let the client animate their travel continuously. The ground-only native
    // crown follows in three widening waves, timed to the 35 m/s launch. Its
    // original half-second pre-contact wait was removed in the model, so do
    // not add that delay twice. Location effects cannot be cut off by deleting
    // a helper placeable or drift upward to a placeable's impact attachment.
    int nStep;
    for(nStep = 1; nStep <= 3; nStep++)
    {
        float fProgress = IntToFloat(nStep) / 3.0f;
        float fDistance = MOONFIRE_RANGE * fProgress;
        vector vImpact = Vector(vOrigin.x + vForward.x * fDistance,
            vOrigin.y + vForward.y * fDistance, vOrigin.z);
        int nVisual = VFX_IMP_MOONFIRE_CROWN;
        if(nStep == 3)
            nVisual = VFX_IMP_MOONFIRE_BURST;
        DelayCommand(fDistance / MOONFIRE_VFX_SPEED,
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                EffectVisualEffect(nVisual, FALSE, fProgress),
                Location(oArea, vImpact, fFacing)));
    }

    SetLocalInt(oCaster, sKey + "VN", nNode);
}

void MoonfireRevealMagicAuras(object oCaster, int nSerial, location lCone,
    float fDuration)
{
    string sKey = MoonfireStateKey(nSerial);
    string sTag = MoonfireEffectTag(MOONFIRE_AURA_PREFIX, oCaster, nSerial);
    int nCount = 0;
    int nMask = OBJECT_TYPE_CREATURE | OBJECT_TYPE_ITEM
        | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE
        | OBJECT_TYPE_AREA_OF_EFFECT;
    location lEnd = MoonfireGetConeEnd(lCone);
    vector vOrigin = GetPositionFromLocation(lCone);
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, MOONFIRE_RANGE,
        lEnd, TRUE, nMask, vOrigin);

    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oCaster && MoonfireObjectHasMagicAura(oTarget))
        {
            MoonfireApplyTaggedVisual(oCaster, oTarget, VFX_DUR_GLOW_BLUE,
                sTag, fDuration);
            SetLocalObject(oCaster, sKey + "A" + IntToString(nCount),
                oTarget);
            nCount++;
        }

        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, MOONFIRE_RANGE,
            lEnd, TRUE, nMask, vOrigin);
    }

    SetLocalInt(oCaster, sKey + "AN", nCount);
}

void MoonfireApplyReveal(object oCaster, object oTarget, int nSerial,
    float fDuration)
{
    if(!MoonfireControllerIsActive(oCaster, nSerial))
        return;

    string sKey = MoonfireStateKey(nSerial);
    string sTag = MoonfireEffectTag(MOONFIRE_REVEAL_PREFIX, oCaster,
        nSerial);
    int nCount = GetLocalInt(oCaster, sKey + "RN");

    MoonfireApplyTaggedVisual(oCaster, oTarget, VFX_DUR_GLOW_WHITE, sTag,
        fDuration);
    SetLocalObject(oCaster, sKey + "R" + IntToString(nCount), oTarget);
    SetLocalInt(oCaster, sKey + "RN", nCount + 1);
}

void MoonfireApplyElectricitySuppression(object oCaster, object oTarget,
    int nSerial)
{
    string sTag = MoonfireEffectTag(MOONFIRE_IMMUNITY_PREFIX, oCaster,
        nSerial);
    MoonfireRemoveTaggedEffects(oTarget, sTag);

    effect eImmunity = MagicalEffect(
        EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 32767, 0));
    eImmunity = SetEffectCreator(eImmunity, oCaster);
    eImmunity = TagEffect(eImmunity, sTag);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmunity, oTarget,
        MOONFIRE_INTERVAL + 0.25f);
}

void MoonfirePulse(object oCaster, int nSerial)
{
    if(!GetIsObjectValid(oCaster))
        return;

    string sKey = MoonfireStateKey(nSerial);
    location lCone = GetLocalLocation(oCaster, sKey + "L");
    if(!GetIsObjectValid(GetAreaFromLocation(lCone)))
        return;

    int nMask = OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR
        | OBJECT_TYPE_PLACEABLE;
    location lEnd = MoonfireGetConeEnd(lCone);
    vector vOrigin = GetPositionFromLocation(lCone);
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, MOONFIRE_RANGE,
        lEnd, TRUE, nMask, vOrigin);
    while(GetIsObjectValid(oTarget))
    {
        MoonfireApplyElectricitySuppression(oCaster, oTarget, nSerial);
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, MOONFIRE_RANGE,
            lEnd, TRUE, nMask, vOrigin);
    }
}

void MoonfireCleanup(object oCaster, int nSerial)
{
    if(!GetIsObjectValid(oCaster))
        return;

    string sKey = MoonfireStateKey(nSerial);
    string sAuraTag = MoonfireEffectTag(MOONFIRE_AURA_PREFIX, oCaster,
        nSerial);
    string sRevealTag = MoonfireEffectTag(MOONFIRE_REVEAL_PREFIX, oCaster,
        nSerial);
    string sImmunityTag = MoonfireEffectTag(MOONFIRE_IMMUNITY_PREFIX,
        oCaster, nSerial);
    int i;

    int nAuras = GetLocalInt(oCaster, sKey + "AN");
    for(i = 0; i < nAuras; i++)
    {
        object oAura = GetLocalObject(oCaster,
            sKey + "A" + IntToString(i));
        MoonfireRemoveTaggedEffects(oAura, sAuraTag);
        DeleteLocalObject(oCaster, sKey + "A" + IntToString(i));
    }

    int nReveals = GetLocalInt(oCaster, sKey + "RN");
    for(i = 0; i < nReveals; i++)
    {
        object oReveal = GetLocalObject(oCaster,
            sKey + "R" + IntToString(i));
        MoonfireRemoveTaggedEffects(oReveal, sRevealTag);
        DeleteLocalObject(oCaster, sKey + "R" + IntToString(i));
    }

    int nNodes = GetLocalInt(oCaster, sKey + "VN");
    for(i = 0; i < nNodes; i++)
    {
        object oNode = GetLocalObject(oCaster,
            sKey + "V" + IntToString(i));
        if(GetIsObjectValid(oNode))
            DestroyObject(oNode);
        DeleteLocalObject(oCaster, sKey + "V" + IntToString(i));
    }

    location lCone = GetLocalLocation(oCaster, sKey + "L");
    if(GetIsObjectValid(GetAreaFromLocation(lCone)))
    {
        int nMask = OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR
            | OBJECT_TYPE_PLACEABLE;
        location lEnd = MoonfireGetConeEnd(lCone);
        vector vOrigin = GetPositionFromLocation(lCone);
        object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE,
            MOONFIRE_RANGE, lEnd, TRUE, nMask, vOrigin);
        while(GetIsObjectValid(oTarget))
        {
            MoonfireRemoveTaggedEffects(oTarget, sImmunityTag);
            oTarget = MyNextObjectInShape(SHAPE_SPELLCONE,
                MOONFIRE_RANGE, lEnd, TRUE, nMask, vOrigin);
        }
    }

    DeleteLocalLocation(oCaster, sKey + "L");
    DeleteLocalFloat(oCaster, sKey + "D");
    DeleteLocalInt(oCaster, sKey + "AN");
    DeleteLocalInt(oCaster, sKey + "RN");
    DeleteLocalInt(oCaster, sKey + "VN");
}

void MoonfireAffectCreatures(object oCaster, int nCasterLevel,
    int nMetaMagic, int nSpellID, int nSerial, location lCone,
    float fDuration)
{
    location lEnd = MoonfireGetConeEnd(lCone);
    vector vOrigin = GetPositionFromLocation(lCone);
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, MOONFIRE_RANGE,
        lEnd, TRUE, OBJECT_TYPE_CREATURE, vOrigin);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oCaster && !GetIsDead(oTarget))
        {
            float fDelay = PRCGetRandomDelay(0.4f, 1.4f);
            MoonSpellSignal(oCaster, oTarget, nSpellID, TRUE);

            if(!PRCDoResistSpell(oCaster, oTarget,
                nCasterLevel + SPGetPenetr(), fDelay))
            {
                int nUndead = MyPRCGetRacialType(oTarget)
                    == RACIAL_TYPE_UNDEAD;
                int nShapechanger = MoonfireHasShapechangerType(oTarget);
                int nLiving = MoonSpellIsLivingCreature(oTarget);
                int nDamage = 0;
                int nDice = 0;

                if(nUndead || nShapechanger)
                {
                    nDice = nCasterLevel;
                    if(nDice > 20) nDice = 20;
                    if(nDice < 1) nDice = 1;
                }
                else if(nLiving)
                {
                    nDice = nCasterLevel / 2;
                    if(nDice > 10) nDice = 10;
                    if(nDice < 1) nDice = 1;
                }

                if(nDice > 0)
                {
                    nDamage = PRCMaximizeOrEmpower(8, nDice, nMetaMagic);
                    nDamage += SpellDamagePerDice(oCaster, nDice);
                    int nDC = PRCGetSaveDC(oTarget, oCaster, nSpellID);
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget,
                        nDC, SAVING_THROW_TYPE_SPELL, oCaster);

                    DelayCommand(fDelay, SPApplyEffectToObject(
                        DURATION_TYPE_INSTANT,
                        EffectVisualEffect(VFX_IMP_MOONFIRE), oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(
                        DURATION_TYPE_INSTANT,
                        PRCEffectDamage(oTarget, nDamage,
                            DAMAGE_TYPE_DIVINE), oTarget));
                    DelayCommand(fDelay, PRCBonusDamage(oTarget));
                }

                if(MoonfireIsAlteredForm(oTarget))
                {
                    int nDC = PRCGetSaveDC(oTarget, oCaster, nSpellID);
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC,
                        SAVING_THROW_TYPE_SPELL, oCaster, fDelay))
                    {
                        DelayCommand(fDelay,
                            MoonfireRestoreNaturalForm(oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(
                            DURATION_TYPE_INSTANT,
                            EffectVisualEffect(VFX_IMP_UNSUMMON), oTarget));
                    }

                    DelayCommand(fDelay, MoonfireApplyReveal(oCaster,
                        oTarget, nSerial, fDuration));
                }
            }
        }

        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, MOONFIRE_RANGE,
            lEnd, TRUE, OBJECT_TYPE_CREATURE, vOrigin);
    }
}

void main()
{
    effect eRun = GetLastRunScriptEffect();
    if(GetIsEffectValid(eRun)
        && MoonfireStartsWith(GetEffectTag(eRun),
            MOONFIRE_CONTROLLER_PREFIX))
    {
        int nSerial = StringToInt(GetEffectString(eRun, 0));
        int nEvent = GetLastRunScriptEffectScriptType();
        if(nEvent == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_REMOVED)
            MoonfireCleanup(OBJECT_SELF, nSerial);
        else if(nEvent == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_APPLIED
            || nEvent == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_INTERVAL)
            MoonfirePulse(OBJECT_SELF, nSerial);
        return;
    }

    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSpellID = PRCGetSpellId();

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    if(!X2PreSpellCastCode())
    {
        PRCSetSchool();
        return;
    }

    location lCone = MoonfireGetCastCone(oCaster,
        PRCGetSpellTargetLocation());
    float fDuration = PRCGetMetaMagicDuration(
        RoundsToSeconds(nCasterLevel));
    int nSerial = GetLocalInt(oCaster, "PRC_MoonfireSerial") + 1;
    SetLocalInt(oCaster, "PRC_MoonfireSerial", nSerial);

    string sKey = MoonfireStateKey(nSerial);
    SetLocalLocation(oCaster, sKey + "L", lCone);
    SetLocalFloat(oCaster, sKey + "D", fDuration);

    MoonfireRevealMagicAuras(oCaster, nSerial, lCone, fDuration);
    MoonfireAffectCreatures(oCaster, nCasterLevel, nMetaMagic, nSpellID,
        nSerial, lCone, fDuration);
    MoonfireCreateVisualCone(oCaster, nSerial, lCone);

    string sControllerTag = MOONFIRE_CONTROLLER_PREFIX
        + MoonfireCastKey(oCaster, nSerial);
    effect eController = EffectRunScript("sp_moonfire", "sp_moonfire",
        "sp_moonfire", MOONFIRE_INTERVAL, IntToString(nSerial));
    eController = SetEffectSpellId(eController, nSpellID);
    eController = SetEffectCasterLevel(eController, nCasterLevel);
    eController = SetEffectCreator(eController, oCaster);
    eController = TagEffect(eController, sControllerTag);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eController, oCaster,
        fDuration, TRUE, nSpellID, nCasterLevel, oCaster);

    // Visual nodes own a failsafe; this catches any unusual controller loss.
    DelayCommand(fDuration + 0.25f,
        MoonfireCleanup(oCaster, nSerial));
    PRCSetSchool();
}
