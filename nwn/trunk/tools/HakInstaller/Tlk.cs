using System;
using System.Collections;
using System.Collections.Specialized;
using System.IO;
using System.Runtime.InteropServices;

namespace NWN.FileTypes
{
	/// <summary>
	/// This class represents a tlk file.  It contains all of the functionality necessary to
	/// merge tlk files.
	/// </summary>
	public class Tlk
	{
		#region public nested classes
		/// <summary>
		/// Flags for the ResRef data.
		/// </summary>
		[Flags] public enum ResRefFlags: int
		{
			None				= 0x0000,
			TextPresent			= 0x0001,
			SoundPresent		= 0x0002,
			SoundLengthPresent	= 0x0004,
		}

		/// <summary>
		/// This class defines an entry in the tlk file.  It contains all of the data for
		/// the entry.
		/// </summary>
		public class TlkEntry
		{
			#region public properties/methods
			/// <summary>
			/// Gets/sets the entrie's flags
			/// </summary>
			public ResRefFlags Flags { get { return flags; } set { flags = value; } }

			/// <summary>
			/// Gets/sets the sound ResRef
			/// </summary>
			public string SoundResRef
			{
				get { return soundResRef; } 
				set
				{
					soundResRef = value;
					if (string.Empty != soundResRef)
						flags |= ResRefFlags.SoundPresent;
					else
						flags &= ~ResRefFlags.SoundPresent;
				}
			}

			/// <summary>
			/// Gets/sets the volume variance.
			/// </summary>
			public int VolumnVariance { get { return volumeVariance; } set { volumeVariance = value; } }

			/// <summary>
			/// Gets/sets the pitch variance.
			/// </summary>
			public int PitchVariance { get { return pitchVariance; } set { pitchVariance = value; } }

			/// <summary>
			/// Gets/sets the sound length.
			/// </summary>
			public float SoundLength
			{
				get { return soundLength; } 
				set
				{
					soundLength = value;
					if (0 != soundLength)
						flags |= ResRefFlags.SoundLengthPresent;
					else
						flags &= ~ResRefFlags.SoundLengthPresent;
				}
			}

			/// <summary>
			/// Gets/sets the entry text.
			/// </summary>
			public string Text
			{ 
				get { return text; } 
				set
				{
					text = value;
					if (string.Empty != text)
						flags |= ResRefFlags.TextPresent;
					else
						flags &= ~ResRefFlags.TextPresent;
				}
			}

			/// <summary>
			/// Returns true if the tlk entry is empty.
			/// </summary>
			public bool IsEmpty { get { return flags == ResRefFlags.None; } }

			/// <summary>
			/// Default constructor
			/// </summary>
			public TlkEntry()
			{
				flags = ResRefFlags.None;
				volumeVariance = 0;
				pitchVariance = 0;
				soundLength = 0;
				soundResRef = string.Empty;;
				this.text = string.Empty;
			}

			/// <summary>
			/// Constuctor to create an entry for a string.
			/// </summary>
			/// <param name="text">The text.</param>
			public TlkEntry(string text)
			{
				flags = ResRefFlags.TextPresent;
				volumeVariance = 0;
				pitchVariance = 0;
				soundLength = 0;
				soundResRef = string.Empty;
				this.text = text;
			}
			#endregion

			#region private fields/properties/methods
			private ResRefFlags flags;
			public int volumeVariance;
			public int pitchVariance;
			public float soundLength;
			public string soundResRef;
			public string text;
			#endregion
		}
		#endregion

		#region public properties
		/// <summary>
		/// Gets the tlk key to be used in dictionary lookups, this is a lower case version
		/// of the name.
		/// </summary>
		public string Key { get { return name.ToLower(); } }

		/// <summary>
		/// Gets the name of the tlk file, the name does not include any path information.
		/// </summary>
		public string Name { get { return name; } }

		/// <summary>
		/// Gets the number of entries in the tlk file.
		/// </summary>
		public int Count { get { return header.stringCount; } }

