/*
    Inflame - Warpriest spell
*/
#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void ApplyEffect();

void main()
{
    object oCaster = OBJECT_SELF;
    if(GetIsInCombat(oCaster))
    {
        return;
    }
    ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 1.0, 5.0);
    ActionDoCommand(ApplyEffect());
    string sDeity = GetDeity(oCaster);
    int iAlign = GetAlignmentGoodEvil(oCaster);
    int iGender = GetGender(oCaster);
    string sSpeech;
    if(sDeity != "")
    {
        switch(iAlign)
        {
        case ALIGNMENT_GOOD:
            sSpeech = GetStringByStrRef(0x0100302D, iGender);
            break;
        case ALIGNMENT_EVIL:
            sSpeech = GetStringByStrRef(0x0100302E, iGender);
            break;
        default:
            sSpeech = GetStringByStrRef(0x0100302F, iGender);
            break;
        }
    }
    else
    {
        switch(iAlign)
        {
        case ALIGNMENT_GOOD:
            sSpeech = GetStringByStrRef(0x01003030, iGender);
            break;
        case ALIGNMENT_EVIL:
            sSpeech = GetStringByStrRef(0x01003031, iGender);
            break;
        default:
            sSpeech = GetStringByStrRef(0x01003032, iGender);
            break;
        }
    }
    SpeakString(sSpeech, TALKVOLUME_TALK);
}

void ApplyEffect()
{
    effect eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
    location lCenter = GetLocation(OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lCenter);
    int iBonus = GetLevelByClass(CLASS_TYPE_WARPRIEST, OBJECT_SELF);
    effect eBuff = EffectSavingThrowIncrease(SAVING_THROW_ALL, iBonus, SAVING_THROW_TYPE_MIND_SPELLS);
    float fDuration = IntToFloat(5 + iBonus);
    fDuration = fDuration*60.0;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,10.0,lCenter,FALSE);
    while(oTarget != OBJECT_INVALID)
    {
        if(GetObjectHeard(OBJECT_SELF,oTarget))
        {
            if(GetIsFriend(oTarget, OBJECT_SELF))
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE,10.0,lCenter,FALSE);
    }
}

