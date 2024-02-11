using System;
using System.Collections;
using System.Collections.Specialized;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using NWN.FileTypes.Tools;

namespace NWN.FileTypes.Gff
{
	/// <summary>
	/// This enum defines the data types supported by GffFields.  Simple
	/// data items are stored directly in the GffField's DataOrDataOffset
	/// field, complex data items are stored in the complex data byte
	/// array, with the offset to the data being in DataOrDataOffset.
	/// </summary>
	public enum GffFieldType
	{
		#region values
		Byte = 0,
		Char = 1,
		Word = 2,
		Short = 3,
		DWord = 4,
		Int = 5,
		DWord64 = 6,			// complex
		Int64 = 7,				// complex
		Float = 8,
		Double = 9,				// complex
		ExoString = 10,			// complex
		ResRef = 11,			// complex
		ExoLocString = 12,		// complex
		Void = 13,				// complex
		Struct = 14,			// complex
		List = 15,				// complex
		#endregion
	}


	/// <summary>
	/// Class to define a localized string.  Localized strings in GFF
	/// files can be stored in one of two ways, either a tlk index for
	/// lookup in dialog.tlk (or the custom tlk) or as a list of strings
	/// for various languages.  This class supports both.
	/// </summary>
	public class ExoLocString
	{
		#region public properties/methods
		/// <summary>
		/// Default constructor
		/// </summary>
		public ExoLocString() : this(0, true, string.Empty) {}

		/// <summary>
		/// Class constructor
		/// </summary>
		/// <param name="languageID">Language ID</param>
		/// <param name="male">True if string is masculine</param>
		/// <param name="val">String</param>
		public ExoLocString(uint languageID, bool male, string val)
		{
			StringInfo info = new StringInfo();
			info.LanguageID = languageID;
			info.Male = male;
			info.Text = val;

			strings = new ArrayList();
			strings.Add(info);
		}

		/// <summary>
		/// Class constructor to create an ExoLocString from the GFF
		/// file's raw data.
		/// </summary>
		/// <param name="buffer">Byte array containing the raw data</param>
		/// <param name="offset">Offset to the data</param>
		public ExoLocString(Byte[] buffer, int offset)
		{
			strings = new ArrayList();

			// Get the total size in bytes of the ExoLocString.
			uint size = BitConverter.ToUInt32(buffer, offset);
			offset += 4;

			// Get the dialog.tlk StrRef, if it is valid (not -1) then
			// we are doine.
			strRef = BitConverter.ToUInt32(buffer, offset);
			offset += 4;
			if (0xffffffff != strRef) return;

			// Get the number of sub-strings in the ExoLocString and
			// build StringInfo objects for each of them, adding them
			// to our collection.
			uint count = BitConverter.ToUInt32(buffer, offset);
			offset += 4;
			for (int i = 0; i < count; i++)
			{
				// Get the sub-string's languageID and length.
				uint stringID = BitConverter.ToUInt32(buffer, offset);
				offset += 4;
				uint length = BitConverter.ToUInt32(buffer, offset);
				offset += 4;

				// Create the string info object, and fill it in with the
				// proper data.
				StringInfo info = new StringInfo();
				info.LanguageID = stringID / 2;
				info.Male = 0 == stringID % 2;
				info.Text = RawGffData.DeserializeString(buffer, offset, (int) length);
				offset += (int) length;

				strings.Add(info);
			}
		}

		/// <summary>
		/// Serializes the object to a byte array
		/// </summary>
		/// <returns>The serialized byte array</returns>
		public byte[] Serialize()
		{
			// First figure out how many bytes we need.  We start with 12 bytes
			// for the overall byte count, dialog.tlk reference, and embedded
			// string count.  Once we figure out how big the buffer has to be allocate it.
			uint count = 12;
			foreach (StringInfo info in strings)
			{
				// Add 8 for language and length, and add the string length.
				count += 8 + (uint) info.Text.Length;
			}
			byte[] bytes = new byte[count];
			int offset = 0;

			// Write the overall byte count and dialog.tlk reference.  Note that the
			// first 4 bytes containing the size are NOT counted in the byte count.
			byte[] data = BitConverter.GetBytes(count - 4);
			data.CopyTo(bytes, offset);
			offset += data.Length;
			data = BitConverter.GetBytes(strRef);
			data.CopyTo(bytes, offset);
			offset += data.Length;

			// Write the embedded string count.
			data = BitConverter.GetBytes((uint) strings.Count);
			data.CopyTo(bytes, offset);
			offset += data.Length;

			// Write all of the strings.
			foreach (StringInfo info in strings)
			{
				// Write the language value.
				uint language = (info.LanguageID * 2) + (uint) (info.Male ? 0 : 1);
				data = BitConverter.GetBytes(language);
				data.CopyTo(bytes, offset);
				offset += data.Length;

				// Write the length.
				data = BitConverter.GetBytes((uint) info.Text.Length);
				data.CopyTo(bytes, offset);
				offset += data.Length;

				// Write the string data.
				for (int i = 0; i < info.Text.Length; i++, offset++)
					bytes[offset] = (byte) info.Text[i];
			}

			return bytes;
		}

		/// <summary>
		/// Override ToString() to give menaingful output for the object.  For
		/// tlk references it's the tlk index as a string, for embedded strings
		/// it's the first string in the list.
		/// </summary>
		/// <returns>A string representation of the object.</returns>
		public override string ToString()
		{
			// If the string is a dialog.tlk lookup then
			// just return the lookup index as a string.
			if (0xffffffff != strRef) return strRef.ToString();

			// If it's text is embedded just return the first
			// entry.
			if (0 == strings.Count) return string.Empty;
			return ((StringInfo) strings[0]).Text;
		}
		#endregion

		#region private nested classes/fields
		/// <summary>
		/// This class defines a single instance of an embedded string
		/// in the raw data.  The string is stored in the raw data as
		/// language (4 bytes), length (4 bytes), and text.  Language
		/// is the language ID * 2 with 1 added if the text is female.
		/// We break this data apart and store it in a code friendly
		/// manner in this object.  A collection of these objects is then
		/// built for all of the embedded strings.
		/// </summary>
		private class StringInfo
		{
			public uint LanguageID;
			public bool Male;
			public string Text;
		}

		uint strRef;
		private ArrayList strings;
		#endregion
	}


	/// <summary>
	/// This class defines a GffFieldSchema.  It allows Gff derived classes
	/// to define the schema of their files.
	/// </summary>
	public class GffFieldSchema
	{
		#region public properties/methods
		/// <summary>
		/// Gets the UIName of the field.
		/// </summary>
		public string UIName { get { return uiName; } }

		/// <summary>
		/// Gets the tag of the field.
		/// </summary>
		public string Tag { get { return tag; } }

		/// <summary>
		/// Gets the data type of the field
		/// </summary>
		public GffFieldType Type { get { return type; } }

		/// <summary>
		/// Gets the structure ID, only menaingful for lists and structures.
		/// </summary>
		uint StructureID { get { return structID; } }

		/// <summary>
		/// Gets the child fields of the structure, only meaningful for structures.
		/// </summary>
		public GffSchemaCollection Children { get { return children; } }

		/// <summary>
		/// Class constructor
		/// </summary>
		/// <param name="uiName">Display name of the field</param>
		/// <param name="label">Tag of the field</param>
		/// <param name="type">Data type of the field</param>
		public GffFieldSchema(string uiName, string tag, GffFieldType type) :
			this(uiName, tag, type, 0, null) {}

		/// <summary>
		/// Class constructor
		/// </summary>
		/// <param name="uiName">Display name of the field</param>
		/// <param name="label">Tag of the field</param>
		/// <param name="type">Data type of the field</param>
		/// <param name="structureID">Structure ID of the field, only meaningful
		/// for lists and structures</param>
		/// <param name="children">Schema for the structure's child fields</param>
		public GffFieldSchema(string uiName, string tag, GffFieldType type,
			uint structID, GffSchemaCollection children)
		{
			this.uiName = uiName;
			this.tag = tag;
			this.type = type;
			this.structID = structID;
			this.children = children;
		}

		/// <summary>
		/// Creates a GffField derived object based on the schema.
		/// </summary>
		public GffField CreateField()
		{
			// Create the field and assign it's structure ID if it's a structure.
			GffField field = GffFieldFactory.CreateField(type);
			if (GffFieldType.Struct == type) 
				((GffStructField) field).StructureType = structID;

			return field;
		}
		#endregion

