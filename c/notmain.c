
//-------------------------------------------------------------------
//-------------------------------------------------------------------
#include <poyoio.h>

extern const void * _heap_start;
extern const void * _heap_end;


unsigned int get_heap_start(){
  return (unsigned int)(_heap_start);
}

unsigned int get_heap_end(){
  return (unsigned int)(_heap_end);
}

void digital_write(int pin, int vol) {

    volatile char* output_addr = GPO_WRADDR;
    volatile int* input_addr = GPO_RDADDR;

    // 0ビット目は0ピンの状態、1ビット目は1ピンの状態というように値を格納しているので、
    // ピンの値に応じたビットのみを変更する
    if (vol == 1) {
        *output_addr = (*input_addr | (1 << pin));
    } else if (vol == 0) {
        *output_addr = (*input_addr & ~(1 << pin));
    }
}


int digital_read(int pin) {

    volatile int* input_addr = GPI_ADDR;
    int vol;

    // 0ビット目は0ピンの状態、1ビット目は1ピンの状態というように値を格納しているので、
    // ピンの値に応じて特定ビットを読み出す
    vol = (*input_addr >> pin) & 1;

    return vol;
}


void serial_write(char c) {

    volatile char* output_addr = UART_TX_ADDR;

    delay(UART_TX_DELAY_TIME);
    *output_addr = c;
}


char serial_read() {
    
    volatile int* input_addr = UART_RX_ADDR;
    int c;

    c = *input_addr;

    delay(UART_TX_DELAY_TIME);
    while((c & 256) !=0){c = *input_addr;}
    delay(UART_TX_DELAY_TIME/2);
    while((c & 256) ==0){c = *input_addr;}
    return c;
}


void delay(unsigned int time) {
    
    volatile unsigned int* input_addr = HARDWARE_COUNTER_ADDR;
    unsigned int start_cycle = *input_addr;

    while (time > 0) {
        while ((*input_addr - start_cycle) >= HARDWARE_COUNT_FOR_ONE_MSEC) {
            time--;
            start_cycle += HARDWARE_COUNT_FOR_ONE_MSEC;
        }
        if (*input_addr < start_cycle) {
            start_cycle = *input_addr;
        }
    }
}


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

int not_main() {

  int i=0;
  hello_world();
  
    while(i<5){
        digital_write(0, i&1);
        digital_write(1, (i>>1)&1);
	hello_world();
	digital_write(2, (i>>2)&1);
	digital_write(3, (i>>4)&1);
        delay(1000);
	i++;
    }

    return 0;

}

void uart_put(char c){
  serial_write(c);
}

unsigned int uart_get(){
  return serial_read();
}

void notmain() {
  digital_write(0, 1);
  digital_write(1, 1);
  not_main();
}

