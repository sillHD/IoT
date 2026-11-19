/* The Border Router starts by itself once Wi-Fi is up and the Thread network
 * is formed; everything in Lab 5 happens on the shell.
 *
 * Lab 8 builds with autostart.conf (CONFIG_LAB_AUTOSTART): the Thread network
 * and the Wi-Fi credentials stay in flash, and both are rejoined at boot, so a
 * power cut needs nobody at the console.
 */
#include <zephyr/device.h>
#include <zephyr/devicetree.h>
#include <zephyr/drivers/uart.h>
#include <zephyr/kernel.h>
#include <zephyr/logging/log.h>
#include <zephyr/sys/printk.h>

#define USB_CONSOLE_NODE DT_CHOSEN(zephyr_console)

BUILD_ASSERT(DT_NODE_HAS_COMPAT(USB_CONSOLE_NODE, zephyr_cdc_acm_uart),
	     "zephyr,console must point to a zephyr,cdc-acm-uart node");

#if defined(CONFIG_LAB_AUTOSTART)
#include <zephyr/net/net_if.h>
#include <zephyr/net/net_mgmt.h>
#include <zephyr/net/wifi_credentials.h>
#include <zephyr/net/wifi_mgmt.h>
#include <openthread.h>
#include <openthread/dataset.h>

LOG_MODULE_REGISTER(lab5_border_router, LOG_LEVEL_INF);

static void autostart(void)
{
	struct net_if *wifi = net_if_get_first_wifi();
	bool stored;

	if (wifi != NULL && !wifi_credentials_is_empty()) {
		LOG_INF("Connecting to the stored Wi-Fi network");
		(void)net_mgmt(NET_REQUEST_WIFI_CONNECT_STORED, wifi, NULL, 0);
	} else {
		LOG_INF("No Wi-Fi network stored: add one with \"wifi cred add\"");
	}

	openthread_mutex_lock();
	stored = otDatasetIsCommissioned(openthread_get_default_instance());
	openthread_mutex_unlock();
	if (stored && openthread_run() == 0) {
		LOG_INF("Rejoining the stored Thread network");
	} else if (!stored) {
		LOG_INF("No Thread network stored: form one (SOP-05 §2)");
	}
}
#endif

int main(void)
{
	const struct device *const console = DEVICE_DT_GET(USB_CONSOLE_NODE);
	uint32_t dtr = 0U;

	/* CONFIG_CDC_ACM_SERIAL_INITIALIZE_AT_BOOT initializes and enables USB
	 * before main().  On failure there is no usable console on which to report
	 * the error, so keep the firmware alive instead of returning.
	 */
	if (!device_is_ready(console)) {
		for (;;) {
			k_sleep(K_FOREVER);
		}
	}

	/* Wait until a host terminal opens the CDC port.  USB remains enumerated
	 * while waiting, and printk output is not lost before DTR is asserted.
	 */
	while (dtr == 0U) {
		(void)uart_line_ctrl_get(console, UART_LINE_CTRL_DTR, &dtr);
		k_sleep(K_MSEC(100));
	}

	printk("SoilSense Border Router: native USB CDC-ACM console ready\n");

#if defined(CONFIG_LAB_AUTOSTART)
	autostart();
#endif

	/* The shell and network services have their own threads, but keeping main
	 * alive also makes the console lifetime explicit and prevents an accidental
	 * return from being confused with a serial disconnect.
	 */
	for (;;) {
		k_sleep(K_FOREVER);
	}
}