		#region private fields/properties/methods
		private string uiName;
		private string tag;
		private GffFieldType type;
		private uint structID;
		private GffSchemaCollection children;
		#endregion
	}


	/// <summary>
	/// This class is the collection class for GffFieldSchema objects, the
	/// collection as a whole defines the schema for a file.
	/// </summary>
	public class GffSchemaCollection: DictionaryBase
	{
		#region public properties/methods
		/// <summary>
		/// Indexer to lookup a schema based on it's label.
		/// </summary>
		public GffFieldSchema this[string label] 
		{ get { return InnerHashtable[label] as GffFieldSchema; } }

		/// <summary>
		/// Indexer to get the index'th DictionaryEntry in the collection.
		/// It uses the ordered entries list to give the entries back in the same
		/// order that they were placed in the collection.
		/// </summary>
		public GffFieldSchema this[int index] 
		{ get { return (GffFieldSchema) orderedEntries[index]; } }

		/// <summary>
		/// Class constructor.
		/// </summary>
		public GffSchemaCollection()
		{
			orderedEntries = new ArrayList();
		}

		/// <summary>
		/// Adds a field schema to the dictionary.
		/// </summary>
		/// <param name="field">The field's schema</param>
		public void Add(GffFieldSchema field)
		{
			// Add the entry to the hashtable in the dictionary, then
			// add it to the end of our ordered entries collection.  The
			// ordered entries collectoin will allow us to traverse the
			// dictionary in the order that the entries were added, preserving
			// this order.
			InnerHashtable.Add(field.UIName, field);
			orderedEntries.Add(field);
		}

		/// <summary>
		/// Replace GetEnumerator() to return an enumerator that uses the
		/// orderedEntries collection rather than the dictionary to enumerate
		/// the objects.
		/// </summary>
		/// <returns>The dictionary enumerator</returns>
		public new IEnumerator GetEnumerator()
		{
			return new Enumerator(orderedEntries);
		}
		#endregion

		#region private fields/properties/methods
		private ArrayList orderedEntries;

		/// <summary>
		/// Nested class to enumerate the dictionary entries using the
		/// orderedEntries collection rather than the dictionary.  This allows
		/// us to enumerate them in the order they were added.
		/// </summary>
		private class Enumerator: IEnumerator
		{
			#region implementation
			public object Current { get { return baseEnumerator.Current; } }
			public bool MoveNext() { return baseEnumerator.MoveNext(); }
			public void Reset() { baseEnumerator.Reset(); }

			public Enumerator(ArrayList list) { baseEnumerator = list.GetEnumerator(); }

			private IEnumerator baseEnumerator;
			#endregion
		}
		#endregion
	}

	/// <summary>
	/// This structure defines the header of a GFF file.
	/// </summary>
	[StructLayout(LayoutKind.Sequential, Pack=1, CharSet=CharSet.Ansi)] 
	public struct GffHeader
	{
		#region public properties
		public string FileType 
		{ get { return RawGffData.DeserializeString(fileType, 0, fileType.Length).Trim(); } }

		public string VersionText 
		{ get { return RawGffData.DeserializeString(version, 0, version.Length); } }

		public int StructOffset
		{
			get { return structOffset; }
			set { structOffset = value; }
		}

		public int StructCount
		{
			get { return structCount; }
			set { structCount = value; }
		}

		public int FieldOffset
		{
			get { return fieldOffset; }
			set { fieldOffset = value; }
		}

		public int FieldCount
		{
			get { return fieldCount; }
			set { fieldCount = value; }
		}

		public int LabelOffset
		{
			get { return labelOffset; }
			set { labelOffset = value; }
		}

		public int LabelCount
		{
			get { return labelCount; }
			set { labelCount = value; }
		}

		public int FieldDataOffset
		{
			get { return fieldDataOffset; }
			set { fieldDataOffset = value; }
		}

		public int FieldDataCount
		{
			get { return fieldDataCount; }
			set { fieldDataCount = value; }
		}

		public int FieldIndecesOffset
		{
			get { return fieldIndecesOffset; }
			set { fieldIndecesOffset = value; }
		}

		public int FieldIndecesCount
		{
			get { return fieldIndecesCount; }
			set { fieldIndecesCount = value; }
		}

		public int ListIndecesOffset
		{
			get { return listIndecesOffset; }
			set { listIndecesOffset = value; }
		}

		public int ListIndecesCount
		{
			get { return listIndecesCount; }
			set { listIndecesCount = value; }
		}
		#endregion

		#region public methods
		public GffHeader(string type)
		{
			// Add the current GFF file version to the header.
			const string verText = "V3.2";
			version = new byte[4];
			for (int i = 0; i < version.Length; i++)
				version[i] = (byte) verText[i];

			// Add the file type to the file.
			type = type.ToUpper();
			fileType = new byte[4];
			for (int i = 0; i < fileType.Length; i++)
				fileType[i] = i >= type.Length ? (byte) ' ' : (byte) type[i];

			// Initialize all other fields.
			fieldCount = 0;
			fieldDataCount = 0;
			fieldDataOffset = 0;
			fieldIndecesCount = 0;
			fieldIndecesOffset = 0;
			fieldOffset = 0;
			labelCount = 0;
			labelOffset = 0;
			listIndecesCount = 0;
			listIndecesOffset = 0;
			structCount = 0;
			structOffset = 0;
		}

		/// <summary>
		/// Constructor to deserialize the GffHeader from a stream.
		/// </summary>
		/// <param name="s"></param>
		public GffHeader(Stream s)
		{
			// Let the raw serializer do the real work then just convert the
			// returned object to an ErfHeader.
			NWNLogger.Log(0, "GffHeader.GffHeader deserializing bytes"); 
			object o = RawSerializer.Deserialize(typeof(GffHeader), s);
			if (null == o) NWNLogger.Log(10, "RawSerializer.Deserialize returned null!!!");
			if (null == o) throw new NWNException("Invalid Header in stream");
			this = (GffHeader) o;
			NWNLogger.Log(1, "GffHeader.GffHeader deserialized version {0}:{1}:{2}:{3}", 
				version[0], version[1], version[2], version[3]);
		}

		/// <summary>
		/// Serializes the GffHeader to a stream.
		/// </summary>
		/// <param name="s">The stream to serialize to.</param>
		public void Serialize(Stream s)
		{
			RawSerializer.Serialize(s, this);
		}
		#endregion

		#region private fields
		[MarshalAs(UnmanagedType.ByValArray, SizeConst=4)] private byte[] fileType;
		[MarshalAs(UnmanagedType.ByValArray, SizeConst=4)] private byte[] version;
		private Int32 structOffset;
		private Int32 structCount;
		private Int32 fieldOffset;
		private Int32 fieldCount;
		private Int32 labelOffset;
		private Int32 labelCount;
		private Int32 fieldDataOffset;
		private Int32 fieldDataCount;
		private Int32 fieldIndecesOffset;
		private Int32 fieldIndecesCount;
		private Int32 listIndecesOffset;
		private Int32 listIndecesCount;
		#endregion
	}


	/// <summary>
	/// This class contains the raw GFF file data, either buffered as read from
	/// the file (when reading) or in buf
	/// </summary>
	public class RawGffData
	{
		#region public nested structures
		[StructLayout(LayoutKind.Sequential, Pack=1, CharSet=CharSet.Ansi)] 
			public struct RawGffStruct
		{
			#region public fields/properties/methods
			public UInt32 Type;
			public UInt32 DataOrDataOffset;
			public UInt32 FieldCount;

			/// <summary>
			/// Class constructor
			/// </summary>
			/// <param name="type">Structure type ID</param>
			public RawGffStruct(UInt32 type)
			{
				Type = type;
				DataOrDataOffset = 0;
				FieldCount = 0;
			}

			/// <summary>
			/// Constructor to deserialize the RawGffStruct from a stream.
			/// </summary>
			/// <param name="s"></param>
			public RawGffStruct(Stream s)
			{
				try
				{
					byte[] bytes = new Byte[4];
					s.Read(bytes, 0, bytes.Length);
					Type = BitConverter.ToUInt32(bytes, 0);
					s.Read(bytes, 0, bytes.Length);
					DataOrDataOffset = BitConverter.ToUInt32(bytes, 0);
					s.Read(bytes, 0, bytes.Length);
					FieldCount = BitConverter.ToUInt32(bytes, 0);
				}
				catch
				{
					throw new NWNException("Invalid struct in stream");
				}
			}

