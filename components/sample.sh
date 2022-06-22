#!bin/bash
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