using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using NWN.FileTypes.Gff;

namespace HakInstaller
{
	/// <summary>
	/// Summary description for GffForm.
	/// </summary>
	public class GffForm : System.Windows.Forms.Form
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public GffForm(NWN.FileTypes.Gff.Gff gff)
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			this.gff = gff;
		}

		private System.Windows.Forms.TreeView tree;

		private NWN.FileTypes.Gff.Gff gff;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.tree = new System.Windows.Forms.TreeView();
			this.SuspendLayout();
			// 
			// tree
			// 
			this.tree.Dock = System.Windows.Forms.DockStyle.Fill;
			this.tree.ImageIndex = -1;
			this.tree.Name = "tree";
			this.tree.SelectedImageIndex = -1;
			this.tree.Size = new System.Drawing.Size(536, 390);
			this.tree.TabIndex = 0;
			// 
			// GffForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(536, 390);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.tree});
			this.Name = "GffForm";
			this.Text = "GffForm";
			this.Load += new System.EventHandler(this.GffForm_Load);
			this.ResumeLayout(false);

		}
		#endregion

		private void AddDictNodes (TreeNode parent, GffFieldDictionary dict)
		{
			System.Text.StringBuilder b = new System.Text.StringBuilder(1024);
			foreach (DictionaryEntry entry in dict)
			{
				GffField field = (GffField) entry.Value;

				if (field.IsList)
				{
					TreeNode node = parent.Nodes.Add(entry.Key.ToString());
					AddCollNodes(node, ((GffListField) field).Value);
				}
				else if (field.IsStruct)
				{
					TreeNode node = parent.Nodes.Add(entry.Key.ToString());
					AddDictNodes(node, ((GffStructField) field).Value);
				}
				else
				{
					b.Length = 0;
					b.AppendFormat ("{0} = [{1}]", entry.Key.ToString(), field.ToString());
					parent.Nodes.Add(b.ToString());
				}
			}
		}

		private void AddCollNodes(TreeNode parent, GffFieldCollection coll)
		{
			System.Text.StringBuilder b = new System.Text.StringBuilder(1024);
			int i = 0;
			foreach (GffField field in coll)
			{
				string name = "Entry_" + i.ToString();
				i++;

				if (field.IsList)
				{
					TreeNode node = parent.Nodes.Add(name);
					AddCollNodes(node, ((GffListField) field).Value);
				}
				else if (field.IsStruct)
				{
					TreeNode node = parent.Nodes.Add(name);
					AddDictNodes(node, ((GffStructField) field).Value);
				}
				else
				{
					b.Length = 0;
					b.AppendFormat ("{0} = [{1}]", name, field.Value.ToString());
					parent.Nodes.Add(b.ToString());
				}
			}
		}

		private void GffForm_Load(object sender, System.EventArgs e)
		{
			this.Text = gff.Name;
			GffFieldDictionary top = gff.TopLevel;

			TreeNode parent = tree.Nodes.Add("Top");
			AddDictNodes(parent, top);
		}
	}
}