			/// <summary>
			/// Serializes the GffStruct to a stream.
			/// </summary>
			/// <param name="s">The stream to serialize to.</param>
			public void Serialize(Stream s)
			{
				byte[] bytes = BitConverter.GetBytes(Type);
				s.Write(bytes, 0, bytes.Length);
				bytes = BitConverter.GetBytes(DataOrDataOffset);
				s.Write(bytes, 0, bytes.Length);
				bytes = BitConverter.GetBytes(FieldCount);
				s.Write(bytes, 0, bytes.Length);
			}
			#endregion
		}

		/// <summary>
		/// This structure defines the raw file gff field.  This is used
		/// to load/save GffFields to files, but the in memory representation
		/// of a field is different.
		/// </summary>
		[StructLayout(LayoutKind.Sequential, Pack=1, CharSet=CharSet.Ansi)] 
			public struct RawGffField
		{
			#region public fields/properties/methods
			public UInt32 Type;
			public UInt32 LabelIndex;
			public UInt32 DataOrDataOffset;

			/// <summary>
			/// Class constructor
			/// </summary>
			/// <param name="type">Data type of the field</param>
			public RawGffField(GffFieldType type)
			{
				Type = (UInt32) type;
				LabelIndex = 0;
				DataOrDataOffset = 0;
			}

			/// <summary>
			/// Constructor to deserialize the RawGffField from a stream.
			/// </summary>
			/// <param name="s"></param>
			public RawGffField(Stream s)
			{
				try
				{
					byte[] bytes = new Byte[4];
					s.Read(bytes, 0, bytes.Length);
					Type = BitConverter.ToUInt32(bytes, 0);
					s.Read(bytes, 0, bytes.Length);
					LabelIndex = BitConverter.ToUInt32(bytes, 0);
					s.Read(bytes, 0, bytes.Length);
					DataOrDataOffset = BitConverter.ToUInt32(bytes, 0);
				}
				catch
				{
					throw new NWNException("Invalid field in stream");
				}
			}

			/// <summary>
			/// Serializes the RawGffField to a stream.
			/// </summary>
			/// <param name="s">The stream to serialize to.</param>
			public void Serialize(Stream s)
			{
				byte[] bytes = BitConverter.GetBytes(Type);
				s.Write(bytes, 0, bytes.Length);
				bytes = BitConverter.GetBytes(LabelIndex);
				s.Write(bytes, 0, bytes.Length);
				bytes = BitConverter.GetBytes(DataOrDataOffset);
				s.Write(bytes, 0, bytes.Length);
			}

			/// <summary>
			/// Deserializes an array of RawGffFields from a stream.
			/// </summary>
			/// <param name="s">The stream</param>
			/// <param name="count">The number of fields to deserialize</param>
			/// <returns>The deserialized array</returns>
			public static RawGffField[] Deserialize(Stream s, int count)
			{
				RawGffField[] fields = new RawGffField[count];
				for (int i = 0; i < count; i++)
					fields[i] = new RawGffField(s);
				return fields;
			}

			/// <summary>
			///  Serializes an array of RawGffFields to a stream.
			/// </summary>
			/// <param name="s">The stream</param>
			/// <param name="fields">The array of fields to serialize</param>
			public static void Serialize(Stream s, RawGffField[] fields)
			{
				foreach (RawGffField gff in fields)
					gff.Serialize(s);
			}
			#endregion
		}
		#endregion

		#region public methods
		/// <summary>
		/// Constructor to create a RawGffData object used for writing a GFF file.
		/// </summary>
		public RawGffData()
		{
			access = FileAccess.Write;

			structsStream = new MemoryStream();
			fieldsStream = new MemoryStream();
			complexDataStream = new MemoryStream();
			fieldIndecesStream = new MemoryStream();
			listIndecesStream = new MemoryStream();
			labelsStream = new MemoryStream();
		}

		/// <summary>
		/// Constructor to create a RawGffData object used for reading a GFF file
		/// </summary>
		/// <param name="s">Stream for the file</param>
		/// <param name="header">The file's header</param>
		public RawGffData(Stream s, GffHeader header)
		{
			access = FileAccess.Read;

			// Read the various pieces of the GFF file into memory, placing
			// each in a read only memory stream.
			structsStream = CreateReadingStream(s, header.StructOffset,
				header.StructCount * Marshal.SizeOf(typeof(RawGffStruct)));
			fieldsStream = CreateReadingStream(s, header.FieldOffset,
				header.FieldCount * Marshal.SizeOf(typeof(RawGffField)));
			labelsStream = CreateReadingStream(s, header.LabelOffset,
				header.LabelCount * ResRefLength);
			complexDataStream = CreateReadingStream(s, header.FieldDataOffset,
				header.FieldDataCount);
			fieldIndecesStream = CreateReadingStream(s, header.FieldIndecesOffset,
				header.FieldIndecesCount);
			listIndecesStream = CreateReadingStream(s, header.ListIndecesOffset,
				header.ListIndecesCount);
		}

		/// <summary>
		/// This method initializes the module header based on the contents of
		/// the raw data object.
		/// </summary>
		/// <param name="header">The header to initialize</param>
		public void InitializeHeader(ref GffHeader header)
		{
			int offset = Marshal.SizeOf(typeof(GffHeader));

			header.StructCount = (int) structsStream.Length / Marshal.SizeOf(typeof(RawGffStruct));;
			header.StructOffset = offset;
			offset += (int) structsStream.Length;

			header.FieldCount = (int) fieldsStream.Length / Marshal.SizeOf(typeof(RawGffField));
			header.FieldOffset = offset;
			offset += (int) fieldsStream.Length;

			header.LabelCount = (int) labelsStream.Length / ResRefLength;
			header.LabelOffset = offset;
			offset += (int) labelsStream.Length;

			header.FieldDataCount = (int) complexDataStream.Length;
			header.FieldDataOffset = offset;
			offset += (int) complexDataStream.Length;

			header.FieldIndecesCount = (int) fieldIndecesStream.Length;
			header.FieldIndecesOffset = offset;
			offset += (int) fieldIndecesStream.Length;

			header.ListIndecesCount = (int) listIndecesStream.Length;
			header.ListIndecesOffset = offset;
		}

		/// <summary>
		/// Saves the raw data to the specified stream.
		/// </summary>
		/// <param name="s">The stream in which to save the raw data</param>
		public void Save(Stream s)
		{
			byte[] bytes = structsStream.GetBuffer();
			s.Write(bytes, 0, (int) structsStream.Length);

			bytes = fieldsStream.GetBuffer();
			s.Write(bytes, 0, (int) fieldsStream.Length);

			bytes = labelsStream.GetBuffer();
			s.Write(bytes, 0, (int) labelsStream.Length);

			bytes = complexDataStream.GetBuffer();
			s.Write(bytes, 0, (int) complexDataStream.Length);

			bytes = fieldIndecesStream.GetBuffer();
			s.Write(bytes, 0, (int) fieldIndecesStream.Length);

			bytes = listIndecesStream.GetBuffer();
			s.Write(bytes, 0, (int) listIndecesStream.Length);

			s.Flush();
		}

		/// <summary>
		/// Gets the index'th structure.
		/// </summary>
		/// <param name="index">The index of the structure to get</param>
		/// <returns>A RawGffStruct containing a copy of the data for the
		/// index'th structure</returns>
		public RawGffStruct GetStruct(uint index)
		{
			// Make sure that the index is valid.
			int size = Marshal.SizeOf(typeof(RawGffStruct));
			int count = (int) structsStream.Length / size;
			if (index >= count) throw new ArgumentOutOfRangeException();

			// Seek to the index'th struct and return it.
			structsStream.Seek(index * size, SeekOrigin.Begin);
			return new RawGffStruct(structsStream);
		}

		/// <summary>
		/// Adds a new structure to the end of the structure stream.  This method
		/// is only valid for write access raw data.
		/// </summary>
		/// <param name="rawStruct">The structure to add</param>
		/// <returns>The index of the addes structure, it is always added to the
		/// end of the list</returns>
		public uint AddStruct(RawGffStruct rawStruct)
		{
			if (FileAccess.Write != access) throw new InvalidOperationException();

			// Seek to the end of the stream and add the struct.
			structsStream.Seek(0, SeekOrigin.End);
			rawStruct.Serialize(structsStream);

			// Count the number of structs in the stream and return the index of
			// the last one, which is the one we just added.
			int count = (int) structsStream.Length / Marshal.SizeOf(typeof(RawGffStruct));
			return (uint) (count - 1);
		}