		/// <summary>
		/// Does a lookup in the tlk file, returning the entry for the specified index.
		/// </summary>
		public TlkEntry this[int index]
		{
			get
			{
				// If the index is out of range return null.
				if (index >= header.stringCount || index < 0) return null;

				// Create a TlkEntry for the entry
				TlkEntry entry = new TlkEntry();
				entry.PitchVariance = resRefs[index].pitchVariance;
				entry.SoundLength = resRefs[index].soundLength;
				entry.VolumnVariance = resRefs[index].volumeVariance;
				entry.SoundResRef = resRefs[index].soundResRef;
				entry.Text = strings[index];
				entry.Flags = (ResRefFlags) resRefs[index].flags;

				// Return the created entry.
				return entry;
			}
			set
			{
				// Make sure the index is within range.
				if (index >= header.stringCount || index < 0) throw new IndexOutOfRangeException();

				resRefs[index].pitchVariance = value.PitchVariance;
				resRefs[index].soundLength = value.SoundLength;
				resRefs[index].volumeVariance = value.VolumnVariance;
				resRefs[index].soundResRef = value.SoundResRef;
				resRefs[index].flags = (int) value.Flags;
				strings[index] = value.Text;
			}
		}
		#endregion

		#region public methods
		/// <summary>
		/// Default constructor.
		/// </summary>
		/// <param name="count">The initial number of entries in the tlk file.</param>
		public Tlk(int count)
		{
			name = string.Empty;
			header = new TlkHeader();
			resRefs = new RawResRef[count];
			strings = new string[count];

			header.fileType = tlkFile;
			header.fileVersion = tlkVersion;
			header.stringCount = count;
			header.stringOffset = 0;

			for (int i = 0; i < count; i++)
			{
				resRefs[i] = new RawResRef();
				resRefs[i].flags = (int) ResRefFlags.None;
				resRefs[i].offsetToString = 0;
				resRefs[i].pitchVariance = 0;
				resRefs[i].soundLength = 0;
				resRefs[i].soundResRef = string.Empty;
				resRefs[i].stringSize = 0;
				resRefs[i].volumeVariance = 0;

				strings[i] = string.Empty;
			}
		}

		/// <summary>
		/// Returns true if the index'th entry is empty.
		/// </summary>
		/// <param name="index">The index of the entry to test</param>
		/// <returns>True if the entry is empty false if it is not</returns>
		public bool IsEmpty(int index)
		{
			if (index >= header.stringCount || index < 0) throw new ArgumentOutOfRangeException();
			return (int) ResRefFlags.None == resRefs[index].flags || string.Empty == strings[index];
		}

		/// <summary>
		/// Pads the tlk to have at least the specified number of entries.  If the tlk file
		/// has less entries than what is given, blank entries are inserted to pad.
		/// </summary>
		/// <param name="length">The new number of entries</param>
		public void Pad(int length)
		{
			// If the tlk file is larger than the pad count then do nothing.
			if (header.stringCount >= length) return;

			// Add blank entries to the tlk file to pad.
			RawResRef[] padded = new RawResRef[length];
			resRefs.CopyTo(padded, 0);
			for (int i = resRefs.Length; i < padded.Length; i++)
			{
				padded[i].flags = 0;
				padded[i].offsetToString = 0;
				padded[i].pitchVariance = 0;
				padded[i].stringSize = 0;
				padded[i].volumeVariance = 0;
				padded[i].soundLength = 0.0f;
				padded[i].soundResRef = string.Empty;
			}

			string[] paddedStrings = new string[length];
			paddedStrings.CopyTo(strings, 0);
			for (int i = strings.Length; i < paddedStrings.Length; i++)
				paddedStrings[i] = string.Empty;

			// Save the new RawResRef array and update the number of entries in
			// the header.
			header.stringCount = length;
			resRefs = padded;
			strings = paddedStrings;
		}

		/// <summary>
		/// Saves the tlk file, the tlk file must have been given a name or this will
		/// throw an InvalidOperationException.
		/// </summary>
		public void Save()
		{
			if (string.Empty == name) throw new InvalidOperationException();
			SaveAs(name);
		}

