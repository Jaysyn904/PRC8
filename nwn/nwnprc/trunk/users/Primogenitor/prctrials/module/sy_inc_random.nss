//::////////////////////////////////////////////////////////////////////////////
// Random Number Generator
// sy_inc_random.nss
//
// Created by Dave Musser (Syrsnein)
// 12 Feb 2005
//
// A random number generator using the millisecond count of the game clock
// as a seed.
//
// Changes:
// 1 Jan, 2005, Syrsnein, Fixed a bug in SY_GetRandomSeed that was always
//    returning -10.  Thanks to Gale of the DLA for pointing this out.


const int RandomDebug = TRUE;

void SY_RandomDebug(string sMessage)
{
    if (!RandomDebug) return;
    PrintString("SY Random: " + sMessage);
}

struct RandomHistoryBuffer {
    float x0;
    float x1;
    float x2;
    float x3;
    float x4;
};

// Prototype Functions

// SY_Floor
// Returns a float value with no precision beyond 1/(10^i).
// - x: float value to be floored
// - i: precision of the value to be floored (default = 0)
float   SY_Floor(float x, int i=0);

// SY_Ceil
// Returns a float value with the 1/(10^i) precision incremented by 1 and no
//   precision beyond.
// - x: float value to be ceiled
// - i: precision of the value to be ceiled (default = 0)
float   SY_Ceil(float x, int i=0);

// SY_Round
// Returns a float value with the 1/(10^i) rounded up or down depending on the
//   1/(10^(i+1)) value
// - x: float value to be rounded
// - i: precision of the value to be rounded (default = 0)
float   SY_Round(float x, int i=0);

// SY_RandomInit
// Initializes a RandomHistoryBuffer on an object
// - oObject: The object on which to store the history buffer.  If oObject is
//            invalid, the module object will be used.
// - nSeed: An initial value to use to seed the random engine.
void    SY_RandomInit (object oObject, int nSeed);

// RandomI
// A call to retrieve a random integer number.  Default behavior is to return
//   either a 0 or a 1.
// - nMax: The maximum random value
// - nMin: The minimum random value
// - nSeed: An integer number used to initialize the random number engine
// - oObject: The object on which to store the history buffer.  If oObject is
//            invalid, the module object will be used.
int     RandomI(int nMax=1, int nMin=0, int nSeed=0, object oObject = OBJECT_INVALID);

// RandomF
// A call to retrieve a random float number.  Default behavior is to return
//   a number between 0.0 and 1.0
// - fMax: The maximum random value
// - fMin: The minimum random value
// - nSeed: An integer number used to initialize the random number engine
// - oObject: The object on which to store the history buffer.  If oObject is
//            invalid, the module object will be used.
float   RandomF(float fMax=1.0, float fMin=0.0, int nSeed=0, object oObject = OBJECT_INVALID);


// Define Functions
float SY_Floor(float x, int i=0)
{
    if (i==0)
        return IntToFloat(FloatToInt(x));

    float y = pow(10., IntToFloat(i));
    return IntToFloat(FloatToInt(x * y))/y;
}

float SY_Ceil(float x, int i=0)
{
    if (i==0)
        return IntToFloat(FloatToInt(x) + 1);

    float y = pow(10., IntToFloat(i));
    return IntToFloat(FloatToInt(x * y)+1)/y;
}

float SY_Round(float x, int i=0)
{
    if (i==0)
    {
        float y = x - SY_Floor(x);
        if (y>0.5) return SY_Ceil(x);
        return SY_Floor(x);
    }

    float y = pow(10., IntToFloat(i));
    float z = IntToFloat(FloatToInt(x * y))/y;
    if ((z - SY_Floor(z))>0.5)
        return SY_Ceil(z)/y;

    return SY_Floor(z)/y;
}

struct RandomHistoryBuffer SY_GetRandomHistoryBuffer(object oObject)
{
    struct RandomHistoryBuffer strBuffer;
    strBuffer.x0 = GetLocalFloat(oObject, "SY_RandomHistoryBuffer0");
    strBuffer.x1 = GetLocalFloat(oObject, "SY_RandomHistoryBuffer1");
    strBuffer.x2 = GetLocalFloat(oObject, "SY_RandomHistoryBuffer2");
    strBuffer.x3 = GetLocalFloat(oObject, "SY_RandomHistoryBuffer3");
    strBuffer.x4 = GetLocalFloat(oObject, "SY_RandomHistoryBuffer4");

    return strBuffer;
}

void SY_SetRandomHistoryBuffer(object oObject, struct RandomHistoryBuffer strBuffer)
{
    SetLocalFloat(oObject, "SY_RandomHistoryBuffer0", strBuffer.x0);
    SetLocalFloat(oObject, "SY_RandomHistoryBuffer1", strBuffer.x1);
    SetLocalFloat(oObject, "SY_RandomHistoryBuffer2", strBuffer.x2);
    SetLocalFloat(oObject, "SY_RandomHistoryBuffer3", strBuffer.x3);
    SetLocalFloat(oObject, "SY_RandomHistoryBuffer4", strBuffer.x4);
}