		/// <summary>
		/// Updates a structure that has already been written.
		/// </summary>
		/// <param name="index">The index of the structure to update</param>
		/// <param name="rawStruct">The new data</param>
		public void UpdateStruct(uint index, RawGffStruct rawStruct)
		{
			if (FileAccess.Write != access) throw new InvalidOperationException();

			// Make sure that the index is valid.
			int size = Marshal.SizeOf(typeof(RawGffStruct));
			int count = (int) structsStream.Length / size;
			if (index >= count) throw new ArgumentOutOfRangeException();

			// Seek to the structure in the stream and update the struct.
			structsStream.Seek(index * size, SeekOrigin.Begin);
			rawStruct.Serialize(structsStream);
		}

		/// <summary>
		/// Gets the index'th field.
		/// </summary>
		/// <param name="index">The index of the field to get</param>
		/// <returns>A RawGffField containing a copy of the data for the
		/// index'th field</returns>
		public RawGffField GetField(uint index)
		{
			// Make sure that the index is valid.
			int size = Marshal.SizeOf(typeof(RawGffField));
			int count = (int) fieldsStream.Length / size;
			if (index >= count) throw new ArgumentOutOfRangeException();

			// Seek to the index'th struct and return it.
			fieldsStream.Seek(index * size, SeekOrigin.Begin);
			return new RawGffField(fieldsStream);
		}

		/// <summary>
		/// Adds a new field to the end of the structure stream.  This method
		/// is only valid for write access raw data.
		/// </summary>
		/// <param name="rawStruct">The field to add</param>
		/// <returns>The index of the addes field, it is always added to the
		/// end of the list</returns>
		public uint AddField(RawGffField rawField)
		{
			if (FileAccess.Write != access) throw new InvalidOperationException();

			// Seek to the end of the stream and add the struct.
			fieldsStream.Seek(0, SeekOrigin.End);
			rawField.Serialize(fieldsStream);

			// Count the number of structs in the stream and return the index of
			// the last one, which is the one we just added.
			int count = (int) fieldsStream.Length / Marshal.SizeOf(typeof(RawGffField));
			return (uint) (count - 1);
		}

		/// <summary>
		/// Gets the index'th label.
		/// </summary>
		/// <param name="index">The index of the label to get</param>
		/// <returns>The label</returns>
		public string GetLabel(uint index)
		{
			// Make sure that the index is valid.
			int count = (int) labelsStream.Length / ResRefLength;
			if (index >= count) throw new ArgumentOutOfRangeException();

			// Seek to the index'th struct and return it.
			labelsStream.Seek(index * ResRefLength, SeekOrigin.Begin);
			byte[] bytes = new byte[ResRefLength];
			labelsStream.Read(bytes, 0, bytes.Length);
			return RawGffData.DeserializeString(bytes, 0, ResRefLength);
		}

		/// <summary>
		/// Gets the index of the given label, or -1 if it is not in the list.
		/// </summary>
		/// <param name="label">The label to get the index of</param>
		/// <returns>The index of the label or -1 if it is not in the list</returns>
		public int GetLabelIndex(string label)
		{
			// Loop through all of the strings looking for the specified label,
			// returning it's index if we find it.
			int count = (int) labelsStream.Length / ResRefLength;
			for (int i = 0; i < count; i++)
				if (label == GetLabel((uint) i)) return i;

			// We didn't find it return -1.
			return -1;
		}

		/// <summary>
		/// Adds a label to the end of the list, returning the index of the
		/// added label.
		/// </summary>
		/// <param name="label">The label to add</param>
		/// <returns>The index of the added label</returns>
		public uint AddLabel(string label)
		{
			if (FileAccess.Write != access) throw new InvalidOperationException();

			// Create a 16 byte byte array from the label (padding with 0's if
			// necessary, and write that to the stream.
			byte[] bytes = new byte[ResRefLength];
			for (int i = 0; i < ResRefLength; i++)
				bytes[i] = i < label.Length ? (byte) label[i] : (byte) 0;
			labelsStream.Write(bytes, 0, bytes.Length);

			// Get the count and return the index of the last entry, which is what
			// we just added.
			int count = (int) labelsStream.Length / ResRefLength;
			return (uint) (count - 1);
		}

		/// <summary>
		/// Reads a byte array from the complex data.
		/// </summary>
		/// <param name="offset">Offset into the complex data to start reading</param>
		/// <param name="buffer">Buffer in which to place the read data</param>
		/// <param name="length">Number of bytes to read</param>
		/// <returns>The number of bytes read</returns>
		public int ReadComplexData(uint offset, byte[] buffer, int length)
		{
			complexDataStream.Seek((int) offset, SeekOrigin.Begin);
			return complexDataStream.Read(buffer, 0, length);
		}

		/// <summary>
		/// Gets the complex data byte array to allow direct access.  The
		/// array should only be read from in this manner.
		/// </summary>
		/// <returns>The complex data byte array</returns>
		public byte[] GetComplexDataBuffer()
		{
			return complexDataStream.GetBuffer();
		}

		/// <summary>
		/// Writes a byte array to the complex data.
		/// </summary>
		/// <param name="buffer">The buffer to write</param>
		/// <param name="length">The number of bytes to write</param>
		/// <returns>The offset of the written data</returns>
		public uint WriteComplexData(byte[] buffer, int length)
		{
			if (FileAccess.Write != access) throw new InvalidOperationException();

			// Seek to the end and save that position.
			complexDataStream.Seek(0, SeekOrigin.End);
			uint pos = (uint) complexDataStream.Position;

			// Write the data and return it's offset.
			complexDataStream.Write(buffer, 0, length);
			return pos;
		}

		/// <summary>
		/// Gets a field index from the given offset.
		/// </summary>
		/// <param name="offset">The offset (in bytes) to the field index, this is
		/// NOT n index, it is the number of bytes</param>
		/// <returns>The field index</returns>
		public uint GetFieldIndex(uint offset)
		{
			return BitConverter.ToUInt32(fieldIndecesStream.GetBuffer(), (int) offset);
		}

		/// <summary>
		/// Adds a field index to the end of the list.
		/// </summary>
		/// <param name="index">The index to add</param>
		/// <returns>The offset of the written index</returns>
		public uint AddFieldIndex(uint index)
		{
			if (FileAccess.Write != access) throw new InvalidOperationException();

			// Seek to the end and save that position.
			fieldIndecesStream.Seek(0, SeekOrigin.End);
			int pos = (int) fieldIndecesStream.Position;

			// Write the data and return it's offset.
			byte[] bytes = BitConverter.GetBytes(index);
			fieldIndecesStream.Write(bytes, 0, bytes.Length);
			return (uint) pos;
		}

		/// <summary>
		/// Adds a range of field indeces to the end of the list.
		/// </summary>
		/// <param name="indeces">The indeces to add</param>
		/// <returns>The offset of the written indeces</returns>
		public uint AddFieldIndeces(uint[] indeces)
		{
			// Add all of the indeces, saving the offset of the first added index.
			uint offset = 0;
			for (int i = 0; i < indeces.Length; i++)
			{
				uint offsetCurrent = AddFieldIndex(indeces[i]);
				if (0 == i) offset = offsetCurrent;
			}

			return offset;
		}

		/// <summary>
		/// Gets the collection of list indeces at the given offset.
		/// </summary>
		/// <param name="offset">The offset of the list indeces</param>
		/// <returns>An array of list indeces read from the given offset</returns>
		public uint[] GetListIndeces(uint offset)
		{
			// Get the list count.
			byte[] bytes = listIndecesStream.GetBuffer();
			uint count = BitConverter.ToUInt32(bytes, (int) offset);
			offset += 4;

			// Read the list indeces from the stream into a uint array and
			// return it.
			uint[] indeces = new uint[count];
			for (int i = 0; i < count; i++, offset += 4)
				indeces[i] = BitConverter.ToUInt32(bytes, (int) offset);
			return indeces;
		}

