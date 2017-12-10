#include <stdio.h>
#include <stdlib.h>

#define LIST_SIZE 256
#define ROUNDS 64
#define XORS_SIZE 16
// XOR_BLOCK_SIZE needs to be integer equal to LIST_SIZE/XORS_SIZE
#define XOR_BLOCK_SIZE 16

char* read_input_from_file(const char *fname) {
    FILE *inputfile;
    inputfile = fopen(fname, "r");
    if (inputfile) {
        int c;
        int i = 0;
        char* inputstr = malloc(256*sizeof(char));
        while ((c = getc(inputfile)) != EOF) {
            inputstr[i] = c;
            i++;
        }
        fclose(inputfile);
        inputstr[i] = '\0';
        return inputstr;
    }
    else {
        printf("Error: File not found");
        return 0;
    }
}

void to_lengths(char *input) {
    int i;
    while (input[i] != '\0') i++;
    input[i]   = 17;
    input[i+1] = 31;
    input[i+2] = 73;
    input[i+3] = 47;
    input[i+4] = 23;
    // -1 marks the end of array
    input[i+5] = -1;
}

void reverse(int* list, const int first, const int len) {
    int temp_list[LIST_SIZE];
    for (int i = 0; i < len; i++) {
        temp_list[i] = list[(first+i)%LIST_SIZE];
    }
    for (int i = 0; i < len; i++) {
        list[(first+i)%LIST_SIZE] = temp_list[(len-1)-i];
    }
}

int main (int argc, char **argv) {
    char *input;
    if (argc == 2) {
        input = argv[1];
    }
    else {
        input = read_input_from_file("10-input.txt");
    }
    if (input == 0) return 1;

    printf("Input:\n%s\n", input);
    to_lengths(input);

    int cursor = 0;
    int skip_size = 0;
    int the_list[LIST_SIZE];
    for (int i = 0; i < LIST_SIZE; i++) {
        the_list[i] = i;
    }

    for (int j = 0; j < ROUNDS; j++) {
        for (int i = 0; input[i] != -1; i++) {
            if (input[i] > LIST_SIZE) {
                printf("Error: Lengths larger than the size of the list are invalid!");
                return 1;
            }
            reverse(the_list, cursor, input[i]);
            cursor = (cursor+input[i]+skip_size)%LIST_SIZE;
            skip_size++;
        }
    }

    int xors[XORS_SIZE];
    for (int i = 0; i < LIST_SIZE; i++) {
        xors[i] = 0;
        for (int j = 0; j < XOR_BLOCK_SIZE; j++) {
            xors[i] = xors[i] ^ the_list[XOR_BLOCK_SIZE*i+j];
        }
    }
    
    printf("Hash:\n");
    for (int i = 0; i < XORS_SIZE; i++) {
        printf("%02x", xors[i]);
    }
    printf("\n");

    return 0;
}
