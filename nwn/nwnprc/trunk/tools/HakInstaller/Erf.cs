using System;
using System.Collections;
using System.Collections.Specialized;
using System.IO;
using System.Globalization;
using System.Runtime.InteropServices;
using System.Text;
using NWN.FileTypes.Tools;

namespace NWN.FileTypes.Tools
{
	/// <summary>
	/// This enum defines all of the different resources that can be stored
	/// in an ERF file.
	/// </summary>
	public enum ResType : ushort
	{
		#region values
		Invalid = 0xffff,
		ResBMP = 1,
		ResTGA = 3,
		ResWAV = 4,
		ResPLT = 6,
		ResINI = 7,
		ResBMU = 8,
		ResTXT = 10,
		ResMDL = 2002,
		ResNSS = 2009,
		ResNCS = 2010,
		ResARE = 2012,
		ResSET = 2013,
		ResIFO = 2014,
		ResBIC = 2015,
		ResWOK = 2016,
		Res2DA = 2017,
		ResTXI = 2022,
		ResGIT = 2023,
		ResUTI = 2025,
		ResUTC = 2027,
		ResDLG = 2029,
		ResITP = 2030,
		ResUTT = 2032,
		ResDDS = 2033,
		ResUTS = 2035,
		ResLTR = 2036,
		ResGFF = 2037,
		ResFAC = 2038,
		ResUTE = 2040,
		ResUTD = 2042,
		ResUTP = 2044,
		ResDFT = 2045,
		ResGIC = 2046,
		ResGUI = 2047,
		ResUTM = 2051,
		ResDWK = 2052,
		ResPWK = 2053,
		ResJRL = 2056,
		ResUTW = 2058,
		ResSSF = 2060,
		ResNDB = 2064,
		ResPTM = 2065,
		ResPTT = 2066
		#endregion
	}


	/// <summary>
	/// Class that facilitates debug logging.  It provides a way for all of the NWN tools
	/// to do logging via a single object.  Implementation is a singleton.
	/// </summary>
	public class NWNLogger
	{
		#region public static properties/methods
		/// <summary>
		/// Gets/sets the name of the log file.  This should not have any path information
		/// it should just be a file name.  The log is automatically created in the NWN logs
		/// folder.
		/// </summary>
		public static string LogFile
		{
			get { return logFile; }
			set { logFile = value; }
		}

		/// <summary>
		/// Gets/sets the minimum severity level that is logged.  If this is set to
		/// 0 then all messages are logged, if set to a number higher than 0, only messages
		/// with that severity or higher are logged.
		/// </summary>
		public static int MinimumLogLevel
		{
			get { return minLevel; }
			set { minLevel = value; }
		}

		/// <summary>
		/// Enables/disables logging.
		/// </summary>
		public static bool Logging
		{
			get { return null != stream; }
			set
			{
				// If we're not logging and logging is turned on then open the
				// log file.
				if (value && null == stream)
				{
					// Get the full name of the log file.
					string logPath = Path.Combine(NWNInfo.InstallPath, "logs");
					string logFullName = Path.Combine(logPath, logFile);

					// Create/append the log file and add a header to indicate a new log session.
					stream = new StreamWriter(logFullName, true, Encoding.ASCII);
					stream.WriteLine("");
					stream.WriteLine("");
					stream.WriteLine("");
					stream.WriteLine("*********************************************************");
					stream.WriteLine("Logging started at {0}", DateTime.Now);
					stream.WriteLine("*********************************************************");
					stream.WriteLine("");
				}

				// If we're logging and logging is turned off then flush and close
				// the log file and null our object reference.
				if (!value && null != stream)
				{
					stream.Flush();
					stream.Close();
					stream = null;
				}
			}
		}

		/// <summary>
		/// Logs the given format string and arguments to the log file if logging is enabled.
		/// </summary>
		/// <param name="level">The importance level of the message, the higher the number
		/// the more important the message.</param>
		/// <param name="format">The format string</param>
		/// <param name="args">The format string's data</param>
		public static void Log(int level, string format, params object[] args)
		{
			// If we are logging and the message is important enough then log it.
			if (null != stream && level >= minLevel)
			{
				stream.WriteLine(format, args);
				stream.Flush();
			}
		}
		#endregion

		#region private static fields/properties/methods
		private static int minLevel = 0;
		private static string logFile = "NWNLogger.txt";
		private static StreamWriter stream;
		#endregion
	}

	/// <summary>
	/// This class contains functionality to serialize/deserialize objects
	/// to streams and byte arrays.
	/// </summary>
	internal sealed class RawSerializer
	{
		#region public static methods to deserialize raw data
		/// <summary>
		/// Deserializes an object of the given type from a stream.  The stream
		/// is assumed to contain the object's raw data at the current seek
		/// position.
		/// </summary>
		/// <param name="t">The type of object to deserialize</param>
		/// <param name="stream">The stream</param>
		/// <returns>The deserialized object</returns>
		public static object Deserialize (Type t, Stream stream)
		{
			// Allocate a buffer to hold an object of the given type, and
			// read the raw object data from the file.
			//NWNLogger.Log(0, "RawSerializer.Deserialize entering");
			if (null == t) NWNLogger.Log(10, "t is null!!!");
			if (null == stream) NWNLogger.Log(10, "stream is null!!!");
			//NWNLogger.Log(0, "RawSerializer.Deserialize({0}, {1})", t.Name, stream.GetType().Name);
			int size = Marshal.SizeOf(t);
			//NWNLogger.Log(0, "RawSerializer.Deserialize sizeof(t) = {0}, allocing byte array", size);
			byte[] buffer = new Byte[size];
			//NWNLogger.Log(0, "RawSerializer.Deserialize reading {0} bytes from stream", buffer.Length);
			if (stream.Read(buffer, 0, buffer.Length) != buffer.Length) return null;

			// Deserialize from the raw data.
			//NWNLogger.Log(0, "RawSerializer.Deserialize calling Deserialize overload");
			return Deserialize(t, buffer);
		}

