#include <stdio.h>

int square(int x) {
	return x;
}

int main() {
	printf("%d\n", square(5));

	if(square(5) > 10) {
		printf("whoop\n");
	} else {
		printf("noop\n");
	}

	return 0;
};
