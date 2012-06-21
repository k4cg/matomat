/*
 * Print Mifare Classic UID.
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <nfc/nfc.h>

int main(int argc, char **argv) {
        nfc_device_t *device = NULL;
	nfc_target_t ant[1];
	unsigned int i = 0;
	nfc_modulation_t nm = {
		.nmt = NMT_ISO14443A,
		.nbr = NBR_106,
	};

	/* just use the first nfc you can find... */
	device = nfc_connect(NULL);
	if (device == NULL) {
		fprintf(stderr, "nfc_connect() failed.");
		return EXIT_FAILURE;
	}
	nfc_initiator_init(device);

	/* sleep until a tag is found, print UID and exit */
	while(1) {
		if (nfc_initiator_list_passive_targets (device, nm, ant, 1, &i) && i) {
			i = (ant[0].nti.nai.abtUid[0] << 24) | (ant[0].nti.nai.abtUid[1] << 16) | (ant[0].nti.nai.abtUid[2] << 8) | ant[0].nti.nai.abtUid[3];
			printf("%u\n", i);
			exit(EXIT_SUCCESS);
		}
		sleep(1);
	}

	/* never reached... */
	return EXIT_FAILURE;
}
