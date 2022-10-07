/*
    Implicable Foe - Heartbeat
*/
#include "prc_alterations"

int GetIsDisabled(object oCreature);

void main()
{
    object oCreator = GetAreaOfEffectCreator();
    switch(GetCurrentAction(oCreator))
    {
    case ACTION_ANIMALEMPATHY:
    case ACTION_ATTACKOBJECT:
    case ACTION_CASTSPELL:
    case ACTION_CLOSEDOOR:
    case ACTION_COUNTERSPELL:
    case ACTION_DIALOGOBJECT:
    case ACTION_DISABLETRAP:
    case ACTION_DROPITEM:
    case ACTION_EXAMINETRAP:
    case ACTION_FLAGTRAP:
    case ACTION_FOLLOW:
    case ACTION_HEAL:
    case ACTION_ITEMCASTSPELL:
    case ACTION_KIDAMAGE:
    case ACTION_LOCK:
    case ACTION_MOVETOPOINT:
    case ACTION_OPENDOOR:
    case ACTION_OPENLOCK:
    case ACTION_PICKPOCKET:
    case ACTION_PICKUPITEM:
    case ACTION_RANDOMWALK:
    case ACTION_RECOVERTRAP:
    case ACTION_REST:
    case ACTION_SETTRAP:
    case ACTION_SIT:
    case ACTION_SMITEGOOD:
    case ACTION_TAUNT:
    case ACTION_USEOBJECT:
        FloatingTextStringOnCreature("Your concentration is broken.", oCreator, FALSE);
        DestroyObject(OBJECT_SELF);
        break;
    }
    if(GetIsDisabled(oCreator))
    {
        FloatingTextStringOnCreature("Your concentration is broken.", oCreator, FALSE);
        DestroyObject(OBJECT_SELF);
    }
}

int GetIsDisabled(object oCreature)
{
    int bReturn = FALSE;
    effect e = GetFirstEffect(oCreature);
    while(GetIsEffectValid(e))
    {
        switch(GetEffectType(e))
        {
        case EFFECT_TYPE_CHARMED:
        case EFFECT_TYPE_CONFUSED:
        case EFFECT_TYPE_CUTSCENE_PARALYZE:
        case EFFECT_TYPE_CUTSCENEIMMOBILIZE:
        case EFFECT_TYPE_DAZED:
        case EFFECT_TYPE_DOMINATED:
        case EFFECT_TYPE_ENTANGLE:
        case EFFECT_TYPE_FRIGHTENED:
        case EFFECT_TYPE_PARALYZE:
        case EFFECT_TYPE_PETRIFY:
        case EFFECT_TYPE_SLEEP:
        case EFFECT_TYPE_STUNNED:
            bReturn = TRUE;
            break;
        }
        e = GetNextEffect(oCreature);
    }
    if(GetIsDead(oCreature))
    {
        bReturn = TRUE;
    }
    return bReturn;
}

