//::///////////////////////////////////////////////
//:: codi_pre_tele
//:://////////////////////////////////////////////
/*
      Ocular Adept: Telekinesis
*/
//:://////////////////////////////////////////////
//:: Created By: James Stoneburner
//:: Created On: 2003-11-30
//:://////////////////////////////////////////////
#include "prc_inc_sp_tch"

void MoveTarget(object oTarget, vector vAwayFrom, float fDistance);

void main()
{
    //SendMessageToPC(OBJECT_SELF, "Telekinesis script online");
    int nOcLvl = GetLevelByClass(CLASS_TYPE_OCULAR, OBJECT_SELF);
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    int nOcSv = 10 + (nOcLvl/2) + nChaMod;




    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    if(oCaster == oTarget)
    {
        // Cast on Self
        location lSelf = GetLocation(OBJECT_SELF);
        float fDist;
        effect eKnockdown = EffectKnockdown();
        int iWillsave;
        vector vPosition = GetPosition(OBJECT_SELF);
        object oTarget2 = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lSelf, FALSE);
        while(oTarget2 != OBJECT_INVALID)
        {
            if(oTarget2 != OBJECT_SELF && GetIsEnemy(oTarget, OBJECT_SELF))
            {
                fDist = 6.0 - IntToFloat(GetCreatureSize(oTarget2));
                iWillsave = WillSave(oTarget, nOcSv);
                if(iWillsave == 0)
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget2, 6.0);
                }
                DelayCommand(0.1, MoveTarget(oTarget2, vPosition, fDist));
            }
            oTarget2 = GetNextObjectInShape(SHAPE_SPHERE, 5.0, lSelf, FALSE);
        }
    }
    else if (oTarget == OBJECT_INVALID)
    {
        // Cast on Ground
    }
    else if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        int bHit = PRCDoRangedTouchAttack(oTarget);;
        if(bHit) {
            location lSelf = GetLocation(OBJECT_SELF);
            float fDist;
            float fDelay = 0.2;
            effect eKnockdown = EffectKnockdown();
            int iFortsave;
            vector vPosition = GetPosition(OBJECT_SELF);
            fDist = 9.0 - (IntToFloat(GetCreatureSize(oTarget)) * 1.5);
            AssignCommand(oTarget, ClearAllActions());
            if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget) != OBJECT_INVALID)
            {
                iFortsave = WillSave(oTarget, nOcSv);
                if(iFortsave == 0)
                {
                    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
                    if (GetDroppableFlag(oItem) && !GetPlotFlag(oItem))
                    {
                        object oNew = CopyObject(oItem, GetLocation(oTarget));
                        DestroyObject(oItem);
                    }
                    //DelayCommand(fDelay, AssignCommand(oTarget, ActionPutDownItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget))));
                    //fDelay = fDelay + 0.3;
                }
            }
            if(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget) != OBJECT_INVALID)
            {
                iFortsave = WillSave(oTarget, nOcSv);
                if(iFortsave == 0)
                {
                    object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
                    if (GetDroppableFlag(oItem) && !GetPlotFlag(oItem))
                    {
                        object oNew = CopyObject(oItem, GetLocation(oTarget));
                        DestroyObject(oItem);
                    }
                    //DelayCommand(fDelay, AssignCommand(oTarget, ActionPutDownItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget))));
                    //fDelay = fDelay + 0.3;
                }
            }
            DelayCommand(fDelay, MoveTarget(oTarget, vPosition, fDist));
            fDelay = fDelay + fDist/2.0;
            iFortsave = WillSave(oTarget, nOcSv);
            if(iFortsave == 0)
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 6.0));
            }
        } else {
            if(GetIsPC(OBJECT_SELF)) {
                SendMessageToPC(OBJECT_SELF, "The ray missed.");
            }
        }
    }
    else if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
    {
        if (GetLocked(oTarget) && !GetLockKeyRequired(oTarget))
        {
            int iDC = GetLockUnlockDC(oTarget);
            if(d20(1) + GetClassByPosition(CLASS_TYPE_OCULAR) >= iDC)
            {
                SetLocked(oTarget, FALSE);
                AssignCommand(oTarget, SpeakString("**Click**"));
            }
            else
            {
                SendMessageToPC(oCaster, "You fail to effect that object.");
            }
        }
        else if (GetLocked(oTarget) && GetLockKeyRequired(oTarget))
        {
            AssignCommand(oCaster, SpeakString("This lock is beyond my ability to open, I'll need the key.",TALKVOLUME_WHISPER));
        }
        else if (!GetLocked(oTarget))
        {
            AssignCommand(oTarget, ActionOpenDoor(oTarget));
        }
    }
    else if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
    {
        if (GetLocked(oTarget) && GetLockKeyRequired(oTarget))
        {
            int iDC = GetLockUnlockDC(oTarget);
            if(d20(1) + GetClassByPosition(CLASS_TYPE_OCULAR) >= iDC)
            {
                SetLocked(oTarget, FALSE);
                AssignCommand(oTarget, SpeakString("**Click**"));
            }
            else
            {
                SendMessageToPC(oCaster, "You fail to effect that object.");
            }
        }
        else if (GetLocked(oTarget) && GetLockKeyRequired(oTarget))
        {
            AssignCommand(oCaster, SpeakString("This lock is beyond my ability to open, I'll need the key.",TALKVOLUME_WHISPER));
        }
        else if (!GetLocked(oTarget))
        {
            //location lLoc = GetLocation(oTarget);
            //CreateObject(OBJECT_TYPE_CREATURE, "anunseenforce", lLoc, FALSE, "FORCE");
            AssignCommand(oTarget, PlayAnimation(ANIMATION_PLACEABLE_OPEN));
        }
    }
    else if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {
        // Cast on Item
    }
}

void MoveTarget(object oTarget, vector vAwayFrom, float fDistance)
{
    vector vStart = GetPosition(oTarget);
    int X = (vStart.x > vAwayFrom.x);
    int Y = (vStart.y > vAwayFrom.y);
    int i = 0;
    vector vNew;
    location lNew;
    float fDelay = 0.1;
    for(i=1;i<=FloatToInt(fDistance);i++)
    {
        if (X && Y)
        {
            vNew = Vector(vStart.x + IntToFloat(i), vStart.y + IntToFloat(i), 0.0);
        }
        else if (X && !Y)
        {
            vNew = Vector(vStart.x + IntToFloat(i), vStart.y - IntToFloat(i), 0.0);
        }
        else if (!X && Y)
        {
            vNew = Vector(vStart.x - IntToFloat(i), vStart.y + IntToFloat(i), 0.0);
        }
        else if (!X && !Y)
        {
            vNew = Vector(vStart.x - IntToFloat(i), vStart.y - IntToFloat(i), 0.0);
        }
        lNew = Location(GetArea(oTarget), vNew, GetFacing(oTarget));
        DelayCommand(fDelay, AssignCommand(oTarget, JumpToLocation(lNew)));
        fDelay = fDelay + 0.5;
    }


}