		/// <summary>
		/// Deserializes an object of the given type from a byte array.  The byte
		/// array is assumed to contain the object's raw data.
		/// </summary>
		/// <param name="t">The type of object to deserialize</param>
		/// <param name="buffer">The byte array containing the object's
		/// raw data</param>
		/// <returns>The deserialized object</returns>
		public static object Deserialize (Type t, byte[] buffer)
		{
			// Alloc a hglobal to store the bytes.
			//NWNLogger.Log(0, "RawSerializer.Deserialize Marshal.AllocHGlobal({0})", buffer.Length);
			IntPtr ptr = Marshal.AllocHGlobal(buffer.Length);
			try
			{
				// Copy the data to unprotected memory, then convert it to a STlkHeader
				// structure
				//NWNLogger.Log(0, "RawSerializer.Deserialize calling Marshal.Copy()");
				Marshal.Copy(buffer, 0, ptr, buffer.Length);
				//NWNLogger.Log(0, "RawSerializer.Deserialize calling Marshal.PtrToStructure()");
				object o = Marshal.PtrToStructure(ptr, t);
				//NWNLogger.Log(0, "RawSerializer.Deserialize created object of type {0}", 
				//	null == o ? "null" : o.GetType().Name);
				return o;
			}
			finally
			{
				// Free the hglobal before exiting.
				//NWNLogger.Log(0, "RawSerializer.Deserialize calling Marshal.FreeHGlobal()");
				Marshal.FreeHGlobal(ptr);
			}
		}

		/// <summary>
		/// Deserializes an ANSI string from the passed byte array.
		/// </summary>
		/// <param name="buffer">The byte array</param>
		/// <returns>The deserialized string.</returns>
		public static string DeserializeString(byte[] buffer)
		{
			return DeserializeString(buffer, 0, buffer.Length);
		}

		/// <summary>
		/// Deserializes an ANSI string from the passed byte array.
		/// </summary>
		/// <param name="buffer">The byte array</param>
		/// <param name="offset">The offset into the byte array of the
		/// start of the string</param>
		/// <param name="length">The length of the string in the array</param>
		/// <returns>The deserialized string.</returns>
		public static string DeserializeString(byte[] buffer, int offset, int length)
		{
			// figure out how many chars in the string are really used.  If we
			// don't do this then the extra null bytes at the end get included
			// in the string length which messes up .NET internally.
			int used = 0;
			for (; used < length; used++)
				if (0 == buffer[offset + used]) break;

			// If the string is empty then just return that.
			if (0 == used) return string.Empty;

			// Alloc a hglobal to store the bytes.
			IntPtr ptr = Marshal.AllocHGlobal(used);
			try
			{
				// Copy the data to unprotected memory, then convert it to a STlkHeader
				// structure
				Marshal.Copy(buffer, offset, ptr, used);
				object o = Marshal.PtrToStringAnsi(ptr, used);
				return (string) o;
			}
			finally
			{
				// Free the hglobal before exiting.
				Marshal.FreeHGlobal(ptr);
			}
		}
		#endregion

		#region public static methods to serialize raw data
		/// <summary>
		/// Serializes the passed object to the stream.
		/// </summary>
		/// <param name="s">The stream to serialize the object to</param>
		/// <param name="o">The object to serialize</param>
		public static void Serialize(Stream s, object o)
		{
			byte[] buffer = Serialize(o);
			s.Write(buffer, 0, buffer.Length);
		}

		/// <summary>
		/// Serializes the passed object to a byte array.
		/// </summary>
		/// <param name="o">The object to serialize</param>
		/// <returns>A byte array containing the object's raw data</returns>
		public static byte[] Serialize(object o)
		{
			// Allocate a hglobal to store the object's data.
			int rawsize = Marshal.SizeOf(o);
			IntPtr buffer = Marshal.AllocHGlobal(rawsize);
			try
			{
				// Copy the object to unprotected memory, then copy that to a byte array.
				Marshal.StructureToPtr(o, buffer, false);
				byte[] rawdata = new byte[rawsize];
				Marshal.Copy(buffer, rawdata, 0, rawsize);
				return rawdata;
			}
			finally
			{
				// Free the hglobal before exiting
				Marshal.FreeHGlobal(buffer);
			}
		}

		/// <summary>
		/// Serializes a string to a fixed length byte array.
		/// </summary>
		/// <param name="s">The string to serialize</param>
		/// <param name="length">The length of the resultant byte array.  The
		/// string will be truncated or nulls will be added as necessary to
		/// make the byte array be this length</param>
		/// <param name="includeNull">Indicates whether the string's trailing null
		/// byte should be included in length.</param>
		/// <returns>A byte array of length length containing the serialized string</returns>
		public static byte[] SerializeString(string s, int length, bool includeNull)
		{
			// Figure out how many real characters we can have in the string, if
			// we are saving the null in the buffer we have to account for it.
			int adjustedLen = includeNull ? length - 1 : length;

			// If the string is too long then trim it, then
			// convert it to 
			if (s.Length > adjustedLen) s = s.Substring(0, adjustedLen);
			IntPtr ptr = Marshal.StringToHGlobalAnsi(s);
			try
			{
				// Allocate a buffer for the data with the proper length, copy
				// the string data, then pad with nulls if necessary.
				byte[] buffer = new byte[length];
				Marshal.Copy(ptr, buffer, 0, s.Length);
				for (int i = s.Length; i < length; i++) buffer[i] = 0;
				return buffer;
			}
			finally
			{
				Marshal.FreeHGlobal(ptr);
			}
		}
		#endregion
	}
}



namespace NWN.FileTypes
{
	/// <summary>
	/// Enum defining the various languages that strings may be.
	/// </summary>
	public enum LanguageID 
	{
		#region values
		English = 0, 
		French = 1, 
		German = 2,
		Italian = 3, 
		Spanish = 4, 
		Polish = 5, 
		Korean = 128,
		ChineseTrad = 129, 
		ChineseSimple = 130, 
		Japanese = 131
		#endregion
	}


	/// <summary>
	/// Class for all NWN exceptions.
	/// </summary>
	public class NWNException: Exception
	{
		#region public properties/methods
		/// <summary>
		/// Constructor to build the exception from just a string
		/// </summary>
		/// <param name="s">Error message</param>
		public NWNException (string s) : base(s)
		{
		}

		/// <summary>
		/// Constructor to build the exception from a formatted message.
		/// </summary>
		/// <param name="format">Format string</param>
		/// <param name="args">Message arguments for the format string</param>
		public NWNException (string format, params object[] args) : 
			base(Format(format, args))
		{
		}
		#endregion

