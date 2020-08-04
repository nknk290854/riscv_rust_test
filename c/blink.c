#include <poyoio.h>

int hello_world(){
  serial_write('H');
  serial_write('E');
  serial_write('L');
  serial_write('L');
  serial_write('O');
  serial_write(' ');
  serial_write('W');
  serial_write('O');
  serial_write('R');
  serial_write('L');
  serial_write('D');
}

int main() {

  int i=0;
  hello_world();
    while(1){
	hello_world();
        digital_write(0, i&1);
        digital_write(1, (i>>1)&1);
	digital_write(2, (i>>2)&1);
	digital_write(3, (i>>4)&1);
        delay(1000);
	i++;
    }

    return 0;

}
