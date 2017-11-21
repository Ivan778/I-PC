namespace DeviceManager
{
    partial class DeviceManager
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.ContentTable = new System.Windows.Forms.ListView();
            this.DeviceName = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.Hardware = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.GUID = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.Manufacturer = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.DriverDescription = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.DriverPath = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.Status = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.SuspendLayout();
            // 
            // ContentTable
            // 
            this.ContentTable.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.DeviceName,
            this.Hardware,
            this.GUID,
            this.Manufacturer,
            this.DriverDescription,
            this.DriverPath,
            this.Status});
            this.ContentTable.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ContentTable.Location = new System.Drawing.Point(0, 0);
            this.ContentTable.Name = "ContentTable";
            this.ContentTable.Size = new System.Drawing.Size(1214, 492);
            this.ContentTable.TabIndex = 0;
            this.ContentTable.UseCompatibleStateImageBehavior = false;
            this.ContentTable.View = System.Windows.Forms.View.Details;
            // 
            // DeviceName
            // 
            this.DeviceName.Text = "Device Name";
            this.DeviceName.Width = 108;
            // 
            // Hardware
            // 
            this.Hardware.Text = "Hardware";
            this.Hardware.Width = 119;
            // 
            // GUID
            // 
            this.GUID.Text = "GUID";
            this.GUID.Width = 162;
            // 
            // Manufacturer
            // 
            this.Manufacturer.Text = "Manufacturer";
            this.Manufacturer.Width = 179;
            // 
            // DriverDescription
            // 
            this.DriverDescription.Text = "Driver Description";
            this.DriverDescription.Width = 265;
            // 
            // DriverPath
            // 
            this.DriverPath.Text = "Driver Path";
            this.DriverPath.Width = 284;
            // 
            // Status
            // 
            this.Status.Text = "Status";
            this.Status.Width = 241;
            // 
            // DeviceManager
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1214, 492);
            this.Controls.Add(this.ContentTable);
            this.Name = "DeviceManager";
            this.Text = "Device Manager";
            this.Load += new System.EventHandler(this.LoadingTheView);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ListView ContentTable;
        private System.Windows.Forms.ColumnHeader DeviceName;
        private System.Windows.Forms.ColumnHeader Hardware;
        private System.Windows.Forms.ColumnHeader GUID;
        private System.Windows.Forms.ColumnHeader Manufacturer;
        private System.Windows.Forms.ColumnHeader DriverDescription;
        private System.Windows.Forms.ColumnHeader DriverPath;
        private System.Windows.Forms.ColumnHeader Status;
    }
}

