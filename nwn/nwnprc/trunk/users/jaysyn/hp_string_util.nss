//::///////////////////////////////////////////////
//:: String Util
//:: hp_string_util
//:://////////////////////////////////////////////
/*
    A util class for providing useful string functions.
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 22.05.2005
//:://////////////////////////////////////////////

//
// StringSplit
// Takes a string and splits it by " " into a json list of strings
// i.e. "this   is a test" returns
// {
//   "this",
//   "is",
//   "a",
//   "test"
// }
//
// Parameters:
//   string input the string input
//
// Returns:
//   json the json list of words
//
json StringSplit(string input);

//
// TrimString
// Takes a string and trims any leading whitespace characters
// i.e. "   this is a test" returns
// "this is a test"
//
// Parameters:
//   input string the input string to trim
//
// Returns:
//   string the trimmed string
//
string TrimString(string input);

json StringSplit(string input)
{
    json retValue = JsonArray();

    string subString = "";
    //trim any whitespace characters first
    string currString = TrimString(input);

    // loop until we process the whole string
    while(currString != "")
    {
        string currChar = GetStringLeft(currString, 1);
        if (currChar != "" && currChar != " ")
        {
            // if the current character isn't nothing or whitespace, then add it
            // to the current sub string.
            subString += currChar;
        }
        else
        {
            // otherwise if the substring is not empty, then add it to the list
            // of words to return
            if(subString != "")
            {
                retValue = JsonArrayInsert(retValue, JsonString(subString));
                subString = "";
            }
        }

        // pop and move to next character
        currString = GetStringRight(currString, GetStringLength(currString)-1);
    }

    // if there is any sub string left at the end of the loop, add it to the list
    if(subString != "")
    {
        retValue = JsonArrayInsert(retValue, JsonString(subString));
    }

    return retValue;
}

string TrimString(string input)
{
    string retValue = input;

    // while the string is not empty and we are looking at a whitespace, pop it.
    while(retValue != "" && GetStringLeft(retValue, 1) == " ")
    {
        retValue = GetStringRight(retValue, GetStringLength(retValue)-1);
    }

    return retValue;
}