#include <bits/stdc++.h>

using namespace std;

bool isPrime(char c) {
	return c == '2' || c == '3' || c == '5' || c == '7';
}

void decrease(string& n, int i) {
	if (n[i] <= '2') {
		n.erase(i, 1);
		n[i] = '7';
	}else if (n[i] == '3') {
		n[i] = '2';
    }else if (n[i] <= '5') {
		n[i] = '3';
    }else if (n[i] <= '7') {
		n[i] = '5';
    }else {
		n[i] = '7';
    }
	return;
}

string getPrimeDigitsNumber(string n) {
	for (int i = 0; i < n.length(); i++) {

		if (!isPrime(n[i])) {

			while (n[i] <= '2' && i >= 0) {
				i--;
            }

			if (i < 0) {
				i = 0;
			}
            decrease(n, i);

			for (int j = i + 1; j < n.length(); j++) {
				n[j] = '7';
            }
			break;
		}
	}

	return n;
}

int main() {
	string n = "7464";
	cout << getPrimeDigitsNumber(n) << endl;
	return 0;
}