		/// <summary>
		/// Saves the tlk file under the specified file name.
		/// </summary>
		/// <param name="fileName">The name in which to save the file.</param>
		public void SaveAs(string fileName)
		{
			using (FileStream writer = 
				new FileStream(fileName, FileMode.Create, FileAccess.Write, FileShare.None))
			{
				// Figure out how big of a buffer we need to store all of the string data.
				int count = 0;
				foreach (string s in strings)
					count += s.Length;

				// Copy all of the string data to a byte array.
				int stringDataIndex = 0;
				byte[] stringData = new byte[count];
				for (int i = 0; i < resRefs.Length; i++)
				{
					// Ignore entries w/o strings.
					if (0 == ((int) ResRefFlags.TextPresent & resRefs[i].flags) ||
						string.Empty == strings[i])
					{
						// Blank the string size and offset just in case to keep
						// the tlk file clean.
						resRefs[i].stringSize = 0;
						resRefs[i].offsetToString = 0;
						continue;
					}

					// Copy the string bytes to the byte array.
					for (int j = 0; j < strings[i].Length; j++)
						stringData[stringDataIndex + j] = (byte) strings[i][j];

					// Save the string offset and size in the ResRef structure.
					resRefs[i].offsetToString = stringDataIndex;
					resRefs[i].stringSize = strings[i].Length;

					// Increment the buffer index to the next free byte.
					stringDataIndex += strings[i].Length;
				}

				// Set the offset to the string data in the header and write the header out.
				header.stringOffset = headerSize + (resRefs.Length * RawResRefSize);
				byte[] buffer = RawSerialize(header);
				writer.Write(buffer, 0, buffer.Length);

				// Write all of the ResRef entries out.
				for (int i = 0; i < resRefs.Length; i++)
				{
					buffer = RawSerialize(resRefs[i]);
					writer.Write(buffer, 0, buffer.Length);
				}

				// Write the raw string data out.
				writer.Write(stringData, 0, stringData.Length);
			}

			this.name = fileName;
		}
		#endregion

		#region public static methods
		/// <summary>
		/// Creates a Tlk object for the specified tlk file.
		/// </summary>
		/// <param name="fileName">The tlk file</param>
		/// <returns>A Tlk object representing the tlk file</returns>
		public static Tlk LoadTlk(string fileName)
		{
			// Open the tlk file.
			Tlk tlk = new Tlk();
			using (FileStream reader = 
				new FileStream(fileName, FileMode.Open, FileAccess.Read, FileShare.Read))
			{
				// Save the name of the tlk file.
				FileInfo info = new FileInfo(fileName);
				tlk.name = info.Name;

				// Read the header and decode it.
				byte[] buffer = new byte[Tlk.headerSize];
				if (reader.Read(buffer, 0, buffer.Length) != buffer.Length)
					ThrowException("Tlk file {0} is corrupt", fileName);
				tlk.DeserializeHeader(buffer);

				// Do a reality check on the tlk file.
				if (tlk.header.fileType != tlkFile) 
					ThrowException("{0} is not a tlk file", fileName);
				if (tlk.header.fileVersion != tlkVersion) 
					ThrowException("{0} is an unsupported tlk file", fileName);

				// Read the RawResRef array and decode it.
				int size = tlk.header.stringCount * Tlk.RawResRefSize;
				buffer = new byte[size];
				if (reader.Read(buffer, 0, buffer.Length) != buffer.Length)
					ThrowException("Tlk file {0} is corrupt", fileName);
				tlk.DeserializeRawResRefs(buffer);

				// Read the raw string data.
				buffer = new byte[reader.Length - tlk.header.stringOffset];
				if (reader.Read(buffer, 0, buffer.Length) != buffer.Length)
					ThrowException("Tlk file {0} is corrupt", fileName);

				// Load the strings from the raw bytes into our string array.
				tlk.strings = new string[tlk.header.stringCount];
				for (int i = 0; i < tlk.header.stringCount; i++)
					tlk.strings[i] = tlk.GetStringFromBuffer(buffer, i);
			}

			return tlk;
		}

