void kmain() {
    char* video_memory = (char*) 0xB8000;
    char* message = "Welcome to calcOS";
    int i = 0;

    while (message[i] != '\0') {
        video_memory[i * 2] = message[i];
        video_memory[i * 2 + 1] = 0x07;
        i++;
    }

    while (1);
}