		/// <summary>
		/// Adds a collection of list indeces to the end of the list.
		/// </summary>
		/// <param name="indeces">The indeces to add</param>
		/// <returns>The offset of the written indeces</returns>
		public uint AddListIndeces(uint[] indeces)
		{
			if (FileAccess.Write != access) throw new InvalidOperationException();

			// Seek to the end and save that position.
			listIndecesStream.Seek(0, SeekOrigin.End);
			int pos = (int) listIndecesStream.Position;

			// Write the number of list indeces first.
			byte[] bytes = BitConverter.GetBytes((uint) indeces.Length);
			listIndecesStream.Write(bytes, 0, bytes.Length);

			// Write the list indeces
			for (int i = 0; i < indeces.Length; i++)
			{
				bytes = BitConverter.GetBytes(indeces[i]);
				listIndecesStream.Write(bytes, 0, bytes.Length);
			}

			// Return the offset to the data.
			return (uint) pos;
		}
		#endregion

		#region public static methods
		/// <summary>
		/// Deserializes a string from a byte array.
		/// </summary>
		/// <param name="bytes">The bytes to deserialize</param>
		/// <param name="offset">The offset into the byte array</param>
		/// <param name="length">The maximum length of the string, which may be
		/// null padded in the byte array</param>
		/// <returns>A string object for the string</returns>
		public static string DeserializeString(byte[] bytes, int offset, int length)
		{
			// Calculate the actual number of used characters, which may be less
			// than the length.
			int used = 0;
			for (used = 0; used < length; used++)
				if (0 == bytes[offset + used]) break;

			// Create a character array and copy the used characters to it.
			char[] chars = new char[used];
			for (int i = 0; i < used; i++)
				chars[i] = (char) bytes[offset + i];

			// Create a string from the character array.
			return new string(chars);
		}
		#endregion

		#region private fields/properties/methods
		private const int ResRefLength = 16;

		private FileAccess access;
		private MemoryStream structsStream;
		private MemoryStream fieldsStream;
		private MemoryStream complexDataStream;
		private MemoryStream fieldIndecesStream;
		private MemoryStream listIndecesStream;
		private MemoryStream labelsStream;

		/// <summary>
		/// This method creates a read-only MemoryStream object from a piece of
		/// the passed stream.
		/// </summary>
		/// <param name="s">The source stream</param>
		/// <param name="offset">The offset into the source stream to start the
		/// memory stream at</param>
		/// <param name="length">The length of the memory stream in bytes</param>
		/// <returns>A read only memory stream representing the specified
		/// piece of the source stream</returns>
		private MemoryStream CreateReadingStream(Stream s, int offset, int length)
		{
			s.Seek(offset, SeekOrigin.Begin);
			byte[] bytes = new byte[length];
			if (bytes.Length != s.Read(bytes, 0, bytes.Length))
				throw new NWNException("Corrupt file");

			return new MemoryStream(bytes, 0, bytes.Length, false, true);
		}
		#endregion
	}


	/// <summary>
	/// This interface defines the serialization protocol that all GffField
	/// derived objects must implement.
	/// </summary>
	public interface IGffFieldSerialize
	{
		#region properties/methods
		/// <summary>
		/// Deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void Deserialize(RawGffData.RawGffField rawField, RawGffData rawData);

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 Serialize(RawGffData rawData);
		#endregion
	}


	/// <summary>
	///  This class defines a field in a GFF field.  A field is a single data
	///  value in the GFF file.  Classes derived from this must implement
	///  the IGffFieldSerialize interface.
	/// </summary>
	public abstract class GffField
	{
		#region public properties/methods
		/// <summary>
		/// Returns true if the field is a complex field.  Non-complex
		/// fields have their data stored directly in the 
		/// GffField.DataOrDataOffset, complex fields store an offset
		/// and the real data is in the raw complex data.
		/// </summary>
		public bool IsComplex
		{
			get
			{
				switch (fieldType)
				{
					case GffFieldType.DWord64:
					case GffFieldType.Int64:
					case GffFieldType.Double:
					case GffFieldType.ExoString:
					case GffFieldType.ResRef:
					case GffFieldType.ExoLocString:
					case GffFieldType.Void:
					case GffFieldType.Struct:
					case GffFieldType.List:
						return true;
				}

				return false;
			}
		}

		/// <summary>
		/// Returns true if the field is a structure.
		/// </summary>
		public bool IsStruct { get { return GffFieldType.Struct == fieldType; } }

		/// <summary>
		/// Returns true if the field is a list.
		/// </summary>
		public bool IsList { get { return GffFieldType.List == fieldType; } }

		/// <summary>
		/// Gets the data type of the field.
		/// </summary>
		public GffFieldType Type { get { return fieldType; } }

		/// <summary>
		/// Gets/sets the field value.
		/// </summary>
		public object Value
		{
			get { return fieldValue; }
			set { fieldValue = value; }
		}

		/// <summary>
		/// Gets/sets the field value.  This property will provide a way to get at
		/// the object boxed value even when invoked from within a derived class
		/// that will replace the Value property.
		/// </summary>
		public object BoxedValue
		{
			get { return fieldValue; }
			set { fieldValue = value; }
		}

		/// <summary>
		/// Override ToString() to do a ToString() on the value.
		/// </summary>
		public override string ToString()
		{
			return Value.ToString();
		}
		#endregion

		#region protected methods
		/// <summary>
		/// Class constructor
		/// </summary>
		/// <param name="fieldType">The data type of the field.</param>
		/// <param name="fieldValue">The field's value</param>
		protected GffField(GffFieldType fieldType, object fieldValue)
		{
			// Make sure the derived class implements IGffSerialize
			if (!(this is IGffFieldSerialize)) throw new NWNException("Must implement IGffSerialize");

			this.fieldType = fieldType;
			this.fieldValue = fieldValue;
		}
		#endregion

