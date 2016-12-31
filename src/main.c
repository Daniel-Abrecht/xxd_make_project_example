#include <stdio.h>
#include <files.h>

int main( void ){
  fwrite(__test,__test_len,1,stdout);
  fwrite(__folder_hello_html,__folder_hello_html_len,1,stdout);
  return 0;
}