		#region private fields/properties/methods
		/// <summary>
		/// Method to format a string from a format string and arguments.
		/// </summary>
		/// <param name="format">Format string</param>
		/// <param name="args">Argument list</param>
		/// <returns>Formatted string</returns>
		private static string Format(string format, params object[] args)
		{
			StringBuilder b = new StringBuilder();
			b.AppendFormat(format, args);
			return b.ToString();
		}
		#endregion
	}



	/// <summary>
	/// This class is used to manipulate an ERF file.  The ERF file format is used
	/// for ERF, MOD, SAV, and HAK files.  This class allows any of those files to
	/// be decompressed and modified.
	/// </summary>
	public class Erf
	{
		#region public nested enums/structs/classes
		/// <summary>
		/// Enum for the different types of ERF files.
		/// </summary>
		public enum ErfType { HAK, MOD, ERF, SAV };

		/// <summary>
		/// This structure defines a string value as stored in an ERF file.
		/// It provides functionality to serialize/deserialize the raw data.
		/// </summary>
		public struct ErfString
		{
			#region public properties/methods
			/// <summary>
			/// Gets the number of bytes the string will be when saved in
			/// the stream.
			/// </summary>
			public int SizeInStream
			{
				get
				{
					// The size of the string in the stream is 8 bytes (4 for
					// the language ID, 4 for the string size) plus the
					// string length.
					return 8 + val.Length + (IncludeNull ? 1 : 0);
				}
			}

			/// <summary>
			/// Gets the language ID for the string.
			/// </summary>
			public LanguageID Language { get { return (LanguageID) languageID; } }

			/// <summary>
			/// Gets/sets the string value.
			/// </summary>
			public string Value
			{
				get { return val; }
				set { val = value; }
			}

			/// <summary>
			/// Class constructor
			/// </summary>
			/// <param name="s">The string value</param>
			/// <param name="type">The type of ERF the string is coming from, some ERFs
			/// have null terminated strings and some do not</param>
			public ErfString(string s, ErfType type)
			{
				// 0 is English.
				languageID = (Int32) LanguageID.English;
				val = s;
				this.type = type;
			}

			/// <summary>
			/// Class constructor to deserialize an ErfString.
			/// </summary>
			/// <param name="s">The stream containing the raw data.</param>
			/// <param name="type">The type of ERF the string is coming from, some ERFs
			/// have null terminated strings and some do not</param>
			public ErfString(Stream s, ErfType type)
			{
				// Read the language ID from the stream.
				byte[] buffer = new Byte[4];
				if (buffer.Length != s.Read(buffer, 0, buffer.Length))
					throw new NWNException("Invalid erf string in stream");
				languageID = BitConverter.ToInt32(buffer, 0);
				
				// Read the number of bytes in the string from the stream.
				if (buffer.Length != s.Read(buffer, 0, buffer.Length))
					throw new NWNException("Invalid erf string in stream");
				Int32 size = BitConverter.ToInt32(buffer, 0);

				// Read the string bytes from the stream.
				buffer = new byte[size];
				if (buffer.Length != s.Read(buffer, 0, buffer.Length))
					throw new NWNException("Invalid erf string in stream");
				val = RawSerializer.DeserializeString(buffer);
				this.type = type;
			}

			/// <summary>
			/// Method to serialize the ErfString to a stream.
			/// </summary>
			/// <param name="s"></param>
			public void Serialize(Stream s)
			{
				// Write the structure's data to the stream.
				RawSerializer.Serialize(s, languageID);
				int count = val.Length + (IncludeNull ? 1 : 0);
				RawSerializer.Serialize(s, (Int32) count);
				byte[] buffer = RawSerializer.SerializeString(val, val.Length, false);
				s.Write(buffer, 0, buffer.Length);

				// Write a null byte if needed.
				if (IncludeNull)
				{
					buffer[0] = 0;
					s.Write(buffer, 0, 1);
				}
			}
			#endregion

			#region public static methods
			/// <summary>
			/// Deserializes a number of ErfString objects from the passed stream,
			/// placing them into an array.
			/// </summary>
			/// <param name="s">The stream</param>
			/// <param name="count">The number of strings to deserialize</param>
			/// <param name="type">The type of ERF the string is coming from, some ERFs
			/// have null terminated strings and some do not</param>
			/// <returns>An ErfString array with the strings</returns>
			public static ErfString[] Deserialize(Stream s, int count, ErfType type)
			{
				ErfString[] estrings = new ErfString[count];
				for (int i = 0; i < count; i++)
					estrings[i] = new ErfString(s, type);
				return estrings;
			}

			/// <summary>
			/// Serializes a number of ErfStrings from the passed array.
			/// </summary>
			/// <param name="s">The stream</param>
			/// <param name="estrings">The ErfString structures to serialize</param>
			public static void Serialize(Stream s, ErfString[] estrings)
			{
				foreach (ErfString estring in estrings)
					estring.Serialize(s);
			}
			#endregion

			#region private fields/properties/methods
			private Int32 languageID;
			private string val;
			private ErfType type;

			/// <summary>
			/// Returns true if the null terminator should be included in
			/// the string's length.
			/// </summary>
			private bool IncludeNull { get { return ErfType.ERF == type || ErfType.HAK == type; } }
			#endregion
		}
		#endregion

		#region public properties/methods
		/// <summary>
		/// Gets the number of files in the ERF.
		/// </summary>
		public int FileCount
		{
			get { return header.EntryCount + addedFileHash.Count - removedFiles.Count; }
		}

		/// <summary>
		/// Gets the name of the ERF file if it represents a file on disk.
		/// </summary>
		public string FileName 
		{ get { return null == fileInfo ? string.Empty : fileInfo.FullName; } }

		/// <summary>
		/// Gets the list of files in the erf.
		/// </summary>
		public StringCollection Files
		{
			get
			{
				StringCollection files = new StringCollection();

				// Add all of the files that were in the erf to start with.
				foreach (ErfKey key in keys)
					files.Add(key.FileName);

				// Add any added files.
				string[] strings = new string[addedFileHash.Count];
				addedFileHash.Values.CopyTo(strings, 0);
				files.AddRange(strings);

				return files;
			}
		}

		/// <summary>
		/// Gets the collection of replaced files.
		/// </summary>
		public StringCollection ReplacedFiles
		{
			get
			{
				// Get all of the strings from the hash table.
				string[] strings = new string[replacedFileHash.Count];
				replacedFileHash.Values.CopyTo(strings, 0);

				// Copy the strings to a string array and return it.
				StringCollection collection = new StringCollection();
				collection.AddRange(strings);
				return collection;
			}
		}

