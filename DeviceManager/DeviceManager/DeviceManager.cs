
using System;
using System.Collections.Generic;
using System.Management;
using System.Threading;
using System.Windows.Forms;

namespace DeviceManager
{
    public partial class DeviceManager : Form
    {
        private List<DeviceInfo> _devices;

        private readonly WqlEventQuery _query = new WqlEventQuery("SELECT * FROM Win32_DeviceChangeEvent");
        private ManagementEventWatcher _watcher;

        public DeviceManager()
        {
            InitializeComponent();
        }

        private void LoadingTheView(object sender, EventArgs e)
        {         
            _watcher = new ManagementEventWatcher();
            _watcher.EventArrived += UpdateTableContent;
            _watcher.Query = _query;
            UpdateTableContent(null,null);
        }

        private void UpdateTableContent(object sender, EventArgs e)
        {
            _watcher.Stop();
            Toggle.Invoke((Action) ToggleButton);

            _devices = GetAllDevicesInfo.Devices;
            ContentTable.Invoke((Action) FillTheTableWithContent);

            Toggle.Invoke((Action)ToggleButton);
            _watcher.Start();
        }

        private void ToggleButton()
        {
            Toggle.Enabled = !Toggle.Enabled;
        }

        private void FillTheTableWithContent()
        {
            ContentTable.Items.Clear();
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

        private void Toogle_Click(object sender, EventArgs e)
        {
            var indexes = ContentTable.SelectedIndices;
            if (indexes.Count == 1)
            {
                var device = _devices[indexes[0]];
                if (device.GetStatus() == false)
                {
                    if (device.DisableDevice())
                    {
                        MessageBox.Show(@"Устройство отключено.", @"Успех!", MessageBoxButtons.OK);
                    }
                    else
                    {
                        MessageBox.Show(@"Устройство не удалось отключить.", @"Ошибка!", MessageBoxButtons.OK);
                    }
                }
                else
                {
                    if (device.EnableDevice())
                    {
                        MessageBox.Show(@"Устройство включено.", @"Успех!", MessageBoxButtons.OK);
                    }
                    else
                    {
                        MessageBox.Show(@"Устройство не удалось включить.", @"Ошибка!", MessageBoxButtons.OK);
                    }
                }
            }
            else
            {
                MessageBox.Show(@"Выдели одно устройство.", @"Ошибка!", MessageBoxButtons.OK);
            }
            ContentTable.SelectedIndices.Clear();
            ContentTable.SelectedItems.Clear();
        }
    }
}