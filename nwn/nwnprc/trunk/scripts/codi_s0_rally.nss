/*
    Rally - Warpriest spell
*/
#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
void main()
{
    object oCaster = OBJECT_SELF;
    location lCenter = GetLocation(oCaster);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, lCenter);
    effect eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
    effect eHit = EffectVisualEffect(VFX_COM_HIT_DIVINE);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lCenter);
    while(oTarget != OBJECT_INVALID)
    {
        if(GetIsFriend(oTarget, oCaster))
        {
            effect e = GetFirstEffect(oTarget);
            while(GetIsEffectValid(e))
            {
                if(GetEffectType(e) == EFFECT_TYPE_FRIGHTENED)
                {
                    int iDC = 10 + (GetHitDice(GetEffectCreator(e))/2) - GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster);
                    int iWill = WillSave(oTarget, iDC, SAVING_THROW_TYPE_FEAR,GetEffectCreator(e));
                    if(iWill > 0)
                    {
                        RemoveEffect(oTarget, e);
                    }
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
                    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_WP_RALLY, FALSE));
                }
                e = GetNextEffect(oTarget);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0, lCenter);
    }
}