		/// <summary>
		/// Gets the collection of added files.
		/// </summary>
		public StringCollection AddedFiles
		{
			get
			{
				// Get all of the strings from the hash table.
				string[] strings = new string[addedFileHash.Count];
				addedFileHash.Values.CopyTo(strings, 0);

				// Copy the strings to a string array and return it.
				StringCollection collection = new StringCollection();
				collection.AddRange(strings);
				return collection;
			}
		}

		/// <summary>
		/// Default constructor
		/// </summary>
		private Erf()
		{
			removedFiles = new StringCollection();
			keyHash = new Hashtable(5000);
			addedFileHash = new Hashtable(1000);
			replacedFileHash = new Hashtable(1000);
			decompressedPath = string.Empty;
		}

		/// <summary>
		/// Returns true if the ERF contains a file with the given file name.
		/// </summary>
		/// <param name="fileName">The file to look for</param>
		/// <returns>True if the ERF contains the file, false if it does not.</returns>
		public bool Contains(string fileName)
		{
			// Get the key for the file name.
			string key = GetKey(fileName);

			// Check to see if the file is in the ERF key list.
			if (keyHash.Contains(key)) return true;

			// Check to see if the file is in the added file list.
			if (addedFileHash.Contains(key)) return true;

			return false;
		}

		/// <summary>
		/// Adds an existing file to the ERF.  The actual erf file is
		/// not modified until RecreateFile() is called, the reference
		/// to the file is merely saved.
		/// </summary>
		/// <param name="fileName">The name of the file to add</param>
		/// <param name="overwrite">Indicates whether to overwrite the file
		/// if it already exists</param>
		public void AddFile(string fileName, bool overwrite)
		{
			// Ignore ExportInfo.GFF, a file in all ERF's.
			if ("exportinfo.gff" == Path.GetFileName(fileName).ToLower()) return;

			// Make sure the file really exists.
			if (!File.Exists(fileName)) 
				throw new NWNException("Cannot add non-existant file {0}", fileName);

			// Make sure that the file isn't already in the ERF.
			bool contains = Contains(fileName);
			if (contains && !overwrite)
				throw new NWNException("File {0} is already in the erf", fileName);

			// Just add the file to our added/replaced files collection, depending
			// on whether it's already in the erf or not.
			if (contains)
				replacedFileHash.Add(GetKey(fileName), fileName);
			else
				addedFileHash.Add(GetKey(fileName), fileName);
		}

		/// <summary>
		/// Removes a file from the added/replaced file lists.
		/// </summary>
		/// <param name="fileName">The name of the file to remove</param>
		public void RemoveFileFromAddedList(string fileName)
		{
			// Get the key for the file name.
			string key = GetKey(fileName);

			// Check to see if the file is in the added file list.
			if (addedFileHash.Contains(key))
				addedFileHash.Remove(key);
			else if (replacedFileHash.Contains(key))
				replacedFileHash.Remove(key);
		}

		/// <summary>
		/// Saves the ERF file under the specified name.
		/// </summary>
		/// <param name="fileName">The name of the file.</param>
		public void SaveAs(string fileName)
		{
NWNLogger.Log(0, "module.SaveAs entering [{0}]", fileName);
			// The ERF must be decompressed first unless it is a new ERF.
			if (keys.Length > 0 && string.Empty == decompressedPath)
				throw new NWNException("ERF must be decompressed to recreate");

			// Copy all of the modified files into the temp directory
			StringCollection replacedFiles = ReplacedFiles;
NWNLogger.Log(0, "module.SaveAs copying {0} modified files into temp directory", replacedFiles.Count);
			foreach (string file in replacedFiles)
				File.Copy(file, Path.Combine(decompressedPath, 
					Path.GetFileName(file)), true);

			// Figure out the new number of files in the ERF and create new
			// key/resource arrays of the proper size.
			int fileCount = keys.Length + addedFileHash.Count - removedFiles.Count;
NWNLogger.Log(0, "module.SaveAs {0} total files, allocating key/resource arrays", fileCount);
			ErfKey[] newKeys = new ErfKey[fileCount];
			ErfResource[] newResources = new ErfResource[fileCount];

			// Create a buffer to store the data.
NWNLogger.Log(0, "module.SaveAs creating memory stream");
			MemoryStream buffer = new MemoryStream();

			// Copy all of the existing not-removed files into the new key/resource
			// arrays.
			int index = 0;
			for (int i = 0; i < keys.Length; i++)
			{
				string file = keys[i].FileName;
				if (string.Empty == file || removedFiles.Contains(file)) continue;

				// Copy the key/resource pair over.
NWNLogger.Log(1, "module.SaveAs copying file[{0}] '{1}'", i, file);
				newKeys[index] = keys[i];
				newResources[index] = resources[i];

				// Read the file into the buffer.
				ReadFileIntoStream(Path.Combine(decompressedPath, file),
					ref newResources[index], buffer);

				index++;
			}

			// Add all of the new files to the key/resource arrays.
			StringCollection addedFiles = AddedFiles;
			foreach (string file in addedFiles)
			{
NWNLogger.Log(1, "module.SaveAs adding new file '{0}'", file);
				newKeys[index] = new ErfKey(file);
				newResources[index] = new ErfResource();

				// Read the file into the buffer.
				ReadFileIntoStream(file, ref newResources[index], buffer);
				index++;
			}

			// Figure out how big our descriptions are going to be.
NWNLogger.Log(0, "module.SaveAs calcing description size");
			int descriptionsCount = 0;
			for (int i = 0; i < descriptions.Length; i++)
				descriptionsCount += descriptions[i].SizeInStream;

			// Create a new resource header and calculate the new offsets.
NWNLogger.Log(0, "module.SaveAs creating header");
			ErfHeader newHeader = header;
			newHeader.OffsetToLocalizedString = Marshal.SizeOf(typeof(ErfHeader));
			newHeader.OffsetToKeyList = newHeader.OffsetToLocalizedString + descriptionsCount;
			newHeader.EntryCount = fileCount;
			newHeader.OffsetToResourceList = newHeader.OffsetToKeyList + 
				(fileCount * Marshal.SizeOf(typeof(ErfKey)));

			// Calculate the offset to the beginning of the resource data and adjust
			// the offsets in the resource array to take this into account.
NWNLogger.Log(0, "module.SaveAs calcing offsets");
			int offsetToData = newHeader.OffsetToResourceList +
				(fileCount * Marshal.SizeOf(typeof(ErfResource)));
			for (int i = 0; i < newResources.Length; i++)
				newResources[i].OffsetToResource += offsetToData;

			// Create the new file and write the data to it.
NWNLogger.Log(0, "module.SaveAs creating output file");
			string newName = fileName + ".New";
			using (FileStream writer = new FileStream(newName, FileMode.Create, 
					   FileAccess.Write, FileShare.Write))
			{
NWNLogger.Log(0, "module.SaveAs writing header");
				newHeader.Serialize(writer);
NWNLogger.Log(0, "module.SaveAs writing strings");
				ErfString.Serialize(writer, descriptions);
NWNLogger.Log(0, "module.SaveAs writing keys");
				ErfKey.Serlialize(writer, newKeys);
NWNLogger.Log(0, "module.SaveAs writing resources");
				ErfResource.Serlialize(writer, newResources);
NWNLogger.Log(0, "module.SaveAs writing raw data");
				writer.Write(buffer.GetBuffer(), 0, (int) buffer.Length);

NWNLogger.Log(0, "module.SaveAs flushing and closing");
				writer.Flush();
				writer.Close();
			}

			// Delete the old file and rename the new file to the proper name.
NWNLogger.Log(0, "module.SaveAs copying over current file");
			File.Copy(newName, fileName, true);
NWNLogger.Log(0, "module.SaveAs deleting");
			File.Delete(newName);

			// Update the ERF's field's with the new values.
NWNLogger.Log(0, "module.SaveAs updating object definition");
			header = newHeader;
			keys = newKeys;
			resources = newResources;

			// Clear our string collections.
			replacedFileHash.Clear();
			addedFileHash.Clear();
			removedFiles.Clear();

			fileInfo = new FileInfo(fileName);
		}

