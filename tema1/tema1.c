#include <unistd.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>

static int write_stdout(const char *token, int length)
{
	int rc;
	int bytes_written = 0;

	do {
		rc = write(1, token + bytes_written, length - bytes_written);
		if (rc < 0)
			return rc;

		bytes_written += rc;
	} while (bytes_written < length);

	return bytes_written;
}
//Result reprezinta sirul in care va fi stocat outputul, cout reprezinta
//lungimea acestui sir care creste de fiecare data cand adugam un nou caracter.
int iocla_printf(const char *format, ...)
{
	va_list args;
	char result[1000000];
	int count = 0;
	va_start(args, format);
	int i;
	for ( i = 0; i < strlen(format); ++i) {
		//daca in stringul 'format' intalnesc 2 caractere consecutive de "%",
		//copiez in result pe unul dintre ele si sar peste celalalt.
		if(format[i] == '%' && format[i + 1] == '%') {
			result[count] = '%';
			count++;
			i++;
		}
		//daca nu verific cazurile speciale
		else if(format[i] == '%' && format[i + 1] != '%') {
			///daca numarul este negativ copiez in result "-", transform
			//apoi numarul in unsigned int, il impart repetat la 10 si bag cifrele
			//intr un vector aux ca si char, apoi parcurg stringul invers si il bag in
			//result
			if(format[i + 1] == 'd') {
				int number = va_arg(args, int);
				unsigned int  number_ok;
				if(number < 0) {
					result[count] = '-';
					count++;
					number_ok = -number;
				}
				else
				{
					number_ok = number;
				}
				char aux[1000];
				int contor = 0;
				while(number_ok) {
					aux[contor] = number_ok % 10 + '0';
					number_ok = number_ok / 10;
					contor++;
				}
				for(int j = contor - 1; j >= 0; j--) {
					result[count] = aux[j];
					count++;
				}
				i++;
			}
			//castez numarul la unsigned int,il impart repetat la 10 si bag cifrele
			//intr-un vector aux ca si char, apoi parcurg stringul invers si il bag in
			//result
			if(format[i + 1] == 'u') {
				unsigned int number = va_arg(args, unsigned int);
				char aux[1000];
				int contor = 0;
				while(number) {
					aux[contor] = number % 10 + '0';
					number = number / 10;
					contor++;
				}
				for(int j = contor - 1; j >= 0; j--) {
					result[count] = aux[j];
					count++;
				}
				i++;
			}
			//castez numarul la unsigned int,il impart repetat la baza 16 si bag numerele
			//intr-un vector vector_resturi, apoi parcurg vectorul invers si bag numerele 
			//ca si caracter
			if(format[i + 1] == 'x') {
				unsigned int number = va_arg(args, unsigned int);
				int vector_resturi[10000];
				int index = 0;
				while(number) {
					int rest = number % 16;
					vector_resturi[index] = rest;
					index++;
					number = number / 16;
				}
				for(int j = index - 1; j >= 0; j--) {
					if(vector_resturi[j] < 10) {
						result[count] = vector_resturi[j] + '0';
						count++;
					}
					if(vector_resturi[j] == 10) {
						result[count] = 'a';
						count++;
					}
					if(vector_resturi[j] == 11) {
						result[count] = 'b';
						count++;
					}
					if(vector_resturi[j] == 12) {
						result[count] = 'c';
						count++;
					}
					if(vector_resturi[j] == 13) {
						result[count] = 'd';
						count++;
					}
					if(vector_resturi[j] == 14) {
						result[count] = 'e';
						count++;
					}
					if(vector_resturi[j] == 15) {
						result[count] = 'f';
						count++;
					}
				}
				i++;
			}
			//parcurg ce imi intoarce va_argul si bag caracter cu caracter 
			//in result
			if(format[i + 1] == 's') {
				char *aux = va_arg(args, char *);
				for(int j = 0; j < strlen(aux); j++) {
					result[count] = aux[j];
					count++;
				}
				i++;
			}
			//bag caracterul in result
			if(format[i + 1] == 'c') {
				result[count] = va_arg(args, int);
				count++;
				i++;
			}

		}
		else if(format[i] == '\n') {
			char c = '\n';
			result[count] = c;
			count++;
		}

		else if(format[i] == '\t') {
			char c = '\t';
			result[count] = c;
			count++;
		}
		else {
			result[count] = format[i];
			count++;
		}
	}
	//returnez Stringul folosind functia write_stdout
	return write_stdout((char *) result, count);
}