		#region private fields/properties/methods
		private GffFieldType fieldType;
		private object fieldValue;
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF byte field.
	/// </summary>
	public class GffByteField: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new byte Value
		{
			get { return (byte) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffByteField() : this(0) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="val"></param>
		public GffByteField(byte val) : base(GffFieldType.Byte, val) {}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			Value = (byte) rawField.DataOrDataOffset;
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			return (UInt32) Value;
		}
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF char field.
	/// </summary>
	public class GffCharField: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new sbyte Value
		{
			get { return (sbyte) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffCharField() : this(0) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="val"></param>
		public GffCharField(sbyte val) : base(GffFieldType.Char, val) {}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			Value = (sbyte) rawField.DataOrDataOffset;
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			return (UInt32) Value;
		}
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF word field.
	/// </summary>
	public class GffWordField: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new ushort Value
		{
			get { return (ushort) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffWordField() : this(0) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="val"></param>
		public GffWordField(ushort val) : base(GffFieldType.Word, val) {}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			Value = (ushort) rawField.DataOrDataOffset;
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			return (UInt32) Value;
		}
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF short field.
	/// </summary>
	public class GffShortField: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new short Value
		{
			get { return (short) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffShortField() : this(0) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="val"></param>
		public GffShortField(short val) : base(GffFieldType.Short, val) {}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			Value = (short) rawField.DataOrDataOffset;
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			return (UInt32) Value;
		}
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF DWord field.
	/// </summary>
	public class GffDWordField: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new uint Value
		{
			get { return (uint) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffDWordField() : this(0) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="val"></param>
		public GffDWordField(uint val) : base(GffFieldType.DWord, val) {}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			Value = (uint) rawField.DataOrDataOffset;
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			return (UInt32) Value;
		}
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF Int field.
	/// </summary>
	public class GffIntField: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new int Value
		{
			get { return (int) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffIntField() : this(0) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="val"></param>
		public GffIntField(int val) : base(GffFieldType.Int, val) {}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			Value = (int) rawField.DataOrDataOffset;
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			return (UInt32) Value;
		}
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF DWord64 field.
	/// </summary>
	public class GffDWord64Field: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new ulong Value
		{
			get { return (ulong) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffDWord64Field() : this(0) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="val"></param>
		public GffDWord64Field(ulong val) : base(GffFieldType.DWord64, val) {}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			Value = BitConverter.ToUInt64(rawData.GetComplexDataBuffer(), 
				(int) rawField.DataOrDataOffset);
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			byte[] bytes = BitConverter.GetBytes(Value);
			return rawData.WriteComplexData(bytes, bytes.Length);
		}
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF Int64 field.
	/// </summary>
	public class GffInt64Field: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new long Value
		{
			get { return (long) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffInt64Field() : this(0) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="val"></param>
		public GffInt64Field(long val) : base(GffFieldType.Int64, val) {}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			Value = BitConverter.ToInt64(rawData.GetComplexDataBuffer(), 
				(int) rawField.DataOrDataOffset);
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			byte[] bytes = BitConverter.GetBytes(Value);
			return rawData.WriteComplexData(bytes, bytes.Length);
		}
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF float field.
	/// </summary>
	public class GffFloatField: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new float Value
		{
			get { return (float) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffFloatField() : this(0) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="val"></param>
		public GffFloatField(float val) : base(GffFieldType.Float, val) {}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			byte[] bytes = BitConverter.GetBytes(rawField.DataOrDataOffset);
			Value = BitConverter.ToSingle(bytes, 0);
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			byte[] bytes = BitConverter.GetBytes(Value);
			return BitConverter.ToUInt32(bytes, 0);
		}
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF double field.
	/// </summary>
	public class GffDoubleField: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new double Value
		{
			get { return (double) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffDoubleField() : this(0.0) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="val"></param>
		public GffDoubleField(double val) : base(GffFieldType.Double, val) {}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			Value = BitConverter.ToDouble(rawData.GetComplexDataBuffer(), 
				(int) rawField.DataOrDataOffset);
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			byte[] bytes = BitConverter.GetBytes(Value);
			return rawData.WriteComplexData(bytes, bytes.Length);
		}
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF ExoString field.
	/// </summary>
	public class GffExoStringField: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new string Value
		{
			get { return (string) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffExoStringField() : this(string.Empty) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="val"></param>
		public GffExoStringField(string val) : base(GffFieldType.ExoString, val) {}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			byte[] bytes = rawData.GetComplexDataBuffer();
			uint length = BitConverter.ToUInt32(bytes, (int) rawField.DataOrDataOffset);
			Value = RawGffData.DeserializeString(bytes,
				(int) rawField.DataOrDataOffset + 4, (int) length);
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			// Write the string length first, saving the offset of the written
			// position.
			byte[] bytes = BitConverter.GetBytes(Value.Length);
			uint offset = rawData.WriteComplexData(bytes, bytes.Length);

			// Now write the string data.
			bytes = new byte[Value.Length];
			for (int i = 0; i < Value.Length; i++)
				bytes[i] = (byte) Value[i];
			rawData.WriteComplexData(bytes, bytes.Length);

			// return the offset of our data.
			return offset;
		}
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF ResRef field.
	/// </summary>
	public class GffResRefField: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new string Value
		{
			get { return (string) BoxedValue; }
			set
			{
				if (value.Length > 16) throw new OverflowException("ResRefs can only be 16 characters");
				BoxedValue = value.ToLower();
			}
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffResRefField() : this(string.Empty) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="val"></param>
		public GffResRefField(string val) : 
			base(GffFieldType.ResRef, val)
		{
			if (Value.Length > 16) throw new OverflowException("ResRefs can only be 16 characters");
		}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			byte[] bytes = rawData.GetComplexDataBuffer();
			byte length = bytes[rawField.DataOrDataOffset];
			Value = RawGffData.DeserializeString(bytes,
				(int) rawField.DataOrDataOffset + 1, (int) length);
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			// Write the string length first, saving the offset of the written
			// position.
			byte[] bytes = new Byte[1];
			bytes[0] = (byte) Value.Length;
			uint offset = rawData.WriteComplexData(bytes, bytes.Length);

			// Now write the string data.
			bytes = new byte[Value.Length];
			for (int i = 0; i < Value.Length; i++)
				bytes[i] = (byte) Value[i];
			rawData.WriteComplexData(bytes, bytes.Length);

			// return the offset of our data.
			return offset;
		}
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF ExoLocString field.
	/// </summary>
	public class GffExoLocStringField: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new ExoLocString Value
		{
			get { return (ExoLocString) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffExoLocStringField() : this(0, true, string.Empty) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="languageID">Language ID</param>
		/// <param name="male">True if string is masculine</param>
		/// <param name="val">String</param>
		public GffExoLocStringField(uint languageID, bool male, string val) : 
			base(GffFieldType.ExoLocString, new ExoLocString(languageID, male, val)) {}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			Value = new ExoLocString(rawData.GetComplexDataBuffer(), 
				(int) rawField.DataOrDataOffset);
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			byte[] bytes = Value.Serialize();
			return rawData.WriteComplexData(bytes, bytes.Length);
		}
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF bag of bytes field.
	/// </summary>
	public class GffVoidField: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new MemoryStream Value
		{
			get { return (MemoryStream) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffVoidField() : this(new MemoryStream()) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="stream">The memory stream containing the data</param>
		public GffVoidField(MemoryStream stream) : base(GffFieldType.Void, stream) {}

		/// <summary>
		/// Override ToString() to do a ToString() on the value.
		/// </summary>
		public override string ToString()
		{
			// Generate a string showing the hex byte values.
			return BitConverter.ToString(Value.GetBuffer(), 0);
		}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			// Determine the length of the bob.
			byte[] complexData = rawData.GetComplexDataBuffer();
			uint length = BitConverter.ToUInt32(complexData, (int) rawField.DataOrDataOffset);

			// Copy the data from the complex data byte array to a local byte array.
			byte[] bytes = new Byte[length];
			for (int i = 0; i < length; i++)
				bytes[i] = complexData[rawField.DataOrDataOffset + 4 + i];

			// Save the data in a memory stream.
			Value = new MemoryStream(bytes, 0, bytes.Length, true, true);
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			byte[] bytes = BitConverter.GetBytes((uint) Value.Length);
			uint offset = rawData.WriteComplexData(bytes, bytes.Length);
			rawData.WriteComplexData(Value.GetBuffer(), (int) Value.Length);
			return offset;
		}
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF structure field.
	/// </summary>
	public class GffStructField: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Gets/sets the structure type.
		/// </summary>
		public uint StructureType
		{
			get { return structureType; }
			set { structureType = value; }
		}

		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new GffFieldDictionary Value
		{
			get { return (GffFieldDictionary) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffStructField() : this(new GffFieldDictionary()) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="stream">The memory stream containing the data</param>
		public GffStructField(GffFieldDictionary dict) : base(GffFieldType.Struct, dict)
		{
			structureType = 0;
		}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			// Save the structure type.
			RawGffData.RawGffStruct rawStruct = rawData.GetStruct(rawField.DataOrDataOffset);
			structureType = rawStruct.Type;

			// Fill in the field dictionary and assign it to our value.
			Value = GetFieldStruct(rawStruct, rawData);
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			return SaveFieldStruct(structureType, Value, rawData);
		}
		#endregion

		#region public static methods
		public static GffFieldDictionary GetFieldStruct(RawGffData.RawGffStruct gstruct, 
			RawGffData rawData)
		{
			// Loop through all of the fields in the struct adding them to the
			// collection.
			GffFieldDictionary fields = new GffFieldDictionary();
			for (int i = 0; i < gstruct.FieldCount; i++)
			{
				// Get the index of the current field.  If the structure has 1
				// member then the offset is in DataOrDataOffset directly, if not
				// then DataOrDataOffset points to an array of DWORD indeces in
				// the raw field indeces block.
				uint fieldIndex = 1 == gstruct.FieldCount ?
					gstruct.DataOrDataOffset : 
					rawData.GetFieldIndex((uint) (gstruct.DataOrDataOffset + (i * 4)));

				// Get the data label.
				RawGffData.RawGffField rawField = rawData.GetField(fieldIndex);
				string label = rawData.GetLabel(rawField.LabelIndex);

				// Create a GffField object for the field and add it to the
				// dictionary, using the label as the key.
				GffField field = GffFieldFactory.CreateField(rawField, rawData);
				fields.Add(label, field);
			}

			return fields;
		}

		/// <summary>
		/// Saves all of the data associated with the given structure.
		/// </summary>
		/// <param name="type">The type ID of the structure</param>
		/// <param name="dict">The structure's dictionary</param>
		/// <param name="rawData">The raw data in which to save the structure</param>
		/// <returns>The index of the structure in the raw data</returns>
		public static uint SaveFieldStruct(uint type, GffFieldDictionary dict, 
			RawGffData rawData)
		{
			// Create the structure and fill in the data we can then add it.  Note
			// that we can't fill in the DataOrDataOffset yet since we don't know
			// what that value is until after all of the fields have been added.
			// We will update the structure when we are done.
			RawGffData.RawGffStruct rawStruct = new RawGffData.RawGffStruct(type);
			rawStruct.FieldCount = (uint) dict.Count;
			rawStruct.DataOrDataOffset = 0;
			uint structureIndex = rawData.AddStruct(rawStruct);

			// Create an array to hold all of the field index values and loop through
			// the dictionary to store all of the structure elements.
			uint[] indeces = new uint[dict.Count];
			uint i = 0;
			foreach (DictionaryEntry entry in dict)
			{
				// Get the label and field from the entry.
				string label = (string) entry.Key;
				GffField field = (GffField) entry.Value;

				// Create a raw field for the field.
				RawGffData.RawGffField rawField = new RawGffData.RawGffField(field.Type);

				// Get the index of the label, adding it if it's not in the raw data.
				rawField.LabelIndex = (uint) rawData.GetLabelIndex(label);
				if (0xffffffff == rawField.LabelIndex) 
					rawField.LabelIndex = (uint) rawData.AddLabel(label);

				// Serialize the field's data and save the offset to the serialized
				// data (for some fields the offset may be the data itself).
				IGffFieldSerialize serialize = (IGffFieldSerialize) field;
				rawField.DataOrDataOffset = serialize.Serialize(rawData);

				// Add the field to the raw data, saving the index of the added
				// field in our index array.
				indeces[i++] = rawData.AddField(rawField);
			}

			// If we have multiple fields, we have to add the index array to the
			// field indeces and save the offset, otherwise we can just save the
			// field index as our data offset.  Once we do this we have to update
			// the structure to store the offset.
			rawStruct.DataOrDataOffset = 1 == dict.Count ?
				indeces[0] : rawData.AddFieldIndeces(indeces);
			rawData.UpdateStruct(structureIndex, rawStruct);

			// Return the structure's index.
			return structureIndex;
		}
		#endregion

		#region private fields/properties/methods
		uint structureType;
		#endregion
	}