		/// <summary>
		/// Rebuilds the ERF disk file.  Any added/removed/changed files will be
		/// reflected in the new file.
		/// </summary>
		public void RecreateFile()
		{
			SaveAs(fileInfo.FullName);
		}

		/// <summary>
		/// Decompresses the ERF to the specified directory.
		/// </summary>
		/// <param name="path">The path to decompress the erf to</param>
		public void Decompress(string path)
		{
			try
			{
				// If the path doesn't exist then create it.
				NWNLogger.Log(1, "Erf.Decompress creating path {0}", path);
				if (!Directory.Exists(path)) Directory.CreateDirectory(path);

				// If this is not a new blank ERF then decompress it.
				if (null != fileInfo)
				{
					// Open the file.
					NWNLogger.Log(1, "Erf.Decompress opening erf {0}", fileInfo.FullName);
					using (FileStream reader = new FileStream(fileInfo.FullName, FileMode.Open, 
							   FileAccess.Read, FileShare.Read))
					{
						// Loop through all of key/resource entries.
						NWNLogger.Log(0, "Erf.Decompress reading keys");
						for (int i = 0; i < header.EntryCount; i++)
						{
							// Ignore empty file names, why this can happen I don't know but
							// it does.
							if (string.Empty == keys[i].FileName)
							{
								NWNLogger.Log(2, "Erf.Decompress key[{0}] contains empty file name", i);
								continue;
							}

							// Generate the full path to the output file and create it.
							string outFile = Path.Combine(path, keys[i].FileName);
							//NWNLogger.Log(1, "Erf.Decompress creating file {0}", outFile);
							using (FileStream writer = new FileStream(outFile, FileMode.Create, 
									   FileAccess.Write, FileShare.None))
							{
								// Read the file data from the ERF.
								//NWNLogger.Log(0, "Erf.Decompress reading file data from erf");
								byte[] buffer = new byte[resources[i].ResourceSize];
								reader.Seek(resources[i].OffsetToResource, SeekOrigin.Begin);
								if (buffer.Length != reader.Read(buffer, 0, buffer.Length))
									throw new NWNException("Cannot read data for {0}", keys[i].FileName);

								// Write the data to the output file.
								NWNLogger.Log(0, "Erf.Decompress file data to decompressed file");
								writer.Write(buffer, 0, buffer.Length);
								writer.Flush();
								writer.Close();
							}
						}
					}
				}

				// Save the path that we decompressed the files to so that we know
				// that the files have been decompressed and where they are.
				decompressedPath = path;
			}
			catch (Exception)
			{
				// If we have a problem we have to delete any decompressed files.
				Directory.Delete(path, true);
				throw;
			}
		}
		#endregion

		#region public static methods
		/// <summary>
		/// Gets the number of files contained in the specifed ERF file.
		/// </summary>
		/// <param name="fileName">The name of the file</param>
		/// <returns>The number of files in the ERF</returns>
		public static int GetFileCount(string fileName)
		{
			using (FileStream reader = new FileStream(fileName, FileMode.Open))
			{
				// Read the header from the ERF and return the number of files.
				ErfHeader header = new ErfHeader(reader);
				return header.EntryCount;
			}
		}

