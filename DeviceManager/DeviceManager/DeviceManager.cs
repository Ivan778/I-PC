using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace DeviceManager
{
    public partial class DeviceManager : Form
    {
        private List<DeviceInfo> _devices;

        public DeviceManager()
        {
            InitializeComponent();
        }

        private void LoadingTheView(object sender, EventArgs e)
        {
            FillTheTableWithContent();
        }

        private void FillTheTableWithContent()
        {
            ContentTable.Items.Clear();
            _devices = GetAllDevicesInfo.Devices;

            foreach (var device in _devices)
            {
                var deviceInfo = new ListViewItem(device.GetName());
                deviceInfo.SubItems.Add(device.GetStatus() ? "Disabled" : "Enabled");

                ContentTable.Items.Add(deviceInfo);
            }
        }

        private void ContentTable_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            var device = _devices[ContentTable.HitTest(e.Location).Item.Index];
            var infoForm = new DetailedDeviceInfo(device);
            infoForm.Show();
        }
    }
}