		/// <summary>
		/// Merges 2 tlk objects, saving the results in the specified tlk file. The merge tlk file
		/// is just added to the end of the source tlk file.  Unlike 2da merging, the merge tlk
		/// does not overwrite any entries in the source tlk.  Tlk entries are not row critical like
		/// 2da rows (since tlk strings are not saved in character files), so exact positioning of
		/// them is not as critical.
		/// </summary>
		/// <param name="source">The source tlk</param>
		/// <param name="merge">The merge tlk</param>
		/// <param name="outFile">The name of the output tlk file</param>
		/// <returns>The offset of the first entry of the merge tlk in the output file.  This offset
		/// can be used to fixup 2da entries that refer to the merge tlk.</returns>
		public static int MergeTlk(Tlk source, Tlk merge, string outFile)
		{
			/*
			// Open the output tlk.
			using (FileStream writer = 
			   new FileStream(outFile, FileMode.Create, FileAccess.Write, FileShare.None))
			{
				// Build a RawResRef array containing both the source and merge RawResRef arrays.  Then
				// loop through all of the merge entries and fixup the string offsets to point
				// past the source data to the merge data, which we will glue on the end of the
				// source data.
				RawResRef[] outResRefs = new RawResRef[source.resRefs.Length + merge.resRefs.Length];
				source.resRefs.CopyTo(outResRefs, 0);
				merge.resRefs.CopyTo(outResRefs, source.resRefs.Length);
				for (int i = source.resRefs.Length; i < outResRefs.Length; i++)
				{
					if (0 != (outResRefs[i].flags & (int) ResRefFlags.textPresent))
						outResRefs[i].offsetToString += source.stringBytes.Length;
				}

				// Build a header with a string count of all of the source + merge strings, then
				// write it out.
				TlkHeader headerOut = source.header;
				headerOut.stringCount += merge.header.stringCount;
				headerOut.stringOffset = headerSize + (outResRefs.Length * RawResRefSize);
				byte[] headerBytes = RawSerialize(headerOut);
				writer.Write(headerBytes, 0, headerBytes.Length);

				// Write the RawResRef data.
				for (int i = 0; i < outResRefs.Length; i++)
				{
					byte[] bytes = RawSerialize(outResRefs[i]);
					writer.Write(bytes, 0, bytes.Length);
				}

				// Write the source and merge string data out to the file.
				writer.Write(source.stringBytes, 0, source.stringBytes.Length);
				writer.Write(merge.stringBytes, 0, merge.stringBytes.Length);

				writer.Flush();
				writer.Close();
			}

			// Return the number of strings in the source tlk.  Since we glued the merge
			// tlk onto the end of the source tlk, this value will be the fixup value we need
			// to correct 2da tlk references.
			return source.header.stringCount;
			*/
			return 0;
		}
		#endregion

		#region private methods
		/// <summary>
		/// Private constructor, instances of this class must
		/// </summary>
		private Tlk()
		{
			header = new TlkHeader();
			resRefs = null;
			strings = null;
		}

		/// <summary>
		/// Gets the index'th string from the raw string buffer.
		/// </summary>
		/// <param name="buffer">The raw string buffer</param>
		/// <param name="index">Index of the string to get</param>
		/// <returns>The index'th string</returns>
		private string GetStringFromBuffer(byte[] buffer, int index)
		{
			// If the index is out of range or the text present flag is not set then
			// return an empty string.
			if (index >= header.stringCount ||
				0 == (resRefs[index].flags & (int) ResRefFlags.TextPresent)) return string.Empty;;

			// Can't find a converter to build a string from a byte array, so we
			// need a local char array to do the dirty work.
			int offset = resRefs[index].offsetToString;
			char[] chars = new char[resRefs[index].stringSize];
			for (int i = 0; i < chars.Length; i++)
				chars[i] = (char) buffer[i + offset];

			return new string(chars);
		}

