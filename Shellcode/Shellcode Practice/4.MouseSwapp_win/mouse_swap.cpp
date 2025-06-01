#include <Windows.h>

// SwapMouseButton function prototype
typedef BOOL (WINAPI *fSwapMouseButton)(BOOL);

int main()
{
    // Declare the function pointer
    fSwapMouseButton FunctionPointer;

    // Load & get the address of user32.dll library
    HMODULE user = LoadLibraryA("user32.dll"); // or LoadLibrary(L"user32.dll") if using Unicode

    

    // Get the address of the SwapMouseButton function
    FunctionPointer = (fSwapMouseButton)GetProcAddress(user, "SwapMouseButton");

    

    // Call the function
    FunctionPointer(TRUE); // Swap mouse buttons

    return 0;
}