		/// <summary>
		/// This method loads a single file from the specified erf, returning
		/// a MemoryStream containing the file's contents.
		/// </summary>
		/// <param name="erf">The erf containing the file</param>
		/// <param name="file">The file to load</param>
		/// <returns>A MemoryStream containing the file's data</returns>
		public static MemoryStream GetFile(string erf, string file)
		{
			// Open the erf file.
			NWNLogger.Log(0, "Erf.GetFile({0}, {1}) entering", erf, file);
			using (FileStream reader = 
					   new FileStream(erf, FileMode.Open, FileAccess.Read, FileShare.Read))
			{
				// Read the header from the ERF
				ErfHeader header = new ErfHeader(reader);
				NWNLogger.Log(0, "Erf.GetFile({0}, {1}) has {2} files", erf, file, header.EntryCount);

				// Read the key (file) list from the ERF.
				reader.Seek(header.OffsetToKeyList, SeekOrigin.Begin);
				ErfKey[] keys = ErfKey.Deserialize(reader, header.EntryCount);
				NWNLogger.Log(0, "Erf.GetFile({0}, {1}) read {2} keys", erf, file, keys.Length);

				// Read the resource (file) list from the ERF.
				reader.Seek(header.OffsetToResourceList, SeekOrigin.Begin);
				ErfResource[] resources = ErfResource.Deserialize(reader, header.EntryCount);
				NWNLogger.Log(0, "Erf.GetFile({0}, {1}) read {2} resources", erf, file, resources.Length);

				// Loop through all of the resources in the erf looking for the file.
				for (int i = 0; i < keys.Length; i++)
				{
					// Check to see if this is the file we're looking for.
					NWNLogger.Log(1, "Erf.GetFile('{0}', '{1}'), keys[{2}].FileName '{3}'", erf, file, i, keys[i].FileName);
					//if (keys[i].FileName.ToLower() == file.ToLower())
					if (0 == string.Compare(keys[i].FileName, file, true, CultureInfo.InvariantCulture))
					{
						NWNLogger.Log(1, "Erf.GetFile('{0}', '{1}'), match!", erf, file);
						// We found our file, create a MemoryStream large enough to hold the file's
						// data and load the data into the stream.
						byte[] buffer = new Byte[resources[i].ResourceSize];
						reader.Seek(resources[i].OffsetToResource, SeekOrigin.Begin);
						reader.Read(buffer, 0, resources[i].ResourceSize);
						NWNLogger.Log(1, "Erf.GetFile('{0}', '{1}'), creating MemoryStream from {2} bytes!", erf, file, buffer.Length);
						return new MemoryStream(buffer, false);
					}
				}

				return null;
			}
		}

		/// <summary>
		/// Loads the specified ERF file, returning an instance to it.
		/// </summary>
		/// <param name="fileName">The name of the ERF file to load</param>
		/// <returns>An Erf object for the file</returns>
		public static Erf Load(string fileName)
		{
			// Open the erf file.
			Erf erf = new Erf();
			using (FileStream reader = 
				new FileStream(fileName, FileMode.Open, FileAccess.Read, FileShare.Read))
			{
				erf.fileInfo = new FileInfo(fileName);

				// Read the header from the ERF
				erf.header = new ErfHeader(reader);

				// Read the description(s) from the ERF
				reader.Seek(erf.header.OffsetToLocalizedString, SeekOrigin.Begin);
				erf.descriptions = ErfString.Deserialize(reader, erf.header.LanguageCount,
					erf.header.ErfType);

				// Read the key (file) list from the ERF.
				reader.Seek(erf.header.OffsetToKeyList, SeekOrigin.Begin);
				erf.keys = ErfKey.Deserialize(reader, erf.header.EntryCount);

				// Build the keys's hash table for fast access to files.
				foreach (ErfKey key in erf.keys)
					try
					{
						erf.keyHash.Add(key.FileName.ToLower(), key);
					}
					catch (ArgumentException)
					{}

				// Read the resource (file) list from the ERF.
				reader.Seek(erf.header.OffsetToResourceList, SeekOrigin.Begin);
				erf.resources = ErfResource.Deserialize(reader, erf.header.EntryCount);
			}

			return erf;
		}

		/// <summary>
		/// Creates a new, empty ERF file of the specified type.
		/// </summary>
		/// <param name="type">The type of the ERF</param>
		/// <param name="description">The ERF's description</param>
		/// <returns></returns>
		public static Erf New(ErfType type, string description)
		{
			// Create the ERF file and it's header.
			Erf erf = new Erf();
			erf.header = new ErfHeader(type);

			// Create empty key/resource files since an empty ERF contains 0 files.
			erf.keys = new ErfKey[0];
			erf.resources = new ErfResource[0];

			// Create an ErfString for the description.
			erf.descriptions = new ErfString[1];
			erf.descriptions[0] =  new ErfString(description, type);

			// Setup the header to account for our description.
			erf.header.LanguageCount = 1;
			erf.header.LocalizedStringSize = erf.descriptions[0].SizeInStream;
			erf.header.OffsetToLocalizedString = Marshal.SizeOf(typeof(ErfHeader));
			erf.header.OffsetToKeyList = erf.header.OffsetToLocalizedString + 
				erf.header.LocalizedStringSize;

			return erf;
		}
		#endregion

		#region private nested structures
		/// <summary>
		/// This structure is the header of the ERF file.  It maps directly over
		/// the ERF raw data in the file and provides functionality to
		/// serialize/deserialize the raw data.
		/// </summary>
		[StructLayout(LayoutKind.Sequential, Pack=1, CharSet=CharSet.Ansi)] 
			private struct ErfHeader
		{
			#region public properties
			/// <summary>
			/// Gets/sets the type of the ERF
			/// </summary>
			public ErfType ErfType
			{
				get
				{
					return (ErfType) System.Enum.Parse(typeof(ErfType), Type, true);
				}
				set
				{
					Type = value.ToString();
				}
			}

			/// <summary>
			/// Gets/sets the type of the ERF.  Valid types are 
			/// "ERF", "MOD", "SAV", "HAK".
			/// </summary>
			public string Type
			{
				get
				{
					string s = RawSerializer.DeserializeString(type);
					return s.Trim();
				}
				set
				{
					string s = value.ToUpper().PadRight(4, ' ');
				}
			}

			/// <summary>
			/// Gets the file version as a string, in the format "V1.0".
			/// </summary>
			public string VersionText
			{
				get { return RawSerializer.DeserializeString(version); }
			}

			/// <summary>
			/// Gets the file version as a double.
			/// </summary>
			public double Version
			{
				get 
				{
					string version = VersionText;
					return System.Convert.ToDouble(version.Substring(1, version.Length - 1));
				}
			}

			/// <summary>
			/// Gets the number of different languages that the module description
			/// is stored in.  There will be 1 description entry for each language.
			/// </summary>
			public int LanguageCount
			{
				get { return languageCount; }
				set { languageCount = value; }
			}

			/// <summary>
			/// Gets/sets the localized string size for the description.
			/// </summary>
			public int LocalizedStringSize
			{
				get { return localizedStringSize; }
				set { localizedStringSize = value; }
			}

			/// <summary>
			/// Gets/sets the number of files in the ERF
			/// </summary>
			public int EntryCount
			{
				get { return entryCount; }
				set { entryCount = value; }
			}

			/// <summary>
			/// Gets/sets the offset to the localized strings
			/// </summary>
			public int OffsetToLocalizedString
			{
				get { return offsetToLocalizedString; }
				set { offsetToLocalizedString = value; }
			}