struct RandomHistoryBuffer SY_UpdateRandomBufferValue(struct RandomHistoryBuffer strBuffer, int nIndex, float fValue = 0.)
{
    switch(nIndex)
    {
        case 0: strBuffer.x0 = fValue; break;
        case 1: strBuffer.x1 = fValue; break;
        case 2: strBuffer.x2 = fValue; break;
        case 3: strBuffer.x3 = fValue; break;
        case 4: strBuffer.x4 = fValue; break;
    }
    return strBuffer;
}

struct RandomHistoryBuffer SY_InitRandomHistoryBuffer()
{
    struct RandomHistoryBuffer strBuffer;

    strBuffer.x0 = 0.0;
    strBuffer.x1 = 0.0;
    strBuffer.x2 = 0.0;
    strBuffer.x3 = 0.0;
    strBuffer.x4 = 0.0;

    return strBuffer;
}

int SY_GetRandomInitialized(object oObject)
{
    return GetLocalInt(oObject, "SY_RandomHistoryBufferInit");
}

void SY_SetRandomInitialized(object oObject, int bVal)
{
    SetLocalInt(oObject, "SY_RandomHistoryBufferInit", TRUE);
}

int SY_GetRandomSeed(object oObject)
{
    if (!GetIsObjectValid(oObject)) oObject = GetModule();

    int nSeed = GetLocalInt(oObject, "SY_RandomSeed");
    if (nSeed <= 0) nSeed = GetTimeMillisecond();
    int nNewSeed = (nSeed < 10) ? 1000 - (10-nSeed) : nSeed - 10;
    SetLocalInt(oObject, "SY_RandomSeed", nNewSeed);

    return nSeed;
}

// returns a random float between 0 and 1:
float SY_GetRandomMultiplier(object oObject)
{
    struct RandomHistoryBuffer strBuffer = SY_GetRandomHistoryBuffer(oObject);

    int nTemp = GetTimeMillisecond();
    float fTemp = IntToFloat(nTemp);
    fTemp = 65538 * strBuffer.x3 +
        2 * (strBuffer.x3 = strBuffer.x2) +
        1 * (strBuffer.x2 = strBuffer.x1) +
        5 * (strBuffer.x1 = strBuffer.x0) +
        strBuffer.x4;
    strBuffer.x4 = SY_Floor(fTemp);
    strBuffer.x0 = fTemp - SY_Floor(fTemp);
    strBuffer.x4 = strBuffer.x4 * (1./(256.*256.));

    SY_SetRandomHistoryBuffer(oObject, strBuffer);

    return strBuffer.x0;
}

void SY_RandomInit (object oObject, int nSeed)
{
    int i;
    int s = nSeed;

    struct RandomHistoryBuffer strBuffer = SY_InitRandomHistoryBuffer();

    // make random numbers and put them into the buffer
    s = FloatToInt(s * 65.6);
    for (i=0; i<5; i++)
    {
        s -= i;
        float x = abs(s) * (1./(256.*256.));
        strBuffer = SY_UpdateRandomBufferValue(strBuffer, i, x);
    }
    // Set the buffer on our object
    SY_SetRandomHistoryBuffer(oObject, strBuffer);
    // Let the object know it has been initialized
    SY_SetRandomInitialized(oObject, TRUE);

    // randomize the buffer some more now.
    int nLoops = d10();
    for (i=0; i < nLoops; i++) SY_GetRandomMultiplier(oObject);
}

float RandomF(float fMax=1., float fMin=0., int nSeed=0, object oObject = OBJECT_INVALID)
{
    fMin = (fMin > 0.0) ? fMin : 0.0;
    fMax = (fMax > fMin) ? fMax : fMin + 1.0;
    // if an object has not be specified or is invalid, use the module.
    oObject = (oObject == OBJECT_INVALID) ? GetModule() : oObject;
    // if a seed has not been passed, then generate a seed based on the clock
    int nMySeed = (nSeed > 0) ? nSeed : SY_GetRandomSeed(oObject);
    // If the random history buffer hasn't been initialized, do so now
    if (!SY_GetRandomInitialized(oObject))
        SY_RandomInit(oObject, nMySeed);
    float fRange = fMax - fMin;
    // Generate our number
    float fNum = fRange * SY_GetRandomMultiplier(oObject) + fMin;

    return fNum;
}

int RandomI(int nMax=1, int nMin=0, int nSeed=0, object oObject = OBJECT_INVALID)
{
    float fMin = (nMin > 0) ? IntToFloat(nMin) : 0.0;
    float fMax = (nMax > nMin) ? IntToFloat(nMax) : IntToFloat(nMin + 1);

    return FloatToInt(RandomF(fMax, fMin, nSeed, oObject));
}

// Uncomment only to test
/*
void main()
{
    int i;
    for (i=0;i<10;i++)
    {
        SY_RandomDebug(FloatToString(RandomF(100., 1.)));
    }
}
 */
