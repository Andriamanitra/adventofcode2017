#include <stdio.h>
#include <stdlib.h>

#define LIST_SIZE 256

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

int* int_array_from_string(const char *input, const char separator) {
    int i = 0;
    int j = 0;
    int k = 0;
    int* result = malloc(256*sizeof(int));
    char numstr[16];
    while (1) {
        if (input[i] == separator || input[i] == '\0') {
            numstr[k] = '\0';
            result[j] = atoi(numstr);
            if (input[i] == '\0') {
                result[j+1] = -1;
                break;
            }
            j++;
            k = 0;
        }
        else {
            numstr[k] = input[i];
            k++;
        }
        i++;
    }
    return result;
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
    char *input_str;
    if (argc == 2) {
        input_str = argv[1];
    }
    else {
        input_str = read_input_from_file("10-input.txt");
    }
    if (input_str == 0) return 1;

    printf("Input: %s\n", input_str);
    int* input = int_array_from_string(input_str, ',');

    int cursor = 0;
    int skip_size = 0;
    int the_list[LIST_SIZE];
    for (int i = 0; i < LIST_SIZE; i++) {
        the_list[i] = i;
    }

    for (int i = 0; input[i] != -1; i++) {
        if (input[i] > LIST_SIZE) {
            printf("Error: Lengths larger than the size of the list are invalid!");
            return 1;
        }
        reverse(the_list, cursor, input[i]);
        cursor = (cursor+input[i]+skip_size)%LIST_SIZE;
        skip_size++;
    }
    
    printf("The first numbers in the list are %i and %i and their product is %i",
            the_list[0], the_list[1], the_list[0]*the_list[1]);
    

    return 0;
}