			/// <summary>
			/// Gets/sets the offset to the key list
			/// </summary>
			public int OffsetToKeyList
			{
				get { return offsetToKeyList; }
				set { offsetToKeyList = value; }
			}

			/// <summary>
			/// Gets/sets the offset to the resource list
			/// </summary>
			public int OffsetToResourceList
			{
				get { return offsetToResourceList; }
				set { offsetToResourceList = value; }
			}

			/// <summary>
			/// Gets/sets the build year
			/// </summary>
			public int BuildYear
			{
				get { return buildYear + 1900; }
				set { buildYear = value - 1900; }
			}

			/// <summary>
			/// Gets/sets the build day
			/// </summary>
			public int BuildDay
			{
				get { return buildDay; }
				set { buildDay = value; }
			}

			/// <summary>
			/// Gets/sets the tlk strref for the file description
			/// </summary>
			public int DescriptionStrRef
			{
				get { return descriptionStrRef; }
				set { descriptionStrRef = value; }
			}
			#endregion

			#region public methods
			/// <summary>
			/// Constructur to deserialize the ErfHeader from a stream.
			/// </summary>
			/// <param name="s"></param>
			public ErfHeader(Stream s)
			{
				// Let the raw serializer do the real work then just convert the
				// returned object to an ErfHeader.
				object o = RawSerializer.Deserialize(typeof(ErfHeader), s);
				if (null == o) throw new NWNException("Invalid Header in stream");
				this = (ErfHeader) o;
			}

			/// <summary>
			/// Class constructor.
			/// </summary>
			/// <param name="erfType">The type of the ERF file</param>
			public ErfHeader(ErfType erfType)
			{
				string s = erfType.ToString();
				type = new byte[] { (byte) s[0], (byte) s[1], (byte) s[2], (byte) ' ' };
				version = new byte[] { (byte) 'V', (byte) '1', (byte) '.', (byte) '0' };
				languageCount = 0;
				localizedStringSize = 0;
				entryCount = 0;
				offsetToLocalizedString = 0;
				offsetToKeyList = 0;
				offsetToResourceList = 0;
				buildYear = DateTime.Today.Year;
				buildDay = DateTime.Today.DayOfYear;
				descriptionStrRef = 0;
				pad = new byte[116];
			}

			/// <summary>
			/// Serializes the ErfHeader to a stream.
			/// </summary>
			/// <param name="s">The stream to serialize to.</param>
			public void Serialize(Stream s)
			{
				RawSerializer.Serialize(s, this);
			}
			#endregion

			#region private fields/properties/methods
			[MarshalAs(UnmanagedType.ByValArray, SizeConst=4)] private byte[] type;
			[MarshalAs(UnmanagedType.ByValArray, SizeConst=4)] private byte[] version;
			private Int32 languageCount;
			private Int32 localizedStringSize;
			private Int32 entryCount;
			private Int32 offsetToLocalizedString;
			private Int32 offsetToKeyList;
			private Int32 offsetToResourceList;
			private Int32 buildYear;
			private Int32 buildDay;
			private Int32 descriptionStrRef;
			[MarshalAs(UnmanagedType.ByValArray, SizeConst=116)] private byte[] pad;
			#endregion
		}

		/// <summary>
		/// This structure is a key entry in the ERF file.  A key defines a single
		/// resource (i.e. file) in the ERF.  It maps directly over
		/// the ERF raw data in the file and provides functionality to
		/// serialize/deserialize the raw data.
		/// </summary>
		[StructLayout(LayoutKind.Sequential, Pack=1, CharSet=CharSet.Ansi)] 
			private struct ErfKey
		{
			#region public properties/methods
			/// <summary>
			/// Gets the file name of the key.
			/// </summary>
			public string FileName
			{
				get
				{
					// If the resource type is invalid then return an empty string.
					if (ResType.Invalid == this.ResType) return string.Empty;
					if (0 == ResRef.Length) return string.Empty;

					// Convert the restype to a string to get the extension,
					// if it is an unknown extension then arbitrarily use
					// "ResUNK" to get "UNK" as the extension.
					string restype = this.ResType.ToString();
					if (restype.Length < 6) restype = "ResUNK";

					System.Text.StringBuilder b = new System.Text.StringBuilder(32);
					b.Append(ResRef);
					b.Append(".");
					b.Append(restype, 3, 3);
					return b.ToString();
				}
			}

			/// <summary>
			/// Gets the keys's ResRef
			/// </summary>
			public string ResRef { get { return RawSerializer.DeserializeString(resRef); } }

			/// <summary>
			/// Gets the key's ResType
			/// </summary>
			public ResType ResType { get { return (ResType) resType; } }

			/// <summary>
			/// Constructor to deserialize an ErfKey from a stream.
			/// </summary>
			/// <param name="s">The stream</param>
			public ErfKey(Stream s)
			{
				// Let the raw serializer do the real work then just convert the
				// returned object to an ErfHeader.
				object o = RawSerializer.Deserialize(typeof(ErfKey), s);
				if (null == o) throw new NWNException("Invalid key in stream");
				this = (ErfKey) o;
			}

			/// <summary>
			/// Constructor to create a key from a file.
			/// </summary>
			/// <param name="fileName">The name of the file</param>
			public ErfKey(string fileName)
			{
				unused = 0;
				resourceID = 0;

				// Generate the ResType of the file based on it's extension, then
				// save the Int16 version of that value in resType.
				FileInfo info = new FileInfo(fileName);
				string resource = "Res" + info.Extension.Substring(1, info.Extension.Length - 1);
				resType = (Int16) (ResType) Enum.Parse(typeof(ResType), resource, true);

				// Strip the extension from the file name and that is the ResRef of the
				// file.
				resRef = RawSerializer.SerializeString(
					Path.GetFileNameWithoutExtension(fileName).ToLower(), 16, false);
			}

			/// <summary>
			/// Serializes the ErfKey to a stream.
			/// </summary>
			/// <param name="s">The stream to serialize to.</param>
			public void Serialize(Stream s)
			{
				RawSerializer.Serialize(s, this);
			}
			#endregion