	/// <summary>
	/// Class that implements a GFF list field.
	/// </summary>
	public class GffListField: GffField, IGffFieldSerialize
	{
		#region public properties/methods
		/// <summary>
		/// Replace GffField.Value with a type specific property.
		/// </summary>
		public new GffFieldCollection Value
		{
			get { return (GffFieldCollection) BoxedValue; }
			set { BoxedValue = value; }
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public GffListField() : this(new GffFieldCollection()) {}

		/// <summary>
		/// Class constructor.
		/// </summary>
		/// <param name="stream">The memory stream containing the data</param>
		public GffListField(GffFieldCollection coll) : base(GffFieldType.List, coll) {}
		#endregion

		#region IGffFieldSerialize implementation
		/// <summary>
		/// Override to deserialize the object from the GFF file's binary data.
		/// </summary>
		/// <param name="rawField">The raw field from the GFF</param>
		/// <param name="rawData">The GFF's raw file data</param>
		void IGffFieldSerialize.Deserialize(RawGffData.RawGffField rawField, RawGffData rawData)
		{
			// Get the list of structure indeces for the items in the list
			uint[] indeces = rawData.GetListIndeces(rawField.DataOrDataOffset);

			// Create a field collection for the structures, and loop through
			// the index array.
			GffFieldCollection fields = new GffFieldCollection();
			for (int i = 0; i < indeces.Length; i++)
			{
				// Get the raw structure data for this structure.
				RawGffData.RawGffStruct rawStruct = rawData.GetStruct(indeces[i]);

				// Create a GffStructField object for the structure and set it's
				// structure type.
				GffStructField field = (GffStructField) 
					GffFieldFactory.CreateField(GffFieldType.Struct);
				field.StructureType = rawStruct.Type;

				// Create a dummy field object so we can deserialize the structure,
				// set it's DataOrDataOffset to the structure index.
				RawGffData.RawGffField dummyField = new RawGffData.RawGffField(GffFieldType.Struct);
				dummyField.LabelIndex = 0;
				dummyField.DataOrDataOffset = indeces[i];

				// Deserialize the structure.
				((IGffFieldSerialize) field).Deserialize(dummyField, rawData);

				// Add the structure to the collection.
				fields.Add(field);
			}

			Value = fields;
		}

		/// <summary>
		/// Override to serialize the object to a byte array that can be stored
		/// in the GFF's binary data.  It serializes the data according to 
		/// BioWare's GFF file specification.  Simple data items are returned
		/// in the return value, complex items are stored in the stream and 0
		/// is returned.
		/// </summary>
		/// <param name="rawData">The raw data in which to store the field's
		/// data.</param>
		/// <returns>For simple items the return value contains the item's
		/// data and the stream is uneffected.  For complex items, the
		/// return value is the offset of the written data and the items's 
		/// data is added to the end of the stream.</returns>
		UInt32 IGffFieldSerialize.Serialize(RawGffData rawData)
		{
			// Create an array to hold all of the structure indeces,
			// then loop through all of the structures, serializing
			// them and saving the returned offsets.
			uint[] indeces = new uint[Value.Count];
			for (int i = 0; i < Value.Count; i++)
			{
				IGffFieldSerialize serialize = (IGffFieldSerialize) Value[i];
				indeces[i] = serialize.Serialize(rawData);
			}

			// Add the index array to the list indeces and return that offset.
			return rawData.AddListIndeces(indeces);
		}
		#endregion
	}


	/// <summary>
	/// This class is a factory class to create GffField derived objects.
	/// </summary>
	public class GffFieldFactory
	{
		#region public static methods
		/// <summary>
		/// Creates a GffField derived object for the specified field type.
		/// </summary>
		/// <param name="type">The type of object to create</param>
		/// <returns>The created GffField derived object</returns>
		public static GffField CreateField(GffFieldType type)
		{
			switch (type)
			{
				case GffFieldType.Byte:
					return new GffByteField();
				case GffFieldType.Char:
					return new GffCharField();
				case GffFieldType.Word:
					return new GffWordField();
				case GffFieldType.Short:
					return new GffShortField();
				case GffFieldType.DWord:
					return new GffDWordField();
				case GffFieldType.Int:
					return new GffIntField();
				case GffFieldType.Float:
					return new GffFloatField();
				case GffFieldType.DWord64:
					return new GffDWord64Field();
				case GffFieldType.Int64:
					return new GffInt64Field();
				case GffFieldType.Double:
					return new GffDoubleField();
				case GffFieldType.ResRef:
					return new GffResRefField();
				case GffFieldType.ExoString:
					return new GffExoStringField();
				case GffFieldType.Void:
					return new GffVoidField();
				case GffFieldType.Struct:
					return new GffStructField();
				case GffFieldType.List:
					return new GffListField();
				case GffFieldType.ExoLocString:
					return new GffExoLocStringField();
				default:
					throw new NWNException("Unsupported data type");
			}
		}

		/// <summary>
		/// Creates a GffField derived object and deserializes the field's data
		/// into the created object.
		/// </summary>
		/// <param name="rawField">The raw field data for the object to create</param>
		/// <param name="rawData">The raw GFF file data</param>
		/// <returns>The created GffField derived object</returns>
		public static GffField CreateField(RawGffData.RawGffField rawField, 
			RawGffData rawData)
		{
			// Create an empty GffField object.
			GffField field = CreateField((GffFieldType) rawField.Type);

			// Get the field's IGffFieldSerialize implementation.
			IGffFieldSerialize serialize = field as IGffFieldSerialize;
			if (null == serialize) throw new InvalidCastException("IGffSerialize not implemented");

			// Deserialize the object.
			serialize.Deserialize(rawField, rawData);
			return field;
		}
		#endregion
	}


	/// <summary>
	/// This class implements a dictionary based collection of GffField
	/// objects.  This is used to store the data for a structure in the
	/// GFF file, where each data element may be referenced by it's label.
	/// Any data item with a data type of struct (including the root top
	/// level struct) has a GffFieldDictionary object as it's value.
	/// </summary>
	public class GffFieldDictionary: DictionaryBase
	{
		#region public properties/methods
		/// <summary>
		/// Indexer to lookup a field based on it's label.
		/// </summary>
		public GffField this[string label] 
		{ get { return InnerHashtable[label] as GffField; } }