		/// <summary>
		/// Deserializes the header from the given byte array. 
		/// </summary>
		/// <param name="bytes">The byte array containing the header</param>
		private void DeserializeHeader(byte[] bytes)
		{
			// Alloc a hglobal to store the bytes.
			IntPtr buffer = Marshal.AllocHGlobal(bytes.Length);
			try
			{
				// Copy the data to unprotected memory, then convert it to a TlkHeader
				// structure
				Marshal.Copy(bytes, 0, buffer, bytes.Length);
				object o = Marshal.PtrToStructure(buffer, typeof(TlkHeader));
				header = (TlkHeader) o;
			}
			finally
			{
				// Free the hglobal before exiting.
				Marshal.FreeHGlobal(buffer);
			}
		}

		/// <summary>
		/// Deserializes the RawResRef array from the given byte array.
		/// </summary>
		/// <param name="bytes"></param>
		private void DeserializeRawResRefs(byte[] bytes)
		{
			// Alloc a hglobal to store the bytes.
			IntPtr buffer = Marshal.AllocHGlobal(RawResRefSize);
			try
			{
				// Create a RawResRef array for all of the entries and loop
				// through the array populating it.
				resRefs = new RawResRef[header.stringCount];
				for (int i = 0; i < resRefs.Length; i++)
				{
					// Copy the bytes of the i'th RawResRef to unprotected memory
					// and convert it to a RawResRef structure.
					Marshal.Copy(bytes, i * RawResRefSize, buffer, RawResRefSize);
					object o = Marshal.PtrToStructure(buffer, typeof(RawResRef));
					resRefs[i] = (RawResRef) o;
				}
			}
			finally
			{
				// Free the hglobal before exiting.
				Marshal.FreeHGlobal(buffer);
			}
		}
		#endregion

		#region private static methods
		/// <summary>
		/// Throws an NWNException exception
		/// </summary>
		/// <param name="format">The message format string</param>
		/// <param name="args">Message arguments</param>
		private static void ThrowException(string format, params object[] args)
		{
			throw new NWNException(format, args);
		}

		/// <summary>
		/// This method serializes an arbitrary object to a byte array for storage in
		/// a tlk file.  The object should have it's data mapped to proper positions
		/// or the serialization won't work.
		/// </summary>
		/// <param name="o">The object to serialize</param>
		/// <returns></returns>
		private static byte[] RawSerialize(object o)
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
		#endregion

		#region private nested structures/classes
		/// <summary>
		/// Structure to store the header of the tlk file.  This is mapped directly over the
		/// bytes loaded from the tlk file, so we need to declare the mapping explicitly.
		/// Using LayoutKind.Sequential should work, but I had problems with it so used
		/// Explicit to force the issue.  fileType and fileVersions are really strings, but
		/// .NET insists on null terminating strings, and these strings are not null terminated.
		/// They are both 4 bytes so using Int32 works.
		/// </summary>
		[StructLayout(LayoutKind.Explicit, Pack=1, CharSet=CharSet.Ansi)] private struct TlkHeader
		{
			[FieldOffsetAttribute(0)] public Int32 fileType;
			[FieldOffsetAttribute(4)] public Int32 fileVersion;
			[FieldOffsetAttribute(8)] public Int32 language;
			[FieldOffsetAttribute(12)] public Int32 stringCount;
			[FieldOffsetAttribute(16)] public Int32 stringOffset;
		}

		/// <summary>
		/// Structure to represent a RawResRef entry in a tlk file.  This is mapped directly over the
		/// bytes loaded from the tlk file, so we need to declare the mapping explicitly.
		/// </summary>
		[StructLayout(LayoutKind.Sequential, Pack=1, CharSet=CharSet.Ansi)] private struct RawResRef
		{
			public Int32 flags;
			[MarshalAs(UnmanagedType.ByValTStr, SizeConst=16)] public String soundResRef;
			public Int32 volumeVariance;
			public Int32 pitchVariance;
			public Int32 offsetToString;
			public Int32 stringSize;
			public float soundLength;
		}
		#endregion

		#region private fields
		private const int headerSize = 20;
		private const int RawResRefSize = 40;
		private const Int32 tlkFile = 0x204b4c54;
		private const Int32 tlkVersion = 0x302e3356;

		private string name;
		private TlkHeader header;
		private RawResRef[] resRefs;
		private string[] strings;
		#endregion
	}
}