			#region public static methods
			/// <summary>
			/// Deserializes an array of ErfKey structures from the stream.
			/// </summary>
			/// <param name="s">The stream</param>
			/// <param name="count">The number of keys to deserialize</param>
			/// <returns>An array of ErfKey structures</returns>
			public static ErfKey[] Deserialize(Stream s, int count)
			{
				// Create an array of ErfKeys from the stream.
				ErfKey[] keys = new ErfKey[count];
				for (int i = 0; i < count; i++)
					keys[i] = new ErfKey(s);
				return keys;
			}

			/// <summary>
			/// Serializes an ErfKey array to the stream.
			/// </summary>
			/// <param name="s">The stream</param>
			/// <param name="keys">The array to serialize</param>
			public static void Serlialize(Stream s, ErfKey[] keys)
			{
				// Loop through the keys, assigning them a resource ID
				// (it's just the array index) and then serializing them.
				for (int i = 0; i < keys.Length; i++)
				{
					keys[i].resourceID = i;
					keys[i].Serialize(s);
				}
			}
			#endregion

			#region private fields/properties/methods
			[MarshalAs(UnmanagedType.ByValArray, SizeConst=16)] private byte[] resRef;
			private Int32 resourceID;
			private Int16 resType;
			private Int16 unused;
			#endregion
		}

		/// <summary>
		/// This structure is a resource entry in the ERF file.  A resource defines
		/// the location and size of the file data within the ERF.  It maps directly over
		/// the ERF raw data in the file and provides functionality to
		/// serialize/deserialize the raw data.
		/// </summary>
		[StructLayout(LayoutKind.Sequential, Pack=1, CharSet=CharSet.Ansi)] 
			private struct ErfResource
		{
			#region public properties/methods
			/// <summary>
			/// Gets/sets the offset to the resource data in the ERF.
			/// </summary>
			public int OffsetToResource
			{
				get { return offsetToResource; }
				set { offsetToResource = value; }
			}

			/// <summary>
			/// Gets/sets the size of the resource data in the ERF.
			/// </summary>
			public int ResourceSize
			{
				get { return resourceSize; }
				set { resourceSize = value; }
			}

			/// <summary>
			/// Constructor to deserialize an ErfResource from a stream.
			/// </summary>
			/// <param name="s">The stream</param>
			public ErfResource(Stream s)
			{
				// Let the raw serializer do the real work then just convert the
				// returned object to an ErfHeader.
				object o = RawSerializer.Deserialize(typeof(ErfResource), s);
				if (null == o) throw new NWNException("Invalid resource in stream");
				this = (ErfResource) o;
			}

			/// <summary>
			/// Serializes the ErfResource to a stream.
			/// </summary>
			/// <param name="s">The stream to serialize to.</param>
			public void Serialize(Stream s)
			{
				RawSerializer.Serialize(s, this);
			}
			#endregion

			#region public static methods
			/// <summary>
			/// Deserializes an array of ErfResource structures from the stream.
			/// </summary>
			/// <param name="s">The stream</param>
			/// <param name="count">The number of resources to deserialize</param>
			/// <returns>An array of ErfResource structures</returns>
			public static ErfResource[] Deserialize(Stream s, int count)
			{
				// Create an array of ErfKeys from the stream.
				ErfResource[] resources = new ErfResource[count];
				for (int i = 0; i < count; i++)
					resources[i] = new ErfResource(s);
				return resources;
			}

			/// <summary>
			/// Serializes an ErfResource array to the stream.
			/// </summary>
			/// <param name="s">The stream</param>
			/// <param name="keys">The array to serialize</param>
			public static void Serlialize(Stream s, ErfResource[] resources)
			{
				// Loop through the resources serializing them.
				for (int i = 0; i < resources.Length; i++)
					resources[i].Serialize(s);
			}
			#endregion

			#region private fields/properties/methods
			private Int32 offsetToResource;
			private Int32 resourceSize;
			#endregion
		}
		#endregion

		#region private fields/properties/methods
		private string decompressedPath;
		private FileInfo fileInfo;
		private ErfHeader header;
		private ErfString[] descriptions;
		private ErfKey[] keys;
		private ErfResource[] resources;
		private StringCollection removedFiles;
		private Hashtable keyHash;
		private Hashtable addedFileHash;
		private Hashtable replacedFileHash;

		/// <summary>
		/// Gets the key for a given file name.
		/// </summary>
		/// <param name="fileName">The file name</param>
		/// <returns>The key for the file</returns>
		private string GetKey(string fileName)
		{
			return Path.GetFileName(fileName).ToLower();
		}

		/// <summary>
		/// This method reads the given file into the passed stream,
		/// setting the passed ErfResource's offset/and size as appropriate.
		/// </summary>
		/// <param name="file"></param>
		/// <param name="resource"></param>
		/// <param name="buffer"></param>
		private void ReadFileIntoStream(string file, ref ErfResource resource, 
			Stream buffer)
		{
			using (FileStream reader = new FileStream(file, FileMode.Open))
			{
				// Read the source file.
				byte[] bytes = new byte[reader.Length];
				reader.Read(bytes, 0, bytes.Length);

				// Write the bytes to the buffer
				long pos = buffer.Position;
				buffer.Write(bytes, 0, bytes.Length);

				// Update the ErfResource with the offset and size
				resource.OffsetToResource = (int) pos;
				resource.ResourceSize = bytes.Length;
			}
		}

		/// <summary>
		/// This method gets the file extension for a given ResType.
		/// </summary>
		/// <param name="type">The type to get the extension for</param>
		/// <returns>The extension for the given type</returns>
		private string GetFileExtension(ResType type)
		{
			// Invalid has no file extension
			if (ResType.Invalid == type) return string.Empty;

			// Convert the ResType to a string and return the last 3
			// characters, this is the file extension.
			return type.ToString().Substring(3, 3).ToLower();
		}

		/// <summary>
		/// This method gets the ResType of the given file.
		/// </summary>
		/// <param name="fileName">The path/name of the file</param>
		/// <returns>The ResType of the file or ResType.Invalid if the
		/// file's extension is unknown</returns>
		private ResType GetTypeOfFile(string fileName)
		{
			try
			{
				// Get the file's extension and add "Res" to it and convert that text
				// to the enum value.
				string extension = Path.GetExtension(fileName).Substring(1, 3).ToUpper();
				return (ResType) System.Enum.Parse(typeof(ResType), "Res" + extension, true);
			}
			catch (Exception)
			{
				// If we get an exception then the file is unsupported, return invalid.
				return ResType.Invalid;
			}
		}
		#endregion
	}
}