		/// <summary>
		/// Indexer to get the index'th DictionaryEntry in the collection.
		/// It uses the ordered entries list to give the entries back in the same
		/// order that they were placed in the collection.
		/// </summary>
		public DictionaryEntry this[int index] 
		{ get { return (DictionaryEntry) orderedEntries[index]; } }

		/// <summary>
		/// Class constructor.
		/// </summary>
		public GffFieldDictionary()
		{
			orderedEntries = new ArrayList();
		}

		/// <summary>
		/// Adds a field to the dictionary.
		/// </summary>
		/// <param name="label">The field's label</param>
		/// <param name="field">The field's data</param>
		public void Add(string label, GffField field)
		{
			// Add the entry to the hashtable in the dictionary, then
			// add it to the end of our ordered entries collection.  The
			// ordered entries collectoin will allow us to traverse the
			// dictionary in the order that the entries were added, preserving
			// this order.
			InnerHashtable.Add(label, field);
			DictionaryEntry entry = new DictionaryEntry(label, field);
			orderedEntries.Add(entry);
		}

		/// <summary>
		/// Replace GetEnumerator() to return an enumerator that uses the
		/// orderedEntries collection rather than the dictionary to enumerate
		/// the objects.
		/// </summary>
		/// <returns>The dictionary enumerator</returns>
		public new IDictionaryEnumerator GetEnumerator()
		{
			return new Enumerator(orderedEntries);
		}
		#endregion

		#region private fields/properties/methods
		private ArrayList orderedEntries;

		/// <summary>
		/// Nested class to enumerate the dictionary entries using the
		/// orderedEntries collection rather than the dictionary.  This allows
		/// us to enumerate them in the order they were added.
		/// </summary>
		private class Enumerator: IDictionaryEnumerator
		{
			#region implementation
			public DictionaryEntry Entry { get { return (DictionaryEntry) Current; } }
			public object Key { get { return Entry.Key; } }
			public object Value { get { return Entry.Value; } }
			public object Current { get { return baseEnumerator.Current; } }
			public bool MoveNext() { return baseEnumerator.MoveNext(); }
			public void Reset() { baseEnumerator.Reset(); }

			public Enumerator(ArrayList list) { baseEnumerator = list.GetEnumerator(); }

			private IEnumerator baseEnumerator;
			#endregion
		}
		#endregion
	}

	
	/// <summary>
	/// This class implements a collection of GffField objects.  This is used 
	/// to store the data for a list in the GFF file.  Any data item with a 
	/// data type of list has a GffFieldCollection object as it's value.  Lists
	/// in GFF files are always lists of structures (even if the structures only
	/// have 1 item) so each GffField in the list should be a structure (which
	/// means that it's value will be a GffFieldDictionary).
	/// </summary>
	public class GffFieldCollection: CollectionBase
	{
		#region public properties/methods
		/// <summary>
		/// Indexer to access the individual GffField objects.
		/// </summary>
		public GffField this[int index]
		{
			get
			{
				return InnerList[index] as GffField;
			}
		}

		/// <summary>
		/// Class constructor
		/// </summary>
		public GffFieldCollection()
		{
		}

		/// <summary>
		/// Adds a field to the end of the collection.
		/// </summary>
		/// <param name="field"></param>
		public void Add(GffField field)
		{
			InnerList.Add(field);
		}

		/// <summary>
		/// Adds a field at the specified position in the collection.
		/// </summary>
		/// <param name="index">The index of the field to add</param>
		/// <param name="field">The field to add</param>
		public void Insert(int index, GffField field)
		{
			InnerList.Insert(index, field);
		}
		#endregion
	}


	/// <summary>
	/// This class implements a GFF file.  This is a generic file format used
	/// by BioWare to store various game items.  It provides the base functionality
	/// to read/write the GFF file into a data tree.  GFF files are trees,
	/// consisting of a top level structure, which contains fields, which themselves
	/// may be structures or lists of structures.  Each field in the tree is
	/// represented by a GffField object, the value of which is dependent on the
	/// data type of the field.  Structures are represented by GffFieldDictionary
	/// objects, and lists by GffFieldCollection objects.
	/// 
	/// The various kinds of GFF files may derive from this base class to gain
	/// the load/save functionality, and then provide easier access to the file
	/// data.
	/// </summary>
	public class Gff
	{
		#region public properties/methods
		/// <summary>
		/// Gets the file name of the GFF file.
		/// </summary>
		public string Name { get { return Path.GetFileName(fileName); } }

		/// <summary>
		/// Property to provide access to the GFF file's top level structure.
		/// </summary>
		public GffFieldDictionary TopLevel { get { return topLevel; } }

		/// <summary>
		/// Class constructor to create a GFF object from a file.
		/// </summary>
		/// <param name="fileName">The file to load.</param>
		public Gff(string fileName)
		{
			using (FileStream reader = new FileStream(fileName, FileMode.Open, 
					   FileAccess.Read, FileShare.Read))
			{
				LoadStream(reader);
				this.fileName = fileName;
			}
		}

		/// <summary>
		/// Class constructor to create a GFF object from a stream.  The GFF file
		/// should begin at the stream's current seek point.
		/// </summary>
		/// <param name="stream">The stream to create the object from.</param>
		public Gff(Stream stream)
		{
			LoadStream(stream);
			fileName = "";
		}

		/// <summary>
		/// Saves the GFF, overwriting the old copy.
		/// </summary>
		public void Save()
		{
			SaveAs(fileName);
		}

		/// <summary>
		/// Saves the GFF, using a new file name.
		/// </summary>
		/// <param name="fileName">The new file name for the GFF</param>
		public void SaveAs(string fileName)
		{
			// Save the top level structure to the raw data.
			RawGffData rawData = new RawGffData();
			GffStructField.SaveFieldStruct(0xffffffff, topLevel, rawData);

			// Create a header for the GFF file.
			string type = Path.GetExtension(fileName);
			type = type.Substring(1, type.Length - 1);
			GffHeader header = new GffHeader(type);
			rawData.InitializeHeader(ref header);

			// Create the disk file and save the header and raw data.
			using (FileStream writer = new FileStream(fileName, FileMode.Create,
					   FileAccess.Write, FileShare.Write))
			{
				header.Serialize(writer);
				rawData.Save(writer);
				writer.Close();
			}
		}
		#endregion

		#region protected properties/methods
		/// <summary>
		/// Gets the GffField derived object for the given schema.  It will check
		/// the top level structure for the field, if it is not found then it will
		/// create it and add it to the top level structure.
		/// </summary>
		/// <param name="schema">The field's schema</param>
		/// <returns>The GffField derived object for the field.</returns>
		protected GffField GetField (GffFieldSchema schema) { return GetField(schema, topLevel); }

		/// <summary>
		/// Gets the GffField derived object for the given schema.  It will check
		/// the passed field dictionary for the field, if it is not found then it will
		/// create it and add it to the dictionary.
		/// </summary>
		/// <param name="schema">The field's schema</param>
		/// <param name="dict">The field dictionary to check</param>
		/// <returns>The GffField derived object for the field.</returns>
		protected GffField GetField (GffFieldSchema schema, GffFieldDictionary dict)
		{
			// Look up the field for the label.  If we cannot look it up then
			// it has not been added to the module info file, we need to add
			// it ourselves.
			GffField field = dict[schema.Tag];
			if (null == field)
			{
				field = schema.CreateField();
				dict.Add(schema.Tag, field);
			}

			return field;
		}
		#endregion

		#region private fields/properties/methods
		private string fileName;
		private GffFieldDictionary topLevel;

		/// <summary>
		/// Loads the GFF file from the specified stream.
		/// </summary>
		/// <param name="stream">The stream to load the GFF file from.s</param>
		private void LoadStream(Stream stream)
		{
			// Read the header.
			NWNLogger.Log(0, "Gff.LoadStream loading header");
			GffHeader header = new GffHeader(stream);
			NWNLogger.Log(1, "Gff.LoadStream version {0}", header.VersionText);
			if ("V3.2" != header.VersionText) 
				throw new NWNException("Version {0} GFF files are unsupported", header.VersionText);

			NWNLogger.Log(0, "Gff.LoadStream reading raw GFF data");
			RawGffData rawData = new RawGffData(stream, header);
			topLevel = GffStructField.GetFieldStruct(rawData.GetStruct(0), rawData);
		}
		#endregion
	}
}
