void nputchar(char c, u32 n) {
    for(u32 i = 0; i < n; i++) putchar(c);
}

void hexdump(u8 *src, u32 len) {
	u8 i = 0;
	u32 j = 0;
	while(len) {
		if(j % 16 == 0) {
            printf("%04X: ", j);
		}
		j++;
		
        printf("%02X", *src);
		
		i++;
		if(i % 16 == 0) {
			u8 *s = src - 15;
			u8 k = 0;

			printf("    ");

			for(; k < 16; k++) {
				u8 x = *s;
				s++;

				if(x >= 33 && x <= 126) {
					putchar(x);
				} else {
					putchar('.');
				}
			}

			i = 0;
			putchar('\n');
		} else if(i % 2 == 0) {
			putchar(' ');
		}

		len--;
		src++;
	